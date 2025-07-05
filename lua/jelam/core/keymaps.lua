-- Core Neovim Keymaps Configuration

-- Set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap

-- General Keymaps
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Number manipulation
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Window management
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })

-- Tab management
keymap.set("n", "<A-t>", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<A-x>", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<A-k>", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<A-j>", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<A-f>", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
