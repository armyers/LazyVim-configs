return {
  {
    "bloznelis/before.nvim",
    enabled = true,
    config = function()
      local before = require("before")
      before.setup()

      -- Jump to previous entry in the edit history
      vim.keymap.set("n", "<leader>gj", before.jump_to_last_edit, { desc = "[P] go to last edit" })

      -- Jump to next entry in the edit history
      vim.keymap.set("n", "<leader>gk", before.jump_to_next_edit, { desc = "[P] go to next edit" })

      -- Move edit history to quickfix (or telescope)
      vim.keymap.set("n", "<leader>ge", before.show_edits, { desc = "[P] show edit history" })
    end,
  },
}
