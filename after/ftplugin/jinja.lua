local colorscheme = "vague"
local ok, _ = pcall(vim.api.nvim_command, "colorscheme " .. colorscheme)
if not ok then
  print("error setting colorscheme " .. colorscheme)
end
