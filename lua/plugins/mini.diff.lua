return {
  {
    "nvim-mini/mini.diff",
    version = "*",
    enabled = true,
    config = function()
      require("mini.diff").setup()
    end,
    keys = {
      {
        "<leader>dr",
        function()
          require("lib.diff-picker").pick()
        end,
        desc = "[P] Diff reference picker",
      },
    },
  },
}
