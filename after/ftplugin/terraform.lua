-- terraform-ls exposes no LSP rename (renameProvider is nil), so LazyVim never
-- creates <leader>cr in terraform buffers. Terraform identifiers are textual
-- (a `variable "x"` block plus every `var.x`), so fall back to a grug-far
-- search/replace prefilled with the word under the cursor and scoped to the
-- current module directory. Mirrors the <leader>cr rename muscle memory used in
-- filetypes whose LSP does support rename (e.g. python/pyright).
vim.keymap.set("n", "<leader>cr", function()
  local word = vim.fn.expand("<cword>")
  require("grug-far").open({
    prefills = {
      search = "\\b" .. word .. "\\b",
      paths = vim.fn.expand("%:p:h"),
    },
  })
end, { buffer = true, desc = "[P] Rename (grug-far; tf has no LSP rename)" })
