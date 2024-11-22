-- set and configure the default colorscheme
return {
  -- NOTE: I don't think I'll need everforest in the future, but I might
  -- {
  --   "neanias/everforest-nvim",
  --   event = { "VeryLazy" },
  --   config = function()
  --     require("everforest").setup({
  --       background = "hard",
  --       dim_inactive_windows = true,
  --       ui_contrast = "low",
  --       float_style = "dim",
  --     })
  --   end,
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        dim_inactive = {
          enabled = true, -- dims the background color of inactive window
          shade = "dark",
          percentage = 5, -- percentage of the shade to apply to the inactive window
        },
        custom_highlights = function()
          return {
            CursorLineNr = { fg = "Cyan" },
            LineNr = { fg = "DarkGray" },
            CursorLine = { bg = "#334455" },
            CursorColumn = { bg = "#334455" },
          }
        end,
      })
    end,
  },
}
