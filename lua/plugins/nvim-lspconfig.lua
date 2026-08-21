return {
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    opts = {
      format = { timeout_ms = 10000 },
      codelens = {
        enabled = true,
      },
      servers = {
        groovyls = {
          cmd = {
            "java",
            "-jar",
            "~/.local/share/groovy-language-server/groovy-language-server-all.jar",
          },
          filetypes = {
            "groovy",
            "Jenkinsfile",
          },
        },
        ruff = {
          init_options = {
            settings = {
              configuration = "~/.config/ruff/config.toml",
            },
          },
        },
        terraformls = {
          cmd = {
            "terraform-ls",
            "serve",
          },
          filetypes = {
            "tf",
            "tfvars",
            "terraform",
          },
        },
        -- sourcekit-lsp ships with Xcode/Swift and is on PATH, so no cmd/mason
        -- needed. The bundled lsp/sourcekit.lua default already sets cmd,
        -- filetypes, capabilities and a root_dir (using the nvim 0.11+ on_dir
        -- callback signature). Overriding root_dir with the old root_pattern()
        -- signature breaks attach on nvim 0.12, so leave this empty.
        sourcekit = {},
      },
    },
    -- config = function()
    --   -- Set up Terraform LSP
    --   require("lspconfig").terraformls.setup({
    --     filetypes = { "terraform", "tf", "tfvars" },
    --     init_options = {
    --       experimentalFeatures = {
    --         prefillRequiredFields = true,
    --       },
    --     },
    --   })
    -- end,
    -- setup = {
    -- require("lspconfig").groovyls.setup({}),
    -- },
  },
}
