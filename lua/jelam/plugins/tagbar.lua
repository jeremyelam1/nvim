return {
	"preservim/tagbar",
	vim.keymap.set("n", "<leader>t", ":TagbarToggle<CR>", { noremap = true, silent = true }),
}
