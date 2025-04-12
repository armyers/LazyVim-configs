return {
  {
    "echasnovski/mini.surround",
    enabled = true,
    version = "*",
    opts = {
      mappings = {
        add = "ys", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        find = "yf", -- Find surrounding (to the right)
        find_left = "yF", -- Find surrounding (to the left)
        highlight = "yh", -- Highlight surrounding
        replace = "cs", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
  },
}
