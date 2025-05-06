return {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
		"mfussenegger/nvim-dap",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
	},
	-- Optimize loading strategy
	event = { "BufReadPre", "BufNewFile" },
	ft = { "go", "gomod", "gowork", "gotmpl" },
	build = ':lua require("go.install").update_all_sync()',
	config = function()
		local go = require("go")
		local lspconfig = require("lspconfig")
		local util = require("lspconfig.util")

		-- Extract gopls settings from lspconfig
		local function get_gopls_settings()
			-- Default settings that match our lspconfig
			local default_settings = {
				analyses = {
					unusedparams = true,
					shadow = true,
					unusedwrite = true,
					useany = true,
					nilness = true,
					unusedvariable = true,
				},
				staticcheck = true,
				gofumpt = true,
				usePlaceholders = true,
				completeUnimported = true,
				importShortcut = "Both",
				symbolMatcher = "fuzzy",
				symbolStyle = "Dynamic",
				codelenses = {
					gc_details = true,
					generate = true,
					regenerate_cgo = true,
					run_govulncheck = true,
					test = true,
					tidy = true,
					upgrade_dependency = true,
					vendor = true,
				},
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			}

			-- Try to get settings from lspconfig if it's already set up
			if lspconfig.gopls and lspconfig.gopls.get_config then
				local current_config = lspconfig.gopls.get_config(0) or {}
				if current_config.settings and current_config.settings.gopls then
					-- Merge with defaults, prioritizing existing settings
					return vim.tbl_deep_extend("force", default_settings, current_config.settings.gopls)
				end
			end

			return default_settings
		end

		-- Set up go.nvim with enhanced configuration
		go.setup({
			-- Core settings
			disable_defaults = false,
			go_alternate_mode = "edit",

			-- Formatting and linting
			formatter = "gofumpt", -- Primary formatter
			gofmt = "golines", -- Use golines to support max_line_len
			max_line_len = 120,
			lint_prompt_style = "vt",
			lint_on_save = true,
			linter = "golangci-lint",
			linter_flags = "--enable-all",
			fmt_on_save = true, -- Let go.nvim handle formatting

			-- DAP settings
			dap_debug = true,
			dap_debug_gui = true,
			dap_debug_vt = true,
			dap_port = 38697,

			-- Enhanced DAP configuration
			dap_configurations = {
				{
					type = "go",
					name = "Debug Current File",
					request = "launch",
					program = "${file}",
					dlvToolPath = vim.fn.exepath("dlv"),
					buildFlags = "-gcflags='all=-N -l'",
					mode = "debug",
					cwd = vim.fn.getcwd(),
				},
				{
					type = "go",
					name = "Debug Main Package",
					request = "launch",
					program = "./cmd/server/main.go", -- Adjust this path to your main package
					dlvToolPath = vim.fn.exepath("dlv"),
					buildFlags = "-gcflags='all=-N -l'",
					mode = "debug",
					cwd = vim.fn.getcwd(),
				},
				{
					type = "go",
					name = "Debug Test",
					request = "launch",
					mode = "test",
					program = "${file}",
					dlvToolPath = vim.fn.exepath("dlv"),
					buildFlags = "-gcflags='all=-N -l'",
					cwd = vim.fn.getcwd(),
				},
			},

			-- Interactive program selection function
			dap_configuration = {
				type = "go",
				request = "launch",
				program = function()
					-- Use the current file by default
					local program = vim.fn.expand("%:p")

					-- If we're in a main.go file or a cmd directory, use that
					if vim.fn.expand("%:t") == "main.go" then
						program = vim.fn.expand("%:p")
					elseif vim.fn.filereadable("./cmd/server/main.go") == 1 then
						program = "./cmd/server/main.go"
					elseif vim.fn.filereadable("./main.go") == 1 then
						program = "./main.go"
					end

					-- Ask the user to confirm or modify the program path
					local input = vim.fn.input({
						prompt = "Path to debug (main.go file): ",
						default = program,
						completion = "file",
					})

					return input ~= "" and input or program
				end,
				dlvToolPath = vim.fn.exepath("dlv"),
				buildFlags = "-gcflags='all=-N -l'",
				mode = "debug",
				cwd = vim.fn.getcwd(), -- Use actual current working directory instead of placeholder
				args = function()
					-- Ask for command line arguments
					local input = vim.fn.input({
						prompt = "Command line arguments: ",
						default = "",
					})

					if input == "" then
						return {}
					end

					-- Split the input by spaces, respecting quotes
					local args = {}
					local current_arg = ""
					local in_quotes = false
					local quote_char = nil

					for i = 1, #input do
						local char = input:sub(i, i)

						if (char == '"' or char == "'") and (not in_quotes or quote_char == char) then
							if in_quotes then
								in_quotes = false
								quote_char = nil
							else
								in_quotes = true
								quote_char = char
							end
						elseif char == " " and not in_quotes then
							if current_arg ~= "" then
								table.insert(args, current_arg)
								current_arg = ""
							end
						else
							current_arg = current_arg .. char
						end
					end

					if current_arg ~= "" then
						table.insert(args, current_arg)
					end

					return args
				end,
			},

			-- Testing settings
			test_runner = "go",
			run_in_floaterm = true,

			test_timeout = "30s",
			test_popup = true,
			test_popup_width = 80,
			test_popup_height = 10,
			verbose_tests = true,

			-- Tags settings
			tags_name = "json",
			tags_options = { "json=omitempty" },
			tags_transform = "snakecase",
			tags_flags = { "-transform", "snakecase" },

			-- Features
			luasnip = true,
			trouble = true,
			symbol_highlight = true,
			fillstruct = "gopls",

			-- UI
			icons = {
				breakpoint = "🔴",
				currentpos = "👉",

				test_pass = "✅",
				test_fail = "❌",
			},
			floaterm = {
				width = 0.8,
				height = 0.8,
				title_colors = "nord",
				border = "rounded",
			},

			-- Inlay hints
			lsp_inlay_hints = {
				enable = true,

				style = "inlay",

				show_variable_name = true,

				parameter_hints_prefix = "󰊕 ",
				show_parameter_hints = true,

				other_hints_prefix = "=> ",

				highlight = "Comment",
			},

			-- Gopls settings - we'll take control here
			gopls_cmd = { "gopls" },
			gopls_remote_auto = true,
			gopls_flags = {
				"-remote=auto",
				"-logfile=auto",
			},
			-- Use the settings from lspconfig
			gopls_settings = get_gopls_settings(),

			-- Diagnostic settings
			diagnostic = {
				hdlr = true, -- Let go.nvim handle diagnostics
				underline = true,
				virtual_text = { space = 0, prefix = "■" },
				signs = true,
			},
		})

		-- Set up additional Go-specific keymaps
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "go", "gomod", "gowork", "gotmpl" },
			callback = function()
				local opts = { buffer = true, silent = true }

				-- Go-specific keymaps
				vim.keymap.set(
					"n",
					"<leader>gsj",
					"<cmd>GoTagAdd json<CR>",
					vim.tbl_extend("force", opts, { desc = "Add json tags" })
				)
				vim.keymap.set(
					"n",
					"<leader>gsy",
					"<cmd>GoTagAdd yaml<CR>",
					vim.tbl_extend("force", opts, { desc = "Add yaml tags" })
				)
				vim.keymap.set(
					"n",
					"<leader>grj",
					"<cmd>GoTagRm json<CR>",
					vim.tbl_extend("force", opts, { desc = "Remove json tags" })
				)
				vim.keymap.set(
					"n",
					"<leader>gry",
					"<cmd>GoTagRm yaml<CR>",
					vim.tbl_extend("force", opts, { desc = "Remove yaml tags" })
				)

				-- Test commands
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>gt",
				-- 	"<cmd>GoTest<CR>",
				-- 	vim.tbl_extend("force", opts, { desc = "Run tests" })
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>gtf",
				-- 	"<cmd>GoTestFunc<CR>",
				-- 	vim.tbl_extend("force", opts, { desc = "Test function" })
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>gtc",
				-- 	"<cmd>GoCoverage<CR>",
				-- 	vim.tbl_extend("force", opts, { desc = "Test coverage" })
				-- )

				-- Code actions
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>gfs",
				-- 	"<cmd>GoFillStruct<CR>",
				-- 	vim.tbl_extend("force", opts, { desc = "Fill struct" })
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>gif",
				-- 	"<cmd>GoIfErr<CR>",
				-- 	vim.tbl_extend("force", opts, { desc = "Add if err" })
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>gie",
				-- 	"<cmd>GoImpl<CR>",
				-- 	vim.tbl_extend("force", opts, { desc = "Implement interface" })
				-- )

				-- Navigation
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>gat",
				-- 	"<cmd>GoAlt<CR>",
				-- 	vim.tbl_extend("force", opts, { desc = "Go to alternate file" })
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>gatv",
				-- 	"<cmd>GoAltV<CR>",
				-- 	vim.tbl_extend("force", opts, { desc = "Go to alternate file (vsplit)" })
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>gats",
				-- 	"<cmd>GoAltS<CR>",
				-- 	vim.tbl_extend("force", opts, { desc = "Go to alternate file (split)" })
				-- )
			end,
		})

		-- Set up formatting on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.go" },
			callback = function()
				-- Let go.nvim handle imports and formatting
				require("go.format").goimport()
			end,
		})

		-- Override gopls setup in lspconfig
		-- This will be called by mason-lspconfig
		local old_gopls_setup = lspconfig.gopls.setup
		lspconfig.gopls.setup = function(user_config)
			-- Don't do anything - go.nvim will handle gopls setup
			vim.notify("go.nvim is handling gopls configuration", vim.log.levels.INFO)
		end

		-- Set up statusline integration if available
		if package.loaded["lualine"] then
			-- Can be used in lualine to show Go version
			_G.go_version = function()
				local version = vim.fn.system("go version"):match("go([%d%.]+)")
				return version and "Go " .. version or ""
			end
		end
	end,
}
