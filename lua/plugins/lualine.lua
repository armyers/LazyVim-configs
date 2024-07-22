return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function(_, opts)
      table.remove(opts.sections.lualine_c, 1)
      table.remove(opts.sections.lualine_c, #opts.sections.lualine_c)
      table.insert(opts.sections.lualine_c, {
        "filename",
        path = 3,
      })
    end,
  },
}
