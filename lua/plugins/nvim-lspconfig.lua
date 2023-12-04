return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {},
        tflint = {},
        jsonls = {},
        bashls = {},
        yamlls = {},
        marksman = {},
        pyright = {},
        docker_compose_language_service = {},
        dockerls = {},
        gopls = {},
      },
    },
    config = function()
      require("lspconfig.ui.windows").default_options.border = "single"
    end,
  },
}
