-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- from folke's config, but modified
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local cl_var = "auto_cursorline"

autocmd({ "InsertLeave", "WinEnter", "FocusGained" }, {
  group = augroup("enable_auto_cursorline", { clear = true }),
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, cl_var)
    if ok and cl then
      vim.api.nvim_win_del_var(0, cl_var)
      vim.wo.cursorline = true
    end
  end,
})

autocmd({ "InsertEnter", "WinLeave", "FocusLost" }, {
  group = augroup("disable_auto_cursorline", { clear = true }),
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, cl_var, cl)
      vim.wo.cursorline = false
    end
  end,
})
