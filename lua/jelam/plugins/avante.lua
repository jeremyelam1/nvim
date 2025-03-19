return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- set this if you want to always pull the latest change
	opts = {
		-- Configuration options
		api_key = vim.env.ANTHROPIC_API_KEY, -- Read API key from environment
		prompt = "You are a helpful coding assistant specialized in Go programming.",
		max_tokens = 2000,
		temperature = 0.7,

		-- Go-specific configuration
		file_handlers = {
			[".go"] = {
				prompt = "You are an expert Go programmer. Provide idiomatic Go code following best practices.",
				temperature = 0.5, -- Lower temperature for more precise code
			},
			["go.mod"] = {
				prompt = "You are an expert in Go module management.",
				temperature = 0.3,
			},
			["go.sum"] = {
				enabled = false, -- Disable for go.sum files
			},
		},

		-- UI configuration
		ui = {
			width = 0.8, -- 80% of screen width
			height = 0.8, -- 80% of screen height
			border = "rounded",
			icons = true,
		},

		-- Keybindings
		keymaps = {
			-- Add Go-specific keymaps
			["<leader>ag"] = {
				cmd = "/prompt You are a Go expert. Help me with the following Go code:",
				desc = "Go Expert",
			},
			["<leader>at"] = { cmd = "/prompt Generate Go tests for this code:", desc = "Generate Go Tests" },
			["<leader>ad"] = { cmd = "/prompt Debug this Go code and explain the issue:", desc = "Debug Go Code" },
		},
	},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		-- "stevearc/dressing.nvim",
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
	config = function(_, opts)
		local avante = require("avante")
		avante.setup(opts)

		-- Set up filetype detection
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "go",
			callback = function()
				-- Add buffer-local keymaps for Go files
				vim.keymap.set("n", "<leader>agl", function()
					avante.prompt("Explain this Go code and suggest improvements:")
				end, { buffer = true, desc = "Explain Go Code" })

				vim.keymap.set("n", "<leader>agt", function()
					avante.prompt("Generate unit tests for this Go function:")
				end, { buffer = true, desc = "Generate Go Tests" })
			end,
		})
	end,
}
