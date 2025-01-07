local km = vim.keymap

-- Fzf Keymaps
km.set("n", "<leader>ff", require("fzf-lua").files, { desc = "FZF Files" })
km.set("n", "<leader>fr", require("fzf-lua").registers, { desc = "Registers" })
km.set("n", "<leader>fm", require("fzf-lua").marks, { desc = "Marks" })
km.set("n", "<leader>fk", require("fzf-lua").keymaps, { desc = "Keymaps" })
km.set("n", "<leader>fw", require("fzf-lua").live_grep, { desc = "FZF Grep" })
km.set("n", "<leader>fb", require("fzf-lua").buffers, { desc = "FZF Buffers" })
km.set("n", "<leader>fj", require("fzf-lua").helptags, { desc = "Help Tags" })
km.set("n", "<leader>fgc", require("fzf-lua").git_bcommits, { desc = "Browse File Commits" })
km.set("n", "<leader>fgs", require("fzf-lua").git_status, { desc = "Git Status" })
km.set("n", "<leader>fs", require("fzf-lua").spell_suggest, { desc = "Spelling Suggestions" })
km.set("n", "gd", require("fzf-lua").lsp_definitions, { desc = "Jump to Definition" })
km.set(
	"n",
	"<leader>tb",
	":lua require'fzf-lua'.lsp_document_symbols({winopts = {preview={wrap='wrap'}}})<cr>",
	{ desc = "Document Symbols" }
)
km.set("n", "<leader>fcr", require("fzf-lua").lsp_references, { desc = "LSP References" })
km.set(
	"n",
	"<leader>cd",
	":lua require'fzf-lua'.diagnostics_document({fzf_opts = { ['--wrap'] = true }})<cr>",
	{ desc = "Document Diagnostics" }
)

km.set(
	"n",
	"<leader>fa",
	":lua require'fzf-lua'.lsp_code_actions({ winopts = {relative='cursor',row=1.01, col=0, height=0.2, width=0.4} })<cr>",
	{ desc = "Code Actions" }
)

-- Auto-Session Keymaps
km.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
km.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory

km.set("n", "<leader>ct", ":ThemeToggle<CR>", { desc = "Toggle theme selector" })

-- Theme Keymaps
km.set("n", "<leader>ct", ":ThemeToggle<CR>", { desc = "Toggle through themes" })
km.set("n", "<leader>cs", ":ThemeSelect<CR>", { desc = "Select theme from menu" })
