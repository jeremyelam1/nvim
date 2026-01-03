# Omarchy Theme Sync

This Neovim configuration automatically syncs with your Omarchy theme manager, including both colorscheme and terminal colors.

## Features

- **Colorscheme Sync**: Automatically applies the matching Neovim colorscheme
- **Color Palette Sync**: Extracts terminal colors (from kitty.conf/alacritty.toml) and applies them to syntax highlighting
- **Live Updates**: Changes to Omarchy themes are automatically detected and applied
- **Manual Control**: Commands and keymaps for manual synchronization

## How It Works

1. **Automatic Detection**: On startup, Neovim reads `~/.config/omarchy/current/theme/neovim.lua`
2. **Color Extraction**: Parses terminal color palette from `kitty.conf` or `alacritty.toml`
3. **Applied to Neovim**: 
   - Sets terminal colors (`terminal_color_0` through `terminal_color_15`)
   - Applies colors to syntax groups (String, Function, Keyword, Comment, etc.)
   - Syncs diagnostic colors (Error, Warn, Info, Hint)
   - Updates cursor colors

## Supported Themes

All Omarchy themes are supported:
- catppuccin / catppuccin-latte
- everforest
- gruvbox
- kanagawa
- matte-black
- nord
- osaka-jade (bamboo)
- ristretto (monokai-pro)
- rose-pine
- tokyo-night

## Commands

- `:OmarchySync` - Full sync (colorscheme + colors)
- `:OmarchySyncColors` - Sync only colors (keeps current colorscheme)

## Keymaps

- `<leader>co` - Full Omarchy theme sync
- `<leader>cO` - Sync only colors from Omarchy

## Usage

1. Change theme in Omarchy (your system theme manager)
2. Neovim automatically detects and applies the new theme with matching colors
3. No restart required!

## Troubleshooting

If theme doesn't sync automatically:
- Run `:OmarchySync` to manually trigger sync
- Run `:OmarchySyncColors` to sync just the colors
- Check that `~/.config/omarchy/current/theme` symlink exists
- Verify `kitty.conf` or `alacritty.toml` exists in the theme directory
- Restart Neovim if issues persist
