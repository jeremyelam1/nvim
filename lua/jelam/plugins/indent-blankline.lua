-- Indent-blankline.nvim plugin configuration
return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = { char = "┊" },
	},
	config = function()
		local hooks = require("ibl.hooks")

		-- Set up rainbow colors for indent lines
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#987afb" })
			vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#37f499" })
			vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#04d1f9" })
			vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#949ae5" })
			vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#19dfcf" })
			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#5fa9f4" })
			vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#1682ef" })
		end)

		local highlight = {
			"RainbowRed",
			"RainbowYellow",
			"RainbowBlue",
			"RainbowOrange",
			"RainbowGreen",
			"RainbowViolet",
			"RainbowCyan",
		}

		require("ibl").setup({ indent = { highlight = highlight } })
	end,
}
