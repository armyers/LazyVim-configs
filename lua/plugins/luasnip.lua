return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    {
      -- HACK: disable this one since it doesn't include terraform in package.json
      "rafamadriz/friendly-snippets",
      enabled = false,
    },
    {
      -- HACK: just a fork of rafamadriz/friendly-snippets with terraform language enabled
      "armyers/friendly-snippets",
      enabled = true,
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    {
      "Katlean/local-snippets",
      url = "git@github.com:Katlean/local-snippets.git",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
}
