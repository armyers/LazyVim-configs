return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2", "-ci", "-bn", "-s", "-sr" },
      },
      prettier = {
        prepend_args = { "--check-ignore-pragma" },
      },
    },
  },
}

