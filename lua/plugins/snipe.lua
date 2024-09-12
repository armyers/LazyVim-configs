return {
  {
    "leath-dub/snipe.nvim",
    enabled = true,
    config = function()
      local snipe = require("snipe")
      snipe.setup()
      vim.keymap.set("n", "<leader>bs", snipe.toggle_buffer_menu(), { desc = "[P]Select buffer from list (snipe)" })
    end,
  },
}
