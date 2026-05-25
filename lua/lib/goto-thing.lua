local M = {}

-------------------------------------------------------------------------------
-- Built-in actions
-------------------------------------------------------------------------------
local actions = {}

--- Open a URL in the system browser
function actions.url(url)
  -- Trim trailing punctuation that's likely not part of the URL
  url = url:gsub("[%)%]>\"',;]+$", "")
  vim.ui.open(url)
  vim.notify("Opening URL: " .. url, vim.log.levels.INFO)
end

--- Open a local file or directory
function actions.path(path)
  local expanded = vim.fn.expand(path)
  local resolved = vim.fn.resolve(expanded)

  -- Try relative to current file directory if not absolute
  if vim.fn.filereadable(resolved) == 0 and vim.fn.isdirectory(resolved) == 0 then
    local dir = vim.fn.expand("%:h")
    resolved = vim.fn.resolve(dir .. "/" .. expanded)
  end

  if vim.fn.isdirectory(resolved) == 1 then
    require("mini.files").open(resolved, true)
  elseif vim.fn.filereadable(resolved) == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(resolved))
  else
    vim.notify("Path not found: " .. path, vim.log.levels.WARN)
  end
end

--- Open Terraform registry docs for a resource type
function actions.terraform_resource_docs(resource_type)
  local provider, resource = resource_type:match("^(%w+)_(.+)$")
  if not provider then
    vim.notify("Could not parse resource type: " .. resource_type, vim.log.levels.WARN)
    return
  end
  local url = string.format(
    "https://registry.terraform.io/providers/hashicorp/%s/latest/docs/resources/%s",
    provider,
    resource
  )
  vim.ui.open(url)
  vim.notify("Opening docs: " .. resource_type, vim.log.levels.INFO)
end

--- Open Terraform registry docs for a data source type
function actions.terraform_data_docs(data_type)
  local provider, resource = data_type:match("^(%w+)_(.+)$")
  if not provider then
    vim.notify("Could not parse data source type: " .. data_type, vim.log.levels.WARN)
    return
  end
  local url = string.format(
    "https://registry.terraform.io/providers/hashicorp/%s/latest/docs/data-sources/%s",
    provider,
    resource
  )
  vim.ui.open(url)
  vim.notify("Opening docs: data." .. data_type, vim.log.levels.INFO)
end

