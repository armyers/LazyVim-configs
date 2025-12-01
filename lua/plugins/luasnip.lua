return {
  "L3MON4D3/LuaSnip",
  enabled = true,
  lazy = true,
  event = { "VeryLazy" },
  -- don't need this; use github Katlean/local-snippets instead
  -- config = function()
  --   require("luasnip.loaders.from_vscode").lazy_load({
  --     paths = vim.fn.stdpath("config") .. "/local-snippets/",
  --   })
  -- end,
  dependencies = {
    {
      "Katlean/local-snippets",
      url = "git@github.com:Katlean/local-snippets.git",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    {
      -- HACK: disable this one since the TF snippets suck
      "rafamadriz/friendly-snippets",
      enabled = false,
    },
  },
}
