vim.g.ai_cmp = true

return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default", -- C-n/C-p + Up/Down navigate, C-y accept, C-e cancel
      ["<Tab>"] = { "fallback" },
      ["<S-Tab>"] = { "fallback" },
    },
    completion = {
      ghost_text = { enabled = false },
      menu = { auto_show = true, border = "single" },
      documentation = { window = { border = "single" } },
    },
    cmdline = {
      completion = { ghost_text = { enabled = false } },
    },
    signature = { enabled = true, window = { border = "single" } },
  },
}
