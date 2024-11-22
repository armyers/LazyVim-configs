return {
  "L3MON4D3/LuaSnip",
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = vim.fn.stdpath("config") .. "/local-snippets/",
    })
  end,
  dependencies = {
    {
      -- HACK: disable this one since the TF snippets suck
      "rafamadriz/friendly-snippets",
      enabled = false,
    },
  },
}
