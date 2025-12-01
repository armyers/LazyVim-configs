return {
  -- Configure autotools language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        autotools_ls = {
          -- Filetypes that the autotools language server will support
          filetypes = { "make", "config", "automake", "autoconf", "m4" },
        },
      },
    },
  },
  -- Ensure treesitter has make parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "make" })
      end
    end,
  },
  -- Install autotools language server with Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "autotools-language-server")
    end,
  },
}
