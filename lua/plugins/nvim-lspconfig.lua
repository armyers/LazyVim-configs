return {
  {
    "neovim/nvim-lspconfig",
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
    },
    -- setup = {
    -- require("lspconfig").groovyls.setup({}),
    -- },
  },
}
