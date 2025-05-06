return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- set this if you want to always pull the latest change
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	config = function()
		local avante = require("avante")

		-- Get DAP instance for integration
		local dap = require("dap")

		avante.setup({

			-- DAP integration
			dap = {
				enabled = true,
				-- Automatically analyze debug sessions
				auto_analyze = true,
				-- Include debug information in context
				include_debug_info = true,
				-- Include variable values in context
				include_variables = true,
				-- Include stack trace in context
				include_stack_trace = true,
			},
		})

		-- Register DAP event handlers for Avante integration
		dap.listeners.after.event_stopped["avante"] = function(_, body)
			if avante.config.dap and avante.config.dap.auto_analyze then
				avante.analyze_debug_session()
			end
		end
	end,
	dependencies = {
		-- "stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"mfussenegger/nvim-dap", -- Add DAP as a dependency
		"rcarriga/nvim-dap-ui", -- Add DAP UI as a dependency
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
