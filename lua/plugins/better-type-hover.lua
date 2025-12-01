return {
  {
    "Sebastian-Nielsen/better-type-hover",
    enabled = false,
    ft = { "typescript", "typescriptreact" },
    config = function()
      require("better-type-hover").setup()
    end,
  },
}