--- Navigate to a Terraform module source (clone/open locally)
function actions.terraform_module(source_url)
  -- Local path sources: delegate to path action
  if source_url:match("^%.") or source_url:match("^/") or source_url:match("^~") then
    actions.path(source_url)
    return
  end

  -- Registry module (e.g., "hashicorp/consul/aws")
  if source_url:match("^%w+/[%w%-]+/[%w%-]+$") or source_url:match("^registry%.terraform%.io/") then
    local namespace, name, provider = source_url:match("([%w%-]+)/([%w%-]+)/([%w%-]+)$")
    if namespace and name and provider then
      local url = string.format(
        "https://registry.terraform.io/modules/%s/%s/%s/latest",
        namespace,
        name,
        provider
      )
      vim.ui.open(url)
      vim.notify("Opening registry: " .. source_url, vim.log.levels.INFO)
      return
    end
  end

  local repo_name, module_path, ref_tag, clone_url, is_katlean, org

  -- Parse SSH URL: git@github.com:Org/repo[.git][//path][?ref=tag]
  if source_url:match("^git@github%.com:") then
    org, repo_name = source_url:match("git@github%.com:([^/]+)/([^//?]+)")
    if repo_name then
      repo_name = repo_name:gsub("%.git$", "")
      module_path = source_url:match("//([^?]*)")
      ref_tag = source_url:match("ref=([^&]*)")
      clone_url = "git@github.com:" .. org .. "/" .. repo_name .. ".git"
      is_katlean = (org == "Katlean")
    end
  -- Parse public GitHub URL: github.com/org/repo[//path][?ref=tag]
  elseif source_url:match("github%.com/") then
    org, repo_name = source_url:match("github%.com/([^/]+)/([^/?]+)")
    if org and repo_name then
      module_path = source_url:match("github%.com/[^/]+/[^/?]+/([^?]*)")
      ref_tag = source_url:match("ref=([^&]*)")
      clone_url = "https://github.com/" .. org .. "/" .. repo_name .. ".git"
      is_katlean = (org == "Katlean")
    end
  end

  if not repo_name then
    vim.notify("Could not parse module source: " .. source_url, vim.log.levels.WARN)
    return
  end

  local base_repo_path = vim.fn.expand("~/code/" .. repo_name)
  local is_worktree_structure = false
  local default_branch = nil

  -- Detect worktree structure (no .git in base directory)
  if vim.fn.isdirectory(base_repo_path) == 1 and vim.fn.isdirectory(base_repo_path .. "/.git") == 0 then
    is_worktree_structure = true
    local remote_cmd = string.format("git ls-remote --symref %s HEAD", clone_url)
    local remote_result = vim.fn.system(remote_cmd)
    if vim.v.shell_error == 0 then
      default_branch = remote_result:match("ref: refs/heads/([^\t\n]*)")
    end
    if not default_branch then
      local ls_result = vim.fn.system(string.format("ls %s", base_repo_path))
      if ls_result:match("main") then
        default_branch = "main"
      elseif ls_result:match("master") then
        default_branch = "master"
      else
        default_branch = "main"
      end
    end
  end

  -- Determine repo path
  local repo_path
  if is_worktree_structure then
    repo_path = base_repo_path .. "/" .. default_branch
    if vim.fn.isdirectory(repo_path) == 0 then
      if vim.fn.isdirectory(base_repo_path) == 0 then
        vim.fn.system(string.format("mkdir -p %s", base_repo_path))
        local result = vim.fn.system(string.format("cd %s && git clone --bare %s .git", base_repo_path, clone_url))
        if vim.v.shell_error ~= 0 then
          vim.notify("Failed to clone repository: " .. result, vim.log.levels.ERROR)
          return
        end
      end
      local result = vim.fn.system(
        string.format("cd %s && git worktree add %s %s", base_repo_path, default_branch, default_branch)
      )
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to create worktree: " .. result, vim.log.levels.ERROR)
        return
      end
      vim.notify("Created worktree for " .. default_branch, vim.log.levels.INFO)
    else
      if is_katlean or not ref_tag then
        local result = vim.fn.system(string.format("cd %s && git pull origin %s", repo_path, default_branch))
        if vim.v.shell_error ~= 0 then
          vim.notify("Failed to pull: " .. result, vim.log.levels.WARN)
        else
          vim.notify("Updated " .. repo_name .. " to latest " .. default_branch, vim.log.levels.INFO)
        end
      end
    end
  else
    repo_path = base_repo_path
    if vim.fn.isdirectory(repo_path) == 0 then
      vim.notify("Cloning " .. repo_name .. "...", vim.log.levels.INFO)
      local result = vim.fn.system(string.format("cd ~/code && git clone %s", clone_url))
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to clone: " .. result, vim.log.levels.ERROR)
        return
      end
      vim.notify("Cloned " .. repo_name, vim.log.levels.INFO)
    else
      if is_katlean or not ref_tag then
        local current_branch = vim.fn.system(string.format("cd %s && git branch --show-current", repo_path))
          :gsub("%s+", "")
        local db_cmd = string.format(
          "cd %s && git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'",
          repo_path
        )
        default_branch = vim.fn.system(db_cmd):gsub("%s+", "")
        if vim.v.shell_error ~= 0 or default_branch == "" then
          default_branch = (current_branch == "main" or current_branch == "master") and current_branch or "main"
        end
        if current_branch ~= default_branch then
          local result = vim.fn.system(string.format("cd %s && git checkout %s", repo_path, default_branch))
          if vim.v.shell_error ~= 0 then
            vim.notify("Failed to checkout " .. default_branch .. ": " .. result, vim.log.levels.ERROR)
            return
          end
        end
        local result = vim.fn.system(string.format("cd %s && git pull origin %s", repo_path, default_branch))
        if vim.v.shell_error ~= 0 then
          vim.notify("Failed to pull: " .. result, vim.log.levels.WARN)
          return
        end
        vim.notify("Updated " .. repo_name .. " to latest " .. default_branch, vim.log.levels.INFO)
      end
    end
  end

  -- Handle ref tags
  if ref_tag then
    local ref_worktree_path
    if is_worktree_structure then
      ref_worktree_path = base_repo_path .. "/" .. ref_tag
    else
      ref_worktree_path = vim.fn.expand("~/code/" .. repo_name .. "-" .. ref_tag)
    end
    if vim.fn.isdirectory(ref_worktree_path) == 0 then
      vim.notify("Creating worktree for ref: " .. ref_tag, vim.log.levels.INFO)
      local worktree_cmd
      if is_worktree_structure then
        worktree_cmd = string.format("cd %s && git worktree add ../%s %s", repo_path, ref_tag, ref_tag)
      else
        worktree_cmd = string.format("cd %s && git worktree add %s %s", repo_path, ref_worktree_path, ref_tag)
      end
      local result = vim.fn.system(worktree_cmd)
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to create worktree: " .. result, vim.log.levels.ERROR)
        return
      end
      vim.notify("Created worktree for " .. ref_tag, vim.log.levels.INFO)
    end
    repo_path = ref_worktree_path
  end

  -- Build final path and open
  local local_path = repo_path
  if module_path and module_path ~= "" then
    local_path = local_path .. "/" .. module_path
  end
  if vim.fn.isdirectory(local_path) == 1 then
    require("mini.files").open(local_path, true)
  else
    vim.notify("Module path not found: " .. local_path, vim.log.levels.WARN)
  end
end

--- Open a man page in a Neovim split
function actions.man(cmd)
  cmd = cmd:gsub("[;#|&%s]+$", "")
  local ok = pcall(vim.cmd, "Man " .. cmd)
  if not ok then
    vim.notify("No man page for: " .. cmd, vim.log.levels.WARN)
  end
end

-- Expose actions for custom rules
M.actions = actions

-------------------------------------------------------------------------------
-- Default rules
-------------------------------------------------------------------------------
M.rules = {
  {
    ft = { "terraform" },
    patterns = {
      { 'source%s*=%s*"([^"]*)"', actions.terraform_module },
      { '^%s*resource%s+"([^"]+)"', actions.terraform_resource_docs },
      { '^%s*data%s+"([^"]+)"', actions.terraform_data_docs },
    },
  },
  {
    ft = { "sh", "bash", "zsh" },
    patterns = {
      -- source/dot imports (unquoted): source ./lib/helpers.sh, . /etc/foo.sh
      { 'source%s+([%w%.%-_~/][^%s;#|&]*)', actions.path },
      { '^%s*%.%s+([%w%.%-_~/][^%s;#|&]*)', actions.path },
    },
  },
  {
    ft = { "*" },
    patterns = {
      { "(https?://[%w%.%-_/%%?&=#:@!%$%(%)%*%+,;~]+)", actions.url },
      { '["\'](%./[^"\']+)["\']', actions.path },
      { '["\'](%.\\.%./[^"\']+)["\']', actions.path },
      { '["\']([~/][^"\']+)["\']', actions.path },
    },
  },
}

-------------------------------------------------------------------------------
-- Core: try to match current line against rules
-------------------------------------------------------------------------------

--- Find a match at the cursor position, or fall back to first match on line
---@param line string
---@param col number 1-indexed cursor column
---@param pattern string Lua pattern
---@return string|nil capture The first capture group, or full match if no capture
local function find_match_at_cursor(line, col, pattern)
  local best_capture = nil
  local search_start = 1

  while search_start <= #line do
    local s, e, capture = line:find(pattern, search_start)
    if not s then
      break
    end
    -- Save first match as fallback
    if not best_capture then
      best_capture = capture or line:sub(s, e)
    end
    -- Prefer match under cursor
    if col >= s and col <= e then
      return capture or line:sub(s, e)
    end
    search_start = e + 1
  end

  return best_capture
end

--- Main entry point: open the thing under the cursor
function M.goto_thing()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local ft = vim.bo.filetype

  for _, rule in ipairs(M.rules) do
    local ft_match = false
    for _, f in ipairs(rule.ft) do
      if f == "*" or f == ft then
        ft_match = true
        break
      end
    end

    if ft_match then
      for _, pat_def in ipairs(rule.patterns) do
        local pattern, action = pat_def[1], pat_def[2]
        local capture = find_match_at_cursor(line, col, pattern)
        if capture then
          action(capture)
          return
        end
      end
    end
  end

  -- Fallback: in shell files, try man page for word under cursor
  local shell_fts = { sh = true, bash = true, zsh = true }
  if shell_fts[ft] then
    local cword = vim.fn.expand("<cword>")
    if cword ~= "" then
      actions.man(cword)
      return
    end
  end

  vim.notify("No matching pattern found on this line", vim.log.levels.INFO)
end

-------------------------------------------------------------------------------
-- Setup
-------------------------------------------------------------------------------

--- Configure goto-thing
---@param opts? { keymap?: string, rules?: table, extra_rules?: table }
function M.setup(opts)
  opts = opts or {}

  if opts.rules then
    M.rules = opts.rules
  end

  -- Merge extra rules (prepended so they take priority)
  if opts.extra_rules then
    for i = #opts.extra_rules, 1, -1 do
      table.insert(M.rules, 1, opts.extra_rules[i])
    end
  end

  local keymap = opts.keymap or "<leader>gO"
  vim.keymap.set("n", keymap, M.goto_thing, { desc = "[P] Go to thing under cursor" })
end

return M
