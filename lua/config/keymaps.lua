-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local km_set = vim.keymap.set
local km_del = vim.keymap.del

-- toggle zenmode
km_set("n", "<leader><leader>r", "<cmd>source %<CR>", { desc = "[P] Run the lua code in the current file" })
km_set("n", "<leader>r", ":.lua<CR>", { desc = "[P] Run the lua code on the current line" })
km_set("v", "<leader>r", ":lua<CR>", { desc = "[P] Run the lua code in the visual selection" })

-- km_set("n", ";", ":", { desc = "Command mode" })
km_set("n", "_", "<cmd>split<cr>", { desc = "[P] window Horizontal Split" })
km_set("n", "|", "<cmd>vsplit<cr>", { desc = "[P] window Vertical Split" })
km_set("n", "<A-h>", "<C-w><", { desc = "[P] window decrease width" })
km_set("n", "<A-l>", "<C-w>>", { desc = "[P] window increase width" })
km_set("n", "<A-k>", "<C-w>+", { desc = "[P] window increase height" })
km_set("n", "<A-j>", "<C-w>-", { desc = "[P] window decrease height" })
km_set("n", "<A-=>", "<C-w>=", { desc = "[P] window equalize sizes" })
-- mnemonic: <A-\\> is really <A-|>
km_set("n", "<A-\\>", "<C-w>|", { desc = "[P] window maximize width" })
-- mnemonic: <A--> is really <A-_>
km_set("n", "<A-->", "<C-w>_", { desc = "[P] window maximize height" })
km_set("n", "<A-m>", "<C-w>_<C-w>|", { desc = "[P] window maximize W and H" })
km_set("n", "<C-g>", "1<C-g>", { desc = "[P] show current file/buffer details" })

-- disable lazygit by setting its keymaps to nil
km_del("n", "<leader>gg", {})
km_del("n", "<leader>gG", {})

-- -- snippets
-- km_set("n", "<leader>Se", function()
--   require("scissors").editSnippet()
-- end, { desc = "[P] Edit snippet" })
--
-- -- When used in visual mode prefills the selection as body.
-- km_set({ "n", "x" }, "<leader>Sa", function()
--   require("scissors").addNewSnippet()
-- end, { desc = "[P] Add new snippet" })

-- When searching for stuff, search results show in the middle
-- km_set("n", "n", "nzz", { desc = "[P] goto next match; move line to middle" })
-- km_set("n", "N", "Nzz", { desc = "[P] goto prev match; move line to middle" })

-- use gh to move to the beginning of the line in normal mode
-- use gl to move to the end of the line in normal mode
km_set({ "n", "v" }, "gb", "^", { desc = "[P] Go to the beginning line" })
km_set({ "n", "v" }, "gl", "$", { desc = "[P] go to the end of the line" })
-- In visual mode, after going to the end of the line, come back 1 character
km_set("v", "gl", "$h", { desc = "[P] Go to the end of the line" })

-- yank selected text into system clipboard
-- Vim/Neovim has two clipboards: unnamed register (default) and system clipboard.
--
-- Yanking with `y` goes to the unnamed register, accessible only within Vim.
-- The system clipboard allows sharing data between Vim and other applications.
-- Yanking with `"+y` copies text to both the unnamed register and system clipboard.
-- The `"+` register represents the system clipboard.
km_set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[P] Yank to system clipboard" })

-- km_set("n", "<leader>C", require("telescope").extensions.zoxide.list, { desc = "[P] Change directory (zoxide)" })

-- mini.files
km_set("n", "<leader>fC", function()
  require("mini.files").open("~/code", true)
end, { desc = "[P] MiniFiles ~/code" })

km_set("n", "<leader>G", function()
  require("snacks").picker.grep({ cwd = "~/code" })
end, { desc = "[P] snacks picker grep ~/code" })

km_set("n", "<leader>sN", function()
  require("snacks").picker.grep({ dirs = { "~/.config/nvim", "~/.local/share/nvim" } })
end, { desc = "[P] snacks picker grep ~/.config/nvim ~/.local/share/nvim" })

km_set("n", "<leader>F", function()
  require("snacks").picker.files({ cwd = "~/code" })
end, { desc = "[P] snacks picker files ~/code" })

km_set("n", "<leader>H", function()
  require("snacks").picker.files({ cwd = "~" })
end, { desc = "[P] snacks picker files ~" })

km_set("n", "<leader>bC", function()
  require("snacks").bufdelete.all()
end, { desc = "[P] Close all buffers" })

km_set("n", "<leader>db", function()
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

-- km_set("n", "<leader>k", ':lua require("kubectl").open()<cr>', { noremap = true, silent = true, desc = "[P] kubectl" })

-- folds
km_set("n", "z0", function()
  vim.opt.foldlevel = 0
end, { desc = "[P] foldlevel=0" })

km_set("n", "z1", function()
  vim.opt.foldlevel = 1
end, { desc = "[P] foldlevel=1" })

km_set("n", "z2", function()
  vim.opt.foldlevel = 2
end, { desc = "[P] foldlevel=2" })

km_set("n", "z3", function()
  vim.opt.foldlevel = 3
end, { desc = "[P] foldlevel=3" })

km_set("n", "z4", function()
  vim.opt.foldlevel = 4
end, { desc = "[P] foldlevel=4" })

km_set("n", "z5", function()
  vim.opt.foldlevel = 5
end, { desc = "[P] foldlevel=5" })

-- just to play with and use as a reference
-- vim.keymap.set("n", "<leader>se", function()
--   local file_extension = vim.fn.input("File extension to search (e.g., *.js): ")
--   require("telescope.builtin").live_grep({
--     prompt_title = "Live Grep by File Type",
--     shorten_path = true,
--     additional_args = function()
--       return { "--glob", file_extension }
--     end,
--   })
-- end, { desc = "[P] [S]earch by File [T]ype" })

-- toggle showkeys
km_set("n", "<leader>kt", "<cmd>ShowkeysToggle<CR>", { desc = "[P] ShowkeysToggle" })

-- toggle zenmode
km_set("n", "<leader>Z", '<cmd>lua require("zen-mode").toggle()<CR>', { desc = "[P] ZenMode toggle" })

-- you-are-here
-- km_set("n", "<leader>hr", ":call you_are_here#Toggle()<CR>", { desc = "[P] You are here" })
--
vim.keymap.set(
  "n",
  "<leader>kk",
  '<cmd>lua require("kubectl").toggle()<CR>',
  { noremap = true, silent = true, desc = "[P] Kubectl toggle" }
)

km_set({ "n", "x" }, "<leader>aa", "<cmd>CopilotChat<CR>", { desc = "[P] CopilotChat toggle" })
-- km_set({ "n", "x" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "[P] CodeCompanionChat toggle" })

km_set("n", "<leader>jq", "<cmd>lua require('jqscratch').toggle()<CR>", { desc = "[P] jqscratch toggle" })

-- vim.keymap.set("n", "<space>fX", function()
--   require("telescope").extensions.file_browser.file_browser()
-- end)
