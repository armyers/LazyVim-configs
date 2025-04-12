return {
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    config = function()
      require("copilot").setup({
        copilot_model = "claude-3.5-sonnet",
      })
    end,
  },
}
