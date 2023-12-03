-- set and configure the default colorscheme
return {
  {
    "neanias/everforest-nvim",
    event = { "VeryLazy" },
    config = function()
      require("everforest").setup({
        background = "hard",
        dim_inactive_windows = true,
        ui_contrast = "low",
        float_style = "dim",
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
