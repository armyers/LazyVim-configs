return {
  "nvim-treesitter/nvim-treesitter-context",
  enabled = true,
  config = function()
    require("treesitter-context").setup({
      enabled = true,
      max_lines = 5,
    })
  end,
}
