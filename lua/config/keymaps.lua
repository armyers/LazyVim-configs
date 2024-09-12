-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local km_set = vim.keymap.set
local km_del = vim.keymap.del

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

-- disable lazygit
local opts = {}
km_del("n", "<leader>gg", opts)
km_del("n", "<leader>gG", opts)

-- snippets
km_set("n", "<leader>Se", function()
  require("scissors").editSnippet()
end, { desc = "[P] Edit snippet" })

-- When used in visual mode prefills the selection as body.
km_set({ "n", "x" }, "<leader>Sa", function()
  require("scissors").addNewSnippet()
end, { desc = "[P] Add new snippet" })

-- When searching for stuff, search results show in the middle
km_set("n", "n", "nzz", { desc = "[P] goto next match; move line to middle" })
km_set("n", "N", "Nzz", { desc = "[P] goto prev match; move line to middle" })

-- When jumping with ctrl+d and u the cursors stays in the middle
km_set("n", "<C-d>", "<C-d>zz", { desc = "[P] page down; move to middle" })
km_set("n", "<c-u>", "<c-u>zz", { desc = "[P] page up; move to middle" })

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

km_set("n", "<leader>C", require("telescope").extensions.zoxide.list)

-- mini.files
km_set("n", "<leader>mf", ":lua MiniFiles.open()<CR>", { desc = "[P] Open MiniFiles (mini.files)" })
