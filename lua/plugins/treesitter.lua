return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "terraform",
          "hcl",
          "bash",
          "json",
          "yaml",
          "jq",
          "make",
          "markdown",
          "markdown_inline",
          "org",
          "ssh_config",
        })
      end
    end,
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      require("telescope").load_extension("luasnip")
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.jinja2 = {
        install_info = {
          url = "~/code/armyers/tree-sitter-jinja2",
          files = { "src/parser.c" },
        },
        filetype = "j2",
      }
      matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
        -- [options]
      }
    end,
  },
}
