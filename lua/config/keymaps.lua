-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- convenience commands for dev/test of lua code
vim.keymap.set("n", "<leader><leader>r", "<cmd>source %<CR>", { desc = "[P] Run the lua code in the current file" })
vim.keymap.set("n", "<leader>r", ":.lua<CR>", { desc = "[P] Run the lua code on the current line" })
vim.keymap.set("v", "<leader>r", ":lua<CR>", { desc = "[P] Run the lua code in the visual selection" })

-- vim.keymap.set("n", ";", ":", { desc = "Command mode" })
vim.keymap.set("n", "_", "<cmd>split<cr>", { desc = "[P] window Horizontal Split" })
vim.keymap.set("n", "|", "<cmd>vsplit<cr>", { desc = "[P] window Vertical Split" })
vim.keymap.set("n", "<A-h>", "<C-w><", { desc = "[P] window decrease width" })
vim.keymap.set("n", "<A-l>", "<C-w>>", { desc = "[P] window increase width" })
vim.keymap.set("n", "<A-k>", "<C-w>+", { desc = "[P] window increase height" })
vim.keymap.set("n", "<A-j>", "<C-w>-", { desc = "[P] window decrease height" })
vim.keymap.set("n", "<A-=>", "<C-w>=", { desc = "[P] window equalize sizes" })
-- mnemonic: <A-\\> is really <A-|>
vim.keymap.set("n", "<A-\\>", "<C-w>|", { desc = "[P] window maximize width" })
-- mnemonic: <A--> is really <A-_>
vim.keymap.set("n", "<A-->", "<C-w>_", { desc = "[P] window maximize height" })
vim.keymap.set("n", "<A-m>", "<C-w>_<C-w>|", { desc = "[P] window maximize W and H" })
vim.keymap.set("n", "<C-g>", "1<C-g>", { desc = "[P] show current file/buffer details" })

-- snippets
vim.keymap.set("n", "<leader>Se", function()
  require("scissors").editSnippet()
end, { desc = "[P] Edit snippet" })

