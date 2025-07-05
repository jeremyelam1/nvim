-- Yazi.nvim plugin configuration for file manager integration
return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	opts = {
		-- If you want to open yazi instead of netrw, see below for more info
		open_for_directories = false,
		keymaps = {
			show_help = "<f1>",
		},
	},
}
