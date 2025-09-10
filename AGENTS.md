# Neovim Configuration Agent Guidelines

## Build/Lint/Test Commands
This is a Neovim Lua configuration - no traditional build/test commands. Use these Neovim commands:
- Format: `<leader>mp` (uses stylua for Lua, prettier for others)
- Lint: `<leader>l` (runs nvim-lint with configured linters)
- Check config: `:checkhealth` to validate Neovim setup
- Reload config: `:source ~/.config/nvim/init.lua`

## Code Style Guidelines
- **File Structure**: Follow `lua/jelam/` namespace with logical grouping (core/, plugins/, plugins/lsp/)
- **Imports**: Use `require("module")` at function start, store in locals: `local conform = require("conform")`
- **Plugin Config**: Return table with plugin spec: `return { "author/plugin", config = function() ... end }`
- **Keymaps**: Use descriptive `desc` field: `{ desc = "Clear search highlights" }`
- **Formatting**: stylua handles Lua formatting automatically on save
- **Comments**: Use `--` for single line, descriptive headers for file purpose
- **Naming**: snake_case for variables, kebab-case for plugin names
- **Event Loading**: Use `event = { "BufReadPre", "BufNewFile" }` for performance
- **Dependencies**: Declare plugin dependencies in spec table
- **LSP Setup**: Configure keymaps in `setup_lsp_keymaps` function with buffer-local bindings
- **Error Handling**: Rely on Neovim's built-in error handling and plugin validation

## Key Conventions
- Leader key is `<space>`
- Plugin manager: lazy.nvim with auto-loading
- LSP managed via Mason + lspconfig
- No external build tools - pure Neovim Lua configuration