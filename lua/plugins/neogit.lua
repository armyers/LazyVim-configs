return {
  {
    "NeogitOrg/neogit",
    enabled = false,
    config = function()
      require("neogit").setup({})
    end,
  },
}
