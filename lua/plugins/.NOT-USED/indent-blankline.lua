return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {},
  config = function()
    local opts = {
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        show_exact_scope = true,
      },
      whitespace = {
        remove_blankline_trail = false, --keep trailing whitespace visible
      },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "NvimTree",
          "Trouble",
          "lazy",
          "mason",
          "lualine",
        },
      },
    }
    require("ibl").setup(opts)
  end,
}
