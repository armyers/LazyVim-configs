-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local km_set = vim.keymap.set
local km_del = vim.keymap.del

-- km_set("n", ";", ":", { desc = "Command mode" })
km_set("n", "_", "<cmd>split<cr>", { desc = "[P]Horizontal Split" })
km_set("n", "|", "<cmd>vsplit<cr>", { desc = "[P]Vertical Split" })
km_set("n", "<A-h>", "<C-w><", { desc = "[P]decrease window width" })
km_set("n", "<A-l>", "<C-w>>", { desc = "[P]increase window width" })
km_set("n", "<A-k>", "<C-w>+", { desc = "[P]increase window height" })
km_set("n", "<A-j>", "<C-w>-", { desc = "[P]decrease window height" })
km_set("n", "<A-=>", "<C-w>=", { desc = "[P]equalize window sizes" })
-- mnemonic: <A-\\> is really <A-|>
km_set("n", "<A-\\>", "<C-w>|", { desc = "maximize width of current window" })
-- mnemonic: <A--> is really <A-_>
km_set("n", "<A-->", "<C-w>_", { desc = "maximize height of current window" })
km_set("n", "<A-m>", "<C-w>_<C-w>|", { desc = "maximize width and height of current window" })
km_set("n", "<C-g>", "1<C-g>", { desc = "show current file/buffer details" })

-- disable lazygit
local opts = {}
km_del("n", "<leader>gg", opts)
km_del("n", "<leader>gG", opts)

-- snippets
km_set("n", "<leader>Se", function()
  require("scissors").editSnippet()
end)

-- When used in visual mode prefills the selection as body.
km_set({ "n", "x" }, "<leader>Sa", function()
  require("scissors").addNewSnippet()
end)
