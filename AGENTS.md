# Neovim Configuration Guide for AI Agents

## Project Structure
- Neovim config using lazy.nvim plugin manager
- Entry: `init.lua` → `lua/jelam/` directory
- Plugins: `lua/jelam/plugins/` (one file per plugin, returns lazy.nvim spec table)
- Utils: `lua/jelam/utils/` (helper modules, not plugins)
- LSP: `lua/jelam/plugins/lsp/`

## Code Style
- **Indent**: 2 spaces (expandtab), see lua/jelam/core/options.lua:10-12
- **Imports**: `require()` at top, assign to locals: `local cmp = require("cmp")`
- **Variables**: Always `local`, snake_case naming
- **Comments**: Minimal, only when necessary (code should be self-documenting)
- **Plugin pattern**: `return { "author/plugin", event = "...", config = function() ... end }`
- **Keymaps**: `vim.keymap.set(mode, lhs, rhs, { desc = "..." })`, use `<leader>` prefix
- **Options**: `vim.opt.setting = value` (not `vim.o`)
- **LSP**: Use `vim.lsp.config` API (Neovim 0.11+), NOT deprecated `require('lspconfig')`
- **Error handling**: Direct assignments, no explicit error handling in configs

## Formatting & Linting
- **Format on save**: Enabled via conform.nvim (lua/jelam/plugins/formatting.lua:24-28)
- **Lua**: stylua (2-space indent)
- **JS/TS/TSX**: prettier
- **Python**: isort + black
- **Lint**: eslint_d (JS/TS), pylint (Python) via nvim-lint
- **Manual format**: `<leader>mp` or `:lua require("conform").format()`
- **Manual lint**: `<leader>l`

## Commands
- **No build/test** (config only, not a project)
- **Reload**: `:source %` or restart nvim
- **Update plugins**: `:Lazy sync`
- **LSP restart**: `:LspRestart` or `<leader>rs`
- **Format**: `<leader>mp`
- **Lint**: `<leader>l`
