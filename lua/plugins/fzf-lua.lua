return {
  {
    "ibhagwan/fzf-lua",
    enabled = true,
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local actions = require("fzf-lua.actions")
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({
        actions = {
          files = {
            true, -- inherit from defaults
            ["enter"] = actions.file_edit,
          },
        },
      })
    end,
  },
}
