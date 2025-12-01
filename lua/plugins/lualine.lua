return {
  {
    -- "nvim-lualine/lualine.nvim",
    -- WARN: use my forked version of lualine that adds path option 5
    dir = "~/code/armyers/lualine.nvim",
    enabled = true,
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "codedark",
      },
      sections = {
        lualine_c = {
          {
            "filename",
            path = 5,
          },
        },
      },
    },
  },
}
