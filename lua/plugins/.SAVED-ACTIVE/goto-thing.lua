require("lib.goto-thing").setup({
  keymap = "<leader>gt",
  -- To add custom rules:
  -- extra_rules = {
  --   {
  --     ft = { "python" },
  --     patterns = {
  --       { 'import%s+(%S+)', function(mod) print("module: " .. mod) end },
  --     },
  --   },
  -- },
})

return {}
