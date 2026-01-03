require("jelam.core")
require("jelam.lazy")
require("jelam.current-theme")
require("jelam.keymaps")
require("jelam.fix-diagnostics")
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo"
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
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
