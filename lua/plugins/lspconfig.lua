return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        terraformls = {},
        tflint = {},
        jsonls = {},
        bashls = {},
        yamlls = {},
        marksman = {},
        pyright = {},
        docker_compose_language_service = {},
        tflint = {},
        dockerls = {},
        gopls = {},
      },
    },
  },
}
