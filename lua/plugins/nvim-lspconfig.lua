return {
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    opts = {
      format = { timeout_ms = 10000 },
      codelens = {
        enabled = true,
      },
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
        command = {
          "terraform-ls",
          "serve",
        },
        filetypes = {
          "tf",
          "tfvars",
          "terraform",
        },
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
