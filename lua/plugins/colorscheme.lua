-- WARN: this autocmd is in this file rather than the lua/config/autocmds.lua file
-- because it doesn't work when it's in that other file.
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  group = vim.api.nvim_create_augroup("override_picker_hl", { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, "SnacksPickerFile", { link = "Text" })
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Comment" })
    vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "Comment" })
    vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { link = "Comment" })
    vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { link = "Special" })
  end,
})

-- set and configure the default colorscheme
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "default",
    },
  },
  {
    "catppuccin/nvim",
    enabled = false,
  },
  {
    "zenbones-theme/zenbones.nvim",
    enabled = false,
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    -- you can set set configuration options here
    config = function()
      vim.g.zenbones_darken_comments = 1
      -- vim.cmd.colorscheme("zenbones")
    end,
  },
}
