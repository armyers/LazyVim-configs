return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    {
      "Katlean/local-snippets",
      url = "git@github.com:Katlean/local-snippets.git",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
}
