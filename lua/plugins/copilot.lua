return {
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    config = function()
      require("copilot").setup({
        copilot_model = "gpt-41-copilot",
      })
    end,
  },
}
