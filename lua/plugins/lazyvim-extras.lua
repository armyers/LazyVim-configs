return {
  { import = "lazyvim.plugins.extras.lsp.none-ls" },
  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },
  -- add yamlls and schemastore packages, and setup treesitter
  { import = "lazyvim.plugins.extras.lang.yaml" },
  -- add terraformls and schemastore packages, and setup treesitter
  { import = "lazyvim.plugins.extras.lang.terraform" },
}
