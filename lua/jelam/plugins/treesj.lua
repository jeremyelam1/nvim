-- Treesj plugin configuration for splitting/joining code blocks
return {
	{
		"Wansmer/treesj",
		keys = {
			{ "<leader>mS", "", desc = "TreeSJ" },
			{ "<leader>mt", "<cmd>TSJToggle<cr>", desc = "Toggle" },
			{ "<leader>mj", "<cmd>TSJJoin<cr>", desc = "Join" },
			{ "<leader>ms", "<cmd>TSJSplit<cr>", desc = "Split" },
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			use_default_keymaps = false,
		},
		config = true,
	},
}
