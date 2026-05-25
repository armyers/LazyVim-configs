local M = {}

--- Get git root and file's repo-relative path for the current buffer
local function get_git_info()
  local git_root = vim.fs.root(0, ".git")
  if not git_root then
    return nil
  end
  local file_path = vim.fn.expand("%:p")
  local rel_path = file_path:gsub("^" .. vim.pesc(git_root) .. "/", "")
  return { root = git_root, rel_path = rel_path }
end

--- Detect the default branch (main or master)
local function get_default_branch(git_root)
  local result = vim.fn.system(
    string.format(
      "cd %s && git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'",
      vim.fn.shellescape(git_root)
    )
  )
  local branch = result:gsub("%s+", "")
  if vim.v.shell_error == 0 and branch ~= "" then
    return branch
  end
  local check = vim.fn.system(string.format("cd %s && git rev-parse --verify main 2>/dev/null", vim.fn.shellescape(git_root)))
  return (vim.v.shell_error == 0 and check ~= "") and "main" or "master"
end

--- Get file contents at a given git ref
local function file_at_ref(git_root, ref, rel_path)
  local cmd = string.format(
    "cd %s && git show %s:%s 2>/dev/null",
    vim.fn.shellescape(git_root),
    vim.fn.shellescape(ref),
    vim.fn.shellescape(rel_path)
  )
  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return result
end

--- Read file contents from disk (last saved state)
local function file_on_disk()
  local path = vim.fn.expand("%:p")
  if vim.fn.filereadable(path) == 0 then
    return nil
  end
  local lines = vim.fn.readfile(path)
  return table.concat(lines, "\n") .. "\n"
end

--- Build the list of picker items
local function build_items(info)
  local items = {}
  local default_branch = get_default_branch(info.root)

  -- 1. Saved file on disk
  table.insert(items, { text = "saved: last saved file state", ref = "__saved__" })

  -- 2. Git index (default)
  table.insert(items, { text = "git: index (staged)", ref = "__git__" })

  -- 3. Default branch
  table.insert(items, { text = "branch: " .. default_branch, ref = default_branch })

  -- 4. Merge-base (PR diff)
  local merge_base = vim.fn
    .system(
      string.format(
        "cd %s && git merge-base HEAD %s 2>/dev/null",
        vim.fn.shellescape(info.root),
        vim.fn.shellescape(default_branch)
      )
    )
    :gsub("%s+", "")
  if vim.v.shell_error == 0 and merge_base ~= "" then
    table.insert(items, {
      text = "merge-base: " .. default_branch .. " (" .. merge_base:sub(1, 8) .. ")",
      ref = merge_base,
    })
  end

  -- 5. Local branches
  local local_branches = vim.fn.systemlist(
    string.format("cd %s && git branch --format='%%(refname:short)' 2>/dev/null", vim.fn.shellescape(info.root))
  )
  for _, branch in ipairs(local_branches) do
    if branch ~= "" then
      table.insert(items, { text = "local: " .. branch, ref = branch })
    end
  end

  -- 6. Remote branches
  local remote_branches = vim.fn.systemlist(
    string.format("cd %s && git branch -r --format='%%(refname:short)' 2>/dev/null", vim.fn.shellescape(info.root))
  )
  for _, branch in ipairs(remote_branches) do
    if branch ~= "" and not branch:match("HEAD") then
      table.insert(items, { text = "remote: " .. branch, ref = branch })
    end
  end

  -- 7. Worktrees
  local worktrees = vim.fn.systemlist(
    string.format("cd %s && git worktree list --porcelain 2>/dev/null", vim.fn.shellescape(info.root))
  )
  local current_root = vim.fn.resolve(info.root)
  for _, line in ipairs(worktrees) do
    local wt_path = line:match("^worktree%s+(.+)")
    if wt_path then
      local resolved = vim.fn.resolve(wt_path)
      if resolved ~= current_root then
        local label = vim.fn.fnamemodify(wt_path, ":t")
        table.insert(items, {
          text = "worktree: " .. label .. " (" .. wt_path .. ")",
          ref = "__worktree__",
          worktree_path = wt_path,
        })
      end
    end
  end

  -- 8. Tags (newest first)
  local tags = vim.fn.systemlist(
    string.format("cd %s && git tag --sort=-version:refname 2>/dev/null", vim.fn.shellescape(info.root))
  )
  for _, tag in ipairs(tags) do
    if tag ~= "" then
      table.insert(items, { text = "tag: " .. tag, ref = tag })
    end
  end

  return items
end

--- Open the diff reference picker
function M.pick()
  local info = get_git_info()
  if not info then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return
  end

  local items = build_items(info)

  Snacks.picker({
    title = "Diff Reference",
    items = items,
    format = "text",
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end

      local ref_text
      if item.ref == "__saved__" then
        ref_text = file_on_disk()
      elseif item.ref == "__worktree__" then
        local wt_file = item.worktree_path .. "/" .. info.rel_path
        if vim.fn.filereadable(wt_file) == 1 then
          local lines = vim.fn.readfile(wt_file)
          ref_text = table.concat(lines, "\n") .. "\n"
        end
      elseif item.ref == "__git__" then
        -- Reset to default git source
        MiniDiff.disable(0)
        MiniDiff.enable(0)
        vim.notify("Diff reference: git index", vim.log.levels.INFO)
        return
      else
        ref_text = file_at_ref(info.root, item.ref, info.rel_path)
      end

      if ref_text then
        MiniDiff.set_ref_text(0, ref_text)
        vim.notify("Diff reference: " .. item.text, vim.log.levels.INFO)
      else
        vim.notify("Could not get file content for: " .. item.text, vim.log.levels.WARN)
      end
    end,
    layout = {
      preset = "select",
    },
  })
end

return M
