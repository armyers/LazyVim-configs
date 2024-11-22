-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- from folke's config, but modified
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local cl_var = "auto_cursorline"

local function get_color(group, attr)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

local dimmed_bg = get_color("NormalNC", "bg")
local dimmed_fg = get_color("NormalNC", "fg")
local not_dimmed_bg = get_color("Normal", "bg")
local not_dimmed_fg = get_color("Normal", "fg")

autocmd({ "InsertLeave", "WinEnter", "FocusGained" }, {
  group = augroup("enable_auto_cursorline", { clear = true }),
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, cl_var)
    if ok and cl then
      vim.api.nvim_win_del_var(0, cl_var)
      vim.wo.cursorline = true
      vim.wo.cursorcolumn = true
      vim.api.nvim_set_hl(0, "Normal", { bg = not_dimmed_bg })
      vim.api.nvim_set_hl(0, "Normal", { fg = not_dimmed_fg })
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
      vim.wo.cursorcolumn = false
      vim.api.nvim_set_hl(0, "Normal", { bg = dimmed_bg })
      vim.api.nvim_set_hl(0, "Normal", { fg = dimmed_fg })
    end
  end,
})

-- set filetype for Jenkinsfile to groovy
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "Jenkinsfile*" },
  group = augroup("jenkinsfile_filetype", { clear = true }),
  callback = function()
    vim.bo.filetype = "groovy"
  end,
})

-- prevents some flickering when opening files
autocmd({ "LspAttach" }, {
  callback = function(args)
    vim.bo[args.buf].formatexpr = nil
  end,
})
