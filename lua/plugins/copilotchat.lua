return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = true,
    dependencies = {
      -- { "github/copilot.vim" },
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      model = "claude-3.5-sonnet",
      sticky = {
        "#buffers",
        "#files",
        "#filenames",
      },
      mappings = {
        -- Use tab for completion
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert = "",
        },
      },
    },
  },
}
