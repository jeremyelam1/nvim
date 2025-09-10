-- Neovim Configuration Entry Point
require("jelam.core")
require("jelam.lazy")
require("jelam.current-theme")
require("jelam.keymaps")

-- Undo settings
vim.opt.undofile = true
local undo_dir = os.getenv("HOME") .. "/.config/nvim/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
	vim.fn.mkdir(undo_dir, "p")
end
vim.opt.undodir = undo_dir
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

-- Auto-clear search highlighting when cursor moves
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("auto-hlsearch", { clear = true }),
	callback = function()
		if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
			vim.schedule(function()
				vim.cmd.nohlsearch()
			end)
		end
	end,
})