-- When used in visual mode prefills the selection as body.
vim.keymap.set({ "n", "x" }, "<leader>Sa", function()
  require("scissors").addNewSnippet()
end, { desc = "[P] Add new snippet" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[P] Yank to system clipboard" })
vim.keymap.set({ "n" }, "<leader>dd", [["+dd]])
vim.keymap.set({ "n" }, "<leader>D", [["+d$]])
vim.keymap.set({ "v" }, "<leader>d", [["+d]])

-- mini.files
vim.keymap.set("n", "<leader>fC", function()
  require("mini.files").open("~/code", true)
end, { desc = "[P] MiniFiles ~/code" })

vim.keymap.set("n", "<leader>G", function()
  require("snacks").picker.grep({ cwd = "~/code" })
end, { desc = "[P] snacks picker grep ~/code" })

vim.keymap.set("n", "<leader>fz", function()
  require("snacks").picker.zoxide()
end, { desc = "[P] snacks picker zoxide session" })

vim.keymap.set("n", "<leader>fN", function()
  require("snacks").picker.files({ dirs = { "~/.config/nvim", "~/.local/share/nvim" } })
end, { desc = "[P] snacks picker files ~/.config/nvim ~/.local/share/nvim" })

vim.keymap.set("n", "<leader>sN", function()
  require("snacks").picker.grep({ dirs = { "~/.config/nvim", "~/.local/share/nvim" } })
end, { desc = "[P] snacks picker grep ~/.config/nvim ~/.local/share/nvim" })

vim.keymap.set("n", "<leader>F", function()
  require("snacks").picker.files({ cwd = "~/code" })
end, { desc = "[P] snacks picker files ~/code" })

vim.keymap.set("n", "<leader>H", function()
  require("snacks").picker.files({ cwd = "~" })
end, { desc = "[P] snacks picker files ~" })

vim.keymap.set("n", "<leader>bC", function()
  require("snacks").bufdelete.all()
end, { desc = "[P] Close all buffers" })

vim.keymap.set("n", "<leader>db", function()
  require("snacks").dashboard.open()
end, { desc = "[P] Dashboard" })

-- display git log history for selected text lines
vim.keymap.set("v", "<leader>gl", function()
  local git_root = vim.fs.root(0, ".git")
  if type(git_root) ~= "string" then
    print("No git root found")
    return
  end

  local dir = vim.uv.cwd()
  if type(dir) == "nil" then
    print("Nil cwd")
    return
  end
  if dir:match(git_root) == "nil" then
    print("Git root not in cwd")
    return
  end

  local line1 = vim.fn.getpos("v")[2]
  local line2 = vim.fn.getcurpos()[2]
  local rooted_name = vim.fn.expand("%:p"):gsub(git_root .. "/", "", 1)
  local range = "-L" .. line1 .. "," .. line2 .. ":" .. rooted_name
  require("neogit").action("log", "log_current", { range, "--no-patch" })()
end, { desc = "[P] Show git log history (neogit)" })

-- folds
vim.keymap.set("n", "z0", function()
  vim.opt.foldlevel = 0
end, { desc = "[P] foldlevel=0" })

vim.keymap.set("n", "z1", function()
  vim.opt.foldlevel = 1
end, { desc = "[P] foldlevel=1" })

vim.keymap.set("n", "z2", function()
  vim.opt.foldlevel = 2
end, { desc = "[P] foldlevel=2" })

vim.keymap.set("n", "z3", function()
  vim.opt.foldlevel = 3
end, { desc = "[P] foldlevel=3" })

vim.keymap.set("n", "z4", function()
  vim.opt.foldlevel = 4
end, { desc = "[P] foldlevel=4" })

vim.keymap.set("n", "z5", function()
  vim.opt.foldlevel = 5
end, { desc = "[P] foldlevel=5" })

-- toggle showkeys
vim.keymap.set("n", "<leader>kt", "<cmd>ShowkeysToggle<CR>", { desc = "[P] ShowkeysToggle" })

-- toggle zenmode
vim.keymap.set("n", "<leader>Z", '<cmd>lua require("zen-mode").toggle()<CR>', { desc = "[P] ZenMode toggle" })

vim.keymap.set(
  "n",
  "<leader>kk",
  '<cmd>lua require("kubectl").toggle()<CR>',
  { noremap = true, silent = true, desc = "[P] Kubectl toggle" }
)

-- vim.keymap.set({ "n", "x" }, "<leader>aa", "<cmd>CopilotChat<CR>", { desc = "[P] CopilotChat toggle" })

-- vim.keymap.set(
--   { "n", "x" },
--   "<leader>aa",
--   "<cmd>CodeCompanionChat Toggle<CR>",
--   { desc = "[P] CodeCompanionChat toggle" }
-- )
-- vim.keymap.set({ "n", "x" }, "<leader>ai", "<cmd>CodeCompanion<CR>", { desc = "[P] CodeCompanion inline" })

vim.keymap.set("n", "<leader>do", "<cmd>lua MiniDiff.toggle_overlay()<CR>", { desc = "[P] mini-diff overlay toggle" })

-- Markdown browser preview with scroll sync
vim.keymap.set("n", "<leader>mp", function()
  require("lib.md-preview").open()
end, { desc = "[P] Preview markdown in browser (tiled + scroll sync)" })

vim.keymap.set("n", "<leader>ms", function()
  require("lib.md-preview").sync_toggle()
end, { desc = "[P] Toggle markdown scroll sync" })

-- Terraform module navigation (delegates to goto-thing)
vim.keymap.set("n", "<leader>gt", function()
  require("lib.goto-thing").goto_thing()
end, { desc = "[P] Open the thing on current line" })

-- Custom gf to use mini.files for directories
vim.keymap.set("n", "gf", function()
  local file_path = vim.fn.expand("<cfile>")
  if file_path == "" then
    return
  end

  -- Try to resolve relative paths
  local full_path = vim.fn.resolve(file_path)
  if vim.fn.filereadable(full_path) == 0 and vim.fn.isdirectory(full_path) == 0 then
    -- Try relative to current file
    local current_file_dir = vim.fn.expand("%:h")
    full_path = current_file_dir .. "/" .. file_path
    full_path = vim.fn.resolve(full_path)
  end

  if vim.fn.isdirectory(full_path) == 1 then
    require("mini.files").open(full_path, true)
  elseif vim.fn.filereadable(full_path) == 1 then
    vim.cmd("edit " .. full_path)
  else
    -- Fall back to default gf behavior
    vim.cmd("normal! gf")
  end
end, { desc = "[P] Go to file (use mini.files for directories)" })

-- Override LazyVim's <leader>e and <leader>E to use mini.files instead of snacks explorer
vim.keymap.set("n", "<leader>e", function()
  require("mini.files").open(vim.uv.cwd(), true)
end, { desc = "[P] Explorer mini.files (cwd)" })

vim.keymap.set("n", "<leader>E", function()
  local root = vim.fs.root(0, ".git") or vim.uv.cwd()
  require("mini.files").open(root, true)
end, { desc = "[P] Explorer mini.files (root dir)" })

-- disable lazygit by setting its keymaps to nil
vim.keymap.del("n", "<leader>gg", {})
vim.keymap.del("n", "<leader>gG", {})
