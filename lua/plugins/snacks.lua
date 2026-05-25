-- lazy.nvim
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      terminal = {
        win = {
          position = "float",
          border = "rounded",
        },
      },
      animate = {},
      image = {
        doc = {
          -- disable hover/inline rendering for code blocks (mermaid, math, etc.)
          -- to prevent empty floating windows on mermaid diagrams
          enabled = false,
        },
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
            config = function(opts)
              local actions = require("snacks.explorer.actions")
              function actions.actions.confirm(picker, item, action)
                if not item then
                  return
                -- elseif picker.input.filter.meta.searching then
                --   actions.update(picker, { target = item.file })
                elseif item.dir then
                  require("snacks.explorer.tree"):toggle(item.file)
                  actions.update(picker, { refresh = true })
                else
                  require("snacks").picker.actions.jump(picker, item, action)
                end
              end
              return require("snacks.picker.source.explorer").setup(opts)
            end,
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
                  ["l"] = "confirm",
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
