-- set and configure the default colorscheme
return {
  -- NOTE: I don't think I'll need everforest in the future, but I might
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vague",
    },
  },
  {
    "neanias/everforest-nvim",
    enabled = false,
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("everforest").setup({
        background = "hard",
        dim_inactive_windows = true,
        ui_contrast = "low",
        float_style = "dim",
      })
    end,
  },
  {
    "catppuccin/nvim",
    enabled = false,
    lazy = true,
    event = { "VeryLazy" },
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        dim_inactive = {
          enabled = true, -- dims the background color of inactive window
          shade = "dark",
          percentage = 5, -- percentage of the shade to apply to the inactive window
        },
        custom_highlights = function()
          return {
            CursorLineNr = { fg = "Cyan" },
            LineNr = { fg = "DarkGray" },
            CursorLine = { bg = "#334455" },
            CursorColumn = { bg = "#334455" },
          }
        end,
      })
    end,
  },
  {
    "dupeiran001/nord.nvim",
    enabled = false,
    lazy = true,
    event = { "VeryLazy" },
    name = "nord",
    config = function()
      require("nord").setup({})
    end,
  },
  {
    "sainnhe/gruvbox-material",
    enabled = false,
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.gruvbox_material_enable_italic = true
    end,
  },
  {
    "dgox16/oldworld.nvim",
    enabled = false,
    name = "oldworld",
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("oldworld").setup({})
    end,
  },
  {
    "vague2k/vague.nvim",
    enabled = true,
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("vague").setup({
        -- optional configuration here
      })
    end,
  },
  {
    "rafamadriz/neon",
    enabled = false,
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      -- optional configuration here
      vim.g.neon_style = "dark"
    end,
  },
  {
    "dasupradyumna/midnight.nvim",
    enabled = false,
    lazy = true,
    event = { "VeryLazy" },
  },
  {
    "xero/miasma.nvim",
    enabled = false,
    lazy = true,
    event = { "VeryLazy" },
  },
  {
    "rockerBOO/boo-colorscheme-nvim",
    enabled = false,
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("boo-colorscheme").use({
        italic = true, -- toggle italics
        theme = "sunset_cloud",
      })
    end,
  },
  {
    "mhartington/oceanic-next",
    enabled = false,
    name = "oceanic-next",
    lazy = true,
    event = { "VeryLazy" },
  },
  {
    "fenetikm/falcon",
    enabled = false,
    lazy = true,
    event = { "VeryLazy" },
  },
  {
    "rose-pine/neovim",
    enabled = false,
    name = "rose-pine",
    lazy = true,
    event = { "VeryLazy" },
  },
  -- Using lazy.nvim
  {
    "cdmill/neomodern.nvim",
    enabled = false,
    name = "neomodern",
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("neomodern").setup({
        -- optional configuration here
        theme = "iceclimber",
        -- theme = "coffeecat",
        -- theme = "roseprime",
        -- theme = "darkforest",
      })
      -- require("neomodern").load()
    end,
  },
  {
    "slugbyte/lackluster.nvim",
    enabled = false,
    name = "lackluster",
    lazy = true,
    event = { "VeryLazy" },
  },
  {
    "aktersnurra/no-clown-fiesta.nvim",
    enabled = false,
    name = "no-clown-fiesta",
    lazy = true,
    event = { "VeryLazy" },
  },
  {
    "thesimonho/kanagawa-paper.nvim",
    enabled = false,
    name = "kanagawa-paper",
    lazy = true,
    event = { "VeryLazy" },
    opts = {},
  },
  {
    "kdheepak/monochrome.nvim",
    enabled = false,
    name = "monochrome",
    lazy = true,
    event = { "VeryLazy" },
  },
  {
    "datsfilipe/vesper.nvim",
    enabled = false,
    name = "vesper",
    lazy = true,
    event = { "VeryLazy" },
  },
  {
    "zenbones-theme/zenbones.nvim",
    enabled = false,
    name = "zenbones",
    lazy = true,
    event = { "VeryLazy" },
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    -- lazy = false,
    -- priority = 1000,
    -- you can set set configuration options here
    -- config = function()
    --     vim.g.zenbones_darken_comments = 45
    --     vim.cmd.colorscheme('zenbones')
    -- end
  },
  {
    "rjshkhr/shadow.nvim",
    enabled = false,
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      vim.opt.termguicolors = true
    end,
  },
  {
    "miikanissi/modus-themes.nvim",
    -- priority = 1000
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
  },
}
