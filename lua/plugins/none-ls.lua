return {
  {
    "nvimtools/none-ls.nvim",
    config = function()
      require("null-ls").register(require("none-ls-shellcheck.diagnostics"))
      require("null-ls").register(require("none-ls-shellcheck.code_actions"))
    end,
    dependencies = {
      "gbprod/none-ls-shellcheck.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    opts = function(_, opts)
      local null_ls = require("null-ls")
      vim.list_extend(opts.sources, {
        null_ls.builtins.completion.tags,
        null_ls.builtins.diagnostics.checkmake,
        null_ls.builtins.diagnostics.commitlint,
        -- null_ls.builtins.diagnostics.gitlint,
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.diagnostics.terraform_validate,
        null_ls.builtins.diagnostics.yamllint,
        -- null_ls.builtins.formatting.codespell,
        null_ls.builtins.formatting.isort,
        require("none-ls.formatting.jq").with({
          extra_args = { "--indent", "4" },
        }),
        null_ls.builtins.formatting.shfmt.with({
          extra_args = { "-i", "2", "-ci", "-sr", "-bn", "-s" },
        }),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.terraform_fmt,
        null_ls.builtins.formatting.yamlfmt,
        null_ls.builtins.formatting.yapf,
        null_ls.builtins.hover.dictionary,
        null_ls.builtins.diagnostics.npm_groovy_lint,
        null_ls.builtins.formatting.npm_groovy_lint,
        null_ls.builtins.formatting.prettier.with({
          extra_filetypes = { "markdown" },
          extra_args = { "--parser", "markdown", "--prose-wrap", "always" },
        }),
      })
    end,
  },
}
