return {
  {
    "bloznelis/before.nvim",
    config = function()
      local before = require("before")
      before.setup()

      -- Jump to previous entry in the edit history
      vim.keymap.set("n", "<leader>gj", before.jump_to_last_edit, {})

      -- Jump to next entry in the edit history
      vim.keymap.set("n", "<leader>gk", before.jump_to_next_edit, {})

      -- Move edit history to quickfix (or telescope)
      vim.keymap.set("n", "<leader>oe", before.show_edits, {})
    end,
  },
}
