-- these specs are for overriding settings in plugins that are added by the LazyVim package
return {
  {
    "folke/tokyonight.nvim",
    event = { "VeryLazy" },
    opts = {
      style = "night",
      dim_inactive = true,
      -- on_highlights = function(hl, colors)
      on_highlights = function(hl)
        hl.CursorLine = {
          bg = "#333666",
          fg = "#bbbbbb",
          underline = true,
        }
        hl.NvimTreeCursorLine = {
          bg = "#333666",
          fg = "#bbbbbb",
        }
        hl.WinSeparator = {
          fg = "#555555",
        }
        hl.NvimTreeWinSeparator = {
          fg = "#555555",
        }
      end,
    },
  },
}
