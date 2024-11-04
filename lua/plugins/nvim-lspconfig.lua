return {
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    opts = {
      format = { timeout_ms = 10000 },
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
    },
    -- setup = {
    -- require("lspconfig").groovyls.setup({}),
    -- },
  },
}
