-- lazy.nvim
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      animate = {},
      image = {
        float = true,
      },
      zen = {
        win = {
          backdrop = {
            transparent = false,
          },
        },
      },
      picker = {
        layout = {
          fullscreen = true,
        },
        formatters = {
          file = {
            -- to view the entire file path
            truncate = 120,
          },
        },
        sources = {
          explorer = {
            hidden = true,
            layout = {
              fullscreen = false,
              preset = "sidebar",
            },
            win = {
              input = {
                keys = {
                  -- disable ESC key so that multiple ESC's do not quit the explorer
                  ["<esc>"] = { "", mode = "n" },
                },
              },
              list = {
                keys = {
                  -- disable ESC key so that multiple ESC's do not quit the explorer
                  ["<esc>"] = { "", mode = "n" },
                },
              },
            },
          },
        },
      },
    },
  },
}
