local M = {}

local syncing = false
local augroup = vim.api.nvim_create_augroup("MdPreviewSync", { clear = true })
local last_anchor = nil
local poll_timer = nil
local chrome_window_id = nil

--- Convert a markdown heading to a GFM-style anchor
local function heading_to_anchor(text)
  local anchor = text
    :lower()
    :gsub("[^%w%s%-]", "") -- strip punctuation except hyphens
    :gsub("%s+", "-") -- spaces to hyphens
    :gsub("%-+", "-") -- collapse multiple hyphens
    :gsub("^%-", "") -- trim leading
    :gsub("%-$", "") -- trim trailing
  return anchor
end

--- Find the nearest heading at or above the given line
local function find_nearest_heading(buf, line)
  for i = line, 1, -1 do
    local text = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
    if text then
      local heading = text:match("^#+%s+(.+)")
      if heading then
        return heading_to_anchor(heading)
      end
    end
  end
  return nil
end

--- Scroll Chrome to an anchor via AppleScript (targets specific window by ID)
local function scroll_chrome_to(anchor)
  if not anchor or anchor == last_anchor or not chrome_window_id then
    return
  end
  last_anchor = anchor
  local js = string.format(
    "document.getElementById('%s')?.scrollIntoView({behavior:'smooth',block:'start'})",
    anchor
  )
  local script = string.format(
    [[tell application "Google Chrome"
      set targetId to "%s"
      repeat with w in windows
        if ((id of w) as text) = targetId then
          execute active tab of w javascript "%s"
          exit repeat
        end if
      end repeat
    end tell]],
    tostring(chrome_window_id),
    js
  )
  vim.system({ "osascript", "-e", script }, { text = true })
end

--- Poll whether the specific Chrome window is still open
local function start_poll(win_id)
  if poll_timer then
    poll_timer:stop()
    poll_timer:close()
  end
  poll_timer = vim.uv.new_timer()
  poll_timer:start(2000, 2000, function()
    local script = string.format(
      [[tell application "Google Chrome"
        set targetId to "%s"
        set found to false
        repeat with w in windows
          if ((id of w) as text) = targetId then
            set found to true
          end if
        end repeat
        return found
      end tell]],
      tostring(win_id)
    )
    vim.system({ "osascript", "-e", script }, { text = true }, function(result)
      vim.schedule(function()
        local out = (result.stdout or ""):gsub("%s+", "")
        if out == "false" and syncing then
          M.sync_stop()
          -- Focus Ghostty and move mouse into it
          vim.system({ "aerospace", "workspace", "T" }, { text = true }, function()
            vim.system({ "aerospace", "move-mouse", "window-force-center" })
          end)
        end
      end)
    end)
  end)
end

--- Run a system command synchronously in the background, return result
local function run(cmd)
  local result = vim.system(cmd, { text = true }):wait()
  return result
end

--- Open markdown in Chrome tiled with Ghostty via AeroSpace
function M.open()
  if vim.bo.filetype ~= "markdown" then
    vim.notify("Not a markdown file", vim.log.levels.WARN)
    return
  end

  -- Stop any existing session
  if syncing then
    M.sync_stop()
  end

  if vim.bo.modified then
    vim.cmd("silent write")
  end

  local file_url = "file://" .. vim.fn.expand("%:p")

  -- Run the whole sequence in a coroutine to keep it readable
  vim.schedule(function()
    -- 1. Open Chrome window and get its ID
    local script = string.format(
      [[tell application "Google Chrome"
        set newWindow to make new window
        set URL of active tab of newWindow to "%s"
        return id of newWindow
      end tell]],
      file_url
    )
    local result = run({ "osascript", "-e", script })
    if result.code ~= 0 then
      vim.notify("AppleScript error: " .. (result.stderr or ""), vim.log.levels.ERROR)
      return
    end

    local raw = (result.stdout or ""):gsub("%s+", "")
    local win_id = tonumber(raw)
    if not win_id then
      vim.notify("Could not get Chrome window ID", vim.log.levels.WARN)
      return
    end
    chrome_window_id = win_id

    -- 2. Find the AeroSpace window ID for the new Chrome window
    result = run({ "aerospace", "list-windows", "--all", "--json" })
    local ok, windows = pcall(vim.json.decode, result.stdout or "[]")
    if not ok then
      vim.notify("Could not parse AeroSpace windows", vim.log.levels.WARN)
      return
    end

    local aero_win_id = nil
    for _, w in ipairs(windows) do
      if w["app-name"] == "Google Chrome" then
        if not aero_win_id or w["window-id"] > aero_win_id then
          aero_win_id = w["window-id"]
        end
      end
    end

    if not aero_win_id then
      vim.notify("Could not find Chrome in AeroSpace", vim.log.levels.WARN)
      return
    end

    -- 3. Set horizontal tiling on current workspace
    run({ "aerospace", "layout", "tiles", "horizontal" })

    -- 4. Move Chrome window to Terminal workspace
    run({
      "aerospace", "move-node-to-workspace",
      "--window-id", tostring(aero_win_id),
      "T",
    })

    -- 5. Focus back to Ghostty
    result = run({ "aerospace", "list-windows", "--workspace", "T", "--json" })
    ok, windows = pcall(vim.json.decode, result.stdout or "[]")
    if ok then
      for _, w in ipairs(windows) do
        if w["app-name"] == "Ghostty" then
          run({ "aerospace", "focus", "--window-id", tostring(w["window-id"]) })
          break
        end
      end
    end

    -- 6. Start sync and polling
    M.sync_start()
    start_poll(win_id)
  end)
end

--- Start scroll sync
function M.sync_start()
  if syncing then
    return
  end
  syncing = true
  last_anchor = nil

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "WinScrolled" }, {
    group = augroup,
    buffer = 0,
    callback = function()
      if not syncing then
        return
      end
      local line = vim.fn.line("w0") -- top visible line
      local anchor = find_nearest_heading(0, line)
      if anchor then
        scroll_chrome_to(anchor)
      end
    end,
  })

  -- Also sync on save so Chrome picks up content changes
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup,
    buffer = 0,
    callback = function()
      if not syncing then
        return
      end
      last_anchor = nil -- force re-scroll after reload
      vim.defer_fn(function()
        local line = vim.fn.line("w0")
        local anchor = find_nearest_heading(0, line)
        if anchor then
          scroll_chrome_to(anchor)
        end
      end, 500) -- delay for Chrome to reload
    end,
  })

  vim.notify("Markdown scroll sync: ON", vim.log.levels.INFO)
end

--- Stop scroll sync
function M.sync_stop()
  syncing = false
  last_anchor = nil
  chrome_window_id = nil
  vim.api.nvim_clear_autocmds({ group = augroup })
  if poll_timer then
    poll_timer:stop()
    poll_timer:close()
    poll_timer = nil
  end
  vim.notify("Markdown scroll sync: OFF", vim.log.levels.INFO)
end

--- Toggle scroll sync
function M.sync_toggle()
  if syncing then
    M.sync_stop()
  else
    M.sync_start()
  end
end

return M
