-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
-- local autocmd = vim.api.nvim_create_autocmd

-- autocmd({ "FocusGained", "TabEnter", "WinEnter", "BufEnter", "BufReadPre", "BufRead", "BufWinEnter" }, {
-- callback = function()
-- vim.o.cursorline = true
-- print(string.format("event fired: enter %s\n", os.date()), vim.inspect(ev))
-- end,
-- })

-- autocmd({ "FocusLost", "TabLeave", "WinLeave", "BufLeave", "BufWinLeave" }, {
-- callback = function()
-- vim.o.cursorline = false
-- print(string.format("event fired: leave %s\n", os.date()), vim.inspect(ev))
-- end,
-- })
