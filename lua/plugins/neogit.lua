return {
  {
    "NeogitOrg/neogit",
    enabled = true,
    config = function()
      require("neogit").setup({})
    end,
  },
}
