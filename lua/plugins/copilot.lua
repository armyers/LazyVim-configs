return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- ai.copilot extra sets enabled=false here (since copilot.lua handles
      -- completion itself). Re-enable so sidekick.nes has a Copilot LSP client.
      copilot = { enabled = true },
    },
    setup = {
      copilot = function()
        -- If ai.copilot-native ever gets enabled, its setup.copilot would call
        -- vim.lsp.inline_completion.enable() and draw ghost text. Override to a
        -- no-op; returning nil lets default LSP attach proceed.
      end,
    },
  },
}
