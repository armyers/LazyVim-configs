return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      vim.list_extend(opts.sources, {
        null_ls.builtins.formatting.terraform_fmt,
        null_ls.builtins.formatting.terrafmt, -- markdown
        null_ls.builtins.diagnostics.terraform_validate,
        null_ls.builtins.completion.tags,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.trim_whitespace,
        null_ls.builtins.formatting.yamlfmt,
        null_ls.builtins.hover.dictionary,
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.yapf,
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.diagnostics.shellcheck.with({ diagnostics_format = "" }),
        -- null_ls.builtins.completion.spell,
      })
    end,
  },
}
