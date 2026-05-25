local M = {}

--- Track directories where init is already running or completed this session
local init_state = {}

--- Get the terraform stack directory for a buffer
local function get_stack_dir(buf)
  local file_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":p:h")
  -- If the file is in an /env subdirectory, the stack root is one level up
  if file_dir:match("/env$") then
    file_dir = file_dir:gsub("/env$", "")
  end
  return file_dir
end

--- Check if .terraform is initialized and looks fresh
local function needs_init(stack_dir)
  local tf_dir = stack_dir .. "/.terraform"
  if vim.fn.isdirectory(tf_dir) == 0 then
    return true
  end
  -- If lock file is missing, needs init
  if vim.fn.filereadable(stack_dir .. "/.terraform.lock.hcl") == 0 then
    return true
  end
  return false
end

--- Restart terraformls for buffers in a specific stack.
--- Detaches buffers from their current client, stops orphaned clients,
--- then re-triggers FileType so lspconfig re-evaluates root_dir
--- (now finding .terraform in the stack dir instead of falling back to .git).
local function restart_lsp_for_stack(stack_dir)
  local bufs_in_stack = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      local ft = vim.bo[buf].filetype
      if (ft == "terraform" or ft == "terraform-vars") and get_stack_dir(buf) == stack_dir then
        table.insert(bufs_in_stack, buf)
      end
    end
  end

  if #bufs_in_stack == 0 then
    return
  end

  -- Detach these buffers and clear stale diagnostics from the old client
  local clients_to_check = {}
  for _, buf in ipairs(bufs_in_stack) do
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, name = "terraformls" })) do
      clients_to_check[client.id] = client
      vim.diagnostic.reset(client.id, buf)
      vim.lsp.buf_detach_client(buf, client.id)
    end
  end

  -- Stop any client that now has no attached buffers
  for _, client in pairs(clients_to_check) do
    local remaining = vim.lsp.get_buffers_by_client_id(client.id)
    if not remaining or #remaining == 0 then
      client:stop()
    end
  end

  -- Re-trigger FileType so lspconfig starts a new client with correct root_dir
  vim.defer_fn(function()
    for _, buf in ipairs(bufs_in_stack) do
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_exec_autocmds("FileType", { buffer = buf, modeline = false })
      end
    end
  end, 500)
end

--- Run terraform init asynchronously for a stack directory, then restart LSP
function M.ensure_init(buf, stack_dir)
  -- Skip if already handled this session
  if init_state[stack_dir] == "done" or init_state[stack_dir] == "running" then
    return
  end

  if not needs_init(stack_dir) then
    init_state[stack_dir] = "done"
    return
  end

  init_state[stack_dir] = "running"
  vim.notify("terraform init: " .. vim.fn.fnamemodify(stack_dir, ":~"), vim.log.levels.INFO)

  vim.system(
    { "terraform", "init", "-backend=false" },
    { cwd = stack_dir, text = true },
    function(result)
      vim.schedule(function()
        if result.code == 0 then
          init_state[stack_dir] = "done"
          vim.notify("terraform init: done — restarting LSP", vim.log.levels.INFO)
          restart_lsp_for_stack(stack_dir)
        else
          init_state[stack_dir] = nil
          local msg = result.stderr ~= "" and result.stderr or result.stdout
          vim.notify("terraform init failed:\n" .. msg, vim.log.levels.ERROR)
        end
      end)
    end
  )
end

--- Force re-init for the current buffer's stack directory
function M.force_init()
  local buf = vim.api.nvim_get_current_buf()
  local stack_dir = get_stack_dir(buf)
  init_state[stack_dir] = nil
  M.ensure_init(buf, stack_dir)
end

--- Set up the autocmd
function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "terraform", "terraform-vars" },
    group = vim.api.nvim_create_augroup("TfAutoInit", { clear = true }),
    callback = function(ev)
      local stack_dir = get_stack_dir(ev.buf)
      -- Defer slightly so LSP has time to attach first
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(ev.buf) then
          M.ensure_init(ev.buf, stack_dir)
        end
      end, 100)
    end,
  })

  vim.api.nvim_create_user_command("TfInit", function()
    M.force_init()
  end, { desc = "Force terraform init -backend=false for current stack" })
end

return M
