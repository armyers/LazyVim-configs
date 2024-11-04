return {
  {
    "ramilito/kubectl.nvim",
    enabled = true,
    config = function()
      require("kubectl").setup()
    end,
  },
}
