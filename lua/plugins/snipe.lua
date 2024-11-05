return {
  {
    "leath-dub/snipe.nvim",
    enabled = true,
    keys = {
      {
        "<leader>bs",
        function()
          require("snipe").open_buffer_menu()
        end,
        desc = "[P] Open Snipe buffer menu",
      },
    },
    opts = {},
  },
}
