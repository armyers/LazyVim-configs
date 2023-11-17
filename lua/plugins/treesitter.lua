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
  },
}
