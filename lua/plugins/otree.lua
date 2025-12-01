return {
  "Eutrius/Otree.nvim",
  enabled = false,
  lazy = false,
  dependencies = {
    "stevearc/oil.nvim",
    -- { "nvim-mini/mini.icons", opts = {} },
    -- "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("Otree").setup()
  end,
}
