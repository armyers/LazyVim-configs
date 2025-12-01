return {
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    config = function()
      require("copilot").setup({
        copilot_model = "gemini-2.5-pro",
      })
    end,
  },
}
