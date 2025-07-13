# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Neovim Configuration Architecture

This is a **LazyVim-based configuration** using `lazy.nvim` as the plugin manager. The config follows a modular structure with plugins organized in separate files.

### Core Structure
- `init.lua` - Entry point that loads `config.lazy`
- `lua/config/` - Core configuration (options, keymaps, autocmds, lazy setup)
- `lua/plugins/` - Individual plugin configurations (one file per plugin)
- `snippets/` - Custom VSCode-format snippets
- `after/ftplugin/` - Filetype-specific configurations

### Plugin Management Patterns

**Standard plugin configuration:**
```lua
return {
  {
    "plugin/name",
    enabled = true,  -- Use enabled = false to disable
    opts = {},
    config = function() end,
  },
}
```

**Disabled plugins** are kept with `enabled = false` rather than deleted.

**Local plugins** use `dir = "~/code/armyers/plugin-name"` format.

### Key Configuration Conventions

- **Plugin organization**: `.NOT-USED/` directory contains archived configurations
- **Keymap descriptions**: Custom keymaps use `[P]` prefix in descriptions
- **Border style**: Consistent "single" borders across UI elements
- **Leader combinations**: Heavy use of `<leader>` for custom functionality

### Language Support

**LSP Configuration** (`lua/plugins/nvim-lspconfig.lua`):
- Custom servers: Groovy, Terraform (terraformls), Python (Ruff)
- Automatic setup via LazyVim extras

**Terraform Integration**:
- File type detection for `.tftpl` templates
- Custom tf-init plugin for development workflow
- Terraform LSP and formatting support

### Custom Features

**Snippet Management**:
- Local snippets in VSCode JSON format
- External repository integration (`Katlean/local-snippets`)
- Custom editing shortcuts (`<leader>Se`, `<leader>Sa`)

**UI Behaviors**:
- Auto-dimming windows when losing focus
- Cursor highlighting toggles with focus
- Custom find function with fuzzy matching

### Common Development Commands

**Plugin Management**:
- `:Lazy` - Plugin manager interface
- `:LazyExtras` - Enable/disable LazyVim extras

**Configuration**:
- `<leader><leader>r` - Source current Lua file
- `:LspInfo` - Check LSP status
- `:Mason` - Manage language servers

**File Navigation**:
- Multiple picker interfaces (Snacks, Telescope)
- Custom `Fd()` function for fuzzy file finding

### Dependencies

**Required External Tools**:
- `fd` - Fast file finder
- `ripgrep` - Text search
- Language servers installed via Mason

**Git Integration**:
- Neogit (currently disabled)
- Custom git log for selected lines

### Development Workflow

**Code Execution**:
- `<leader>r` - Execute Lua code
- Global `P()` function for debugging

**Snippet Development**:
- Edit snippets with scissors plugin
- Local snippet repository integration

### File Patterns

**Plugin Files**: Each plugin has its own file in `lua/plugins/`
**Disabled Code**: Moved to `.NOT-USED/` rather than deleted
**Local Development**: `~/code/armyers/` for custom plugins