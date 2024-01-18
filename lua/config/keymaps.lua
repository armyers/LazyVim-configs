-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local km_set = vim.keymap.set

km_set("n", ";", ":", { desc = "Command mode" })
km_set("n", "_", "<cmd>split<cr>", { desc = "Horizontal Split" })
km_set("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
km_set("n", "<A-h>", "<C-w><", { desc = "decrease window width" })
km_set("n", "<A-l>", "<C-w>>", { desc = "increase window width" })
km_set("n", "<A-k>", "<C-w>+", { desc = "increase window height" })
km_set("n", "<A-j>", "<C-w>-", { desc = "decrease window height" })
km_set("n", "<A-=>", "<C-w>=", { desc = "equalize window sizes" })
-- mnemonic: <A-\\> is really <A-|>
km_set("n", "<A-\\>", "<C-w>|", { desc = "maximize width of current window" })
-- mnemonic: <A--> is really <A-_>
km_set("n", "<A-->", "<C-w>_", { desc = "maximize height of current window" })

-- disable lazygit
vim.keymap.del("n", "<leader>gg")
vim.keymap.del("n", "<leader>gG")
