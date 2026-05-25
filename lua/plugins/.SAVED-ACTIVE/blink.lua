return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "fang2hou/blink-copilot",
      "joelazar/blink-calc",
    },
    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' preset: Up/Down and C-n/C-p to navigate, C-y to accept, C-e to cancel
      keymap = {
        preset = "default",
        -- change from C-space since that's my leader for terminal multiplexer
        ["<C-s>"] = {
          function(cmp)
            cmp.show()
          end,
        },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      cmdline = {
        keymap = {
          -- unified with insert mode: Up/Down to navigate, C-y to accept
          ["<Tab>"] = {},
          ["<Up>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback" },
          ["<C-y>"] = { "select_and_accept", "fallback" },
          ["<C-e>"] = { "cancel", "fallback" },
          ["<C-s>"] = { "show", "fallback" },
        },
        completion = {
          menu = { auto_show = true },
          ghost_text = { enabled = true },
        },
      },
      completion = {
        menu = { border = "single" },
        documentation = { window = { border = "single" } },
        ghost_text = { enabled = false },
      },
      signature = {
        enabled = true,
        window = { border = "single" },
      },
      sources = {
        default = { "copilot", "lsp", "path", "snippets", "buffer", "calc" },
        providers = {
          copilot = {
            module = "blink-copilot",
          },
          calc = {
            name = "Calc",
            module = "blink-calc",
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
