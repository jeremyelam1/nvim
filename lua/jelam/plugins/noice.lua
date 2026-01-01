return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			hover = {
				enabled = true,
			},
			signature = {
				enabled = true,
			},
			message = {
				enabled = true,
			},
			progress = {
				enabled = true,
			},
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = false,
				["vim.lsp.util.stylize_markdown"] = false,
			},
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
}
