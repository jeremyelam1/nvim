return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- set this if you want to always pull the latest change
	opts = {},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
--
-- return {
-- 	{
-- 		"yetone/avante.nvim",
-- 		event = "VeryLazy", -- Load the plugin lazily to improve startup time
-- 		config = function()
-- 			require("avante").setup({
-- 				-- Plugin configuration here
-- 				api_key = vim.env.OPENAI_API_KEY, -- Read the API key from the environment
-- 				model = "gpt-4", -- Model to use (e.g., "gpt-3.5-turbo", "gpt-4")
-- 				prompt = "You are a helpful coding assistant.",
-- 				max_tokens = 1000,
-- 				temperature = 0.7,
-- 			})
-- 		end,
-- 	},
-- }
