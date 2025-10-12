# Neovim Configuration Guide for AI Agents

## Project Structure
- This is a Neovim configuration using lazy.nvim plugin manager
- Main entry: `init.lua` → `lua/jelam/` directory structure
- Plugins defined in `lua/jelam/plugins/` (each plugin = one file returning a table)
- Utility modules in `lua/jelam/utils/` (helpers, not plugins)
- LSP configs in `lua/jelam/plugins/lsp/`

## Code Style & Conventions
- **Indentation**: 2 spaces (tabs expanded to spaces)
- **Imports**: Use `require()` at top of file, assign to local variables (e.g., `local cmp = require("cmp")`)
- **Variables**: Use `local` for all variables; descriptive snake_case names
- **Comments**: Minimal inline comments; use only when necessary (most code is self-documenting)
- **Plugin structure**: Return table with plugin spec: `return { "author/plugin", config = function() ... end }`
- **Utility modules**: Return table with functions, place in `lua/jelam/utils/`
- **Keymaps**: Use `vim.keymap.set()` with descriptive `desc` field; prefer `<leader>` prefix for custom mappings
- **Options**: Use `vim.opt` for settings (e.g., `vim.opt.tabstop = 2`)
- **LSP**: Use `vim.lsp.config` API (not deprecated `require('lspconfig')`) for Neovim 0.11+

## Formatting & Linting
- **Lua**: stylua (auto-format on save via conform.nvim)
- **JS/TS**: prettier (auto-format on save)
- **Linting**: eslint_d for JS/TS, pylint for Python
- Manual format: `<leader>mp` or call `:lua require("conform").format()`

## Theme Integration
- **Omarchy Sync**: Auto-syncs with Hyprland Omarchy theme manager (see OMARCHY_SYNC.md)
- Colorscheme sync: `:OmarchySync` or `<leader>co`
- Color palette sync: `:OmarchySyncColors` or `<leader>cO`

## Commands
- No build/test commands (this is a config, not a project with tests)
- Reload config: `:source %` or restart Neovim
- Update plugins: `:Lazy sync`
- LSP restart: `:LspRestart` or `<leader>rs`
