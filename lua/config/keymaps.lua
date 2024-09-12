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
