-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- disable case-insensitive searches for tags
vim.opt.tagcase = "match"
-- disable the mouse
vim.opt.mouse = ""
-- disable the clipboard
vim.opt.clipboard = ""
-- enable line wrap
vim.opt.wrap = true

-- tabs and shifting
-- vim.opt.expandtab = true
-- vim.opt.tabstop = 2
-- vim.opt.shiftwidth = 2

-- increase the timeout between keystrokes so yss and ySS are useable
-- (which-key sets this to 300)
vim.opt.timeoutlen = 600

-- enable EditorConfig!
vim.g.editorconfig = true

-- turn off nonels notifications for now
-- vim.g.nonels_supress_issue58 = true

-- enable spellcheck
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- terraform template files
vim.filetype.add({
  extension = {
    tftpl = "terraform",
  },
})

-- terraform tfvars files
vim.filetype.add({
  extension = {
    tfvars = "terraform-vars",
  },
})

vim.opt.cursorcolumn = true

vim.diagnostic.config({ virtual_text = true })

function Fd(file_pattern, _)
  -- if first char is * then fuzzy search
  if file_pattern:sub(1, 1) == "*" then
    file_pattern = file_pattern:gsub(".", ".*%0") .. ".*"
  end
  local cmd = 'fd  --color=never --full-path --type file --hidden --exclude=".git" --exclude="deps" "'
    .. file_pattern
    .. '"'
  local result = vim.fn.systemlist(cmd)
  return result
end

vim.opt.findfunc = "v:lua.Fd"
vim.keymap.set("n", "<leader>fd", ":find ", { desc = "raw-dog: Project Files" })
