-- Register custom jinja2 parser before TSUpdate runs
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").jinja2 = {
      tier = 3, -- community parser
      ---@diagnostic disable-next-line: missing-fields
      install_info = {
        path = "~/code/armyers/tree-sitter-jinja2",
        files = { "src/parser.c" },
      },
    }
  end,
})

-- Register jinja2 parser for j2 filetype
vim.treesitter.language.register("jinja2", "j2")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "bash",
          "groovy",
          "hcl",
          "jq",
          "json",
          "jsonc",
          "make",
          "ssh_config",
          "terraform",
        })
      end
    end,
  },
}
