return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "hcl",
          "terraform",
          "bash",
          "jq",
          "make",
          -- "markdown",
          -- "markdown_inline",
          -- "org",
          "ssh_config",
          "groovy",
        })
      end
    end,
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      ---@diagnostic disable-next-line: inject-field
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
