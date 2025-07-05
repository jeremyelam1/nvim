-- Undotree plugin configuration for undo history visualization
return {
	"jiaoshijie/undotree",
	dependencies = "nvim-lua/plenary.nvim",
	config = true,
	keys = { -- Load the plugin only when using its keybinding
		{ "<leader>h", "<cmd>lua require('undotree').toggle()<cr>", desc = "Go to [u]ndo tree" },
	},
}
