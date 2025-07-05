-- Neovim Core Options Configuration

-- Netrw settings
vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt -- for conciseness

-- Line numbers
opt.relativenumber = true -- Show relative line numbers
opt.number = true -- Show absolute line number on cursor line

-- Tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- Expand tab to spaces
opt.autoindent = true -- Copy indent from current line when starting new one

-- Line wrapping
opt.wrap = false -- Disable line wrapping

-- Search settings
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- Case-sensitive search when mixed case is used

-- Cursor line
opt.cursorline = true -- Highlight the current cursor line

-- Appearance
opt.termguicolors = true -- Enable true color support
opt.background = "dark" -- Set dark background for colorschemes
opt.signcolumn = "yes" -- Show sign column to prevent text shifting

-- Backspace
opt.backspace = "indent,eol,start" -- Allow backspace on indent, end of line, or insert mode start

-- Clipboard
opt.clipboard:append("unnamedplus") -- Use system clipboard as default register

-- Split windows
opt.splitright = true -- Split vertical window to the right
opt.splitbelow = true -- Split horizontal window to the bottom

-- File handling
opt.swapfile = false -- Disable swap files
