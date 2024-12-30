return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy", -- Load the plugin lazily to improve startup time
		config = function()
			require("avante").setup({
				-- Plugin configuration here
				api_key = vim.env.OPENAI_API_KEY, -- Read the API key from the environment
				model = "gpt-4", -- Model to use (e.g., "gpt-3.5-turbo", "gpt-4")
				prompt = "You are a helpful coding assistant.",
				max_tokens = 1000,
				temperature = 0.7,
			})
		end,
	},
}
