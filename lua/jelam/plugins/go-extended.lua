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
	-- Optimize loading strategy - only use ft for better performance
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
			linter_flags = "--fast", -- Use --fast instead of --enable-all for better performance
			fmt_on_save = true, -- Let go.nvim handle formatting

			-- DAP settings
			dap_debug = true,
			dap_debug_gui = true,
			dap_debug_vt = true,
			dap_port = 38697,

			-- Enhanced DAP configuration with goroutine support
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
					showGoroutineStack = true,
				},
				{
					type = "go",
					name = "Debug Main Package",
					request = "launch",
					program = function()
						if vim.fn.filereadable("./cmd/server/main.go") == 1 then
							return "./cmd/server/main.go"
						elseif vim.fn.filereadable("./main.go") == 1 then
							return "./main.go"
						end
						return vim.fn.input("Path to main.go: ", "", "file")
					end,
					dlvToolPath = vim.fn.exepath("dlv"),
					buildFlags = "-gcflags='all=-N -l'",
					mode = "debug",
					cwd = vim.fn.getcwd(),
					showGoroutineStack = true,
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
					showGoroutineStack = true,
				},
				{
					type = "go",
					name = "Debug with Args",
					request = "launch",
					program = function()
						return vim.fn.input("Path to main.go: ", vim.fn.expand("%:p"), "file")
					end,
					args = function()
						local args_str = vim.fn.input("Command line arguments: ")
						if args_str == "" then
							return {}
						end
						return vim.split(args_str, " ")
					end,
					dlvToolPath = vim.fn.exepath("dlv"),
					buildFlags = "-gcflags='all=-N -l'",
					mode = "debug",
					cwd = vim.fn.getcwd(),
					showGoroutineStack = true,
				},
				{
					type = "go",
					name = "Attach to Process",
					request = "attach",
					mode = "remote",
					remotePath = vim.fn.getcwd(),
					port = function()
						return tonumber(vim.fn.input("Delve port: ", "2345"))
					end,
					host = "127.0.0.1",
					showGoroutineStack = true,
				},
			},

			-- Testing settings
			test_runner = "go",
			run_in_floaterm = true,
			test_timeout = "30s",
			test_popup = true,
			test_popup_width = 80,
			test_popup_height = 10,
			verbose_tests = true,
			test_efm = true, -- Enable error format for better test output parsing

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
				virtual_text = { 
					space = 0, 
					prefix = "■",
					source = "if_many", -- Show diagnostic source if multiple sources
				},
				signs = true,
				update_in_insert = false, -- Don't show diagnostics in insert mode
				severity_sort = true, -- Sort by severity
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

				-- Debug keymaps
				vim.keymap.set(
					"n",
					"<leader>gdb",
					"<cmd>GoDebug<CR>",
					vim.tbl_extend("force", opts, { desc = "Start debugging" })
				)
				vim.keymap.set(
					"n",
					"<leader>gdt",
					"<cmd>GoDebug -t<CR>",
					vim.tbl_extend("force", opts, { desc = "Debug test" })
				)
				vim.keymap.set(
					"n",
					"<leader>gds",
					"<cmd>GoDbgStop<CR>",
					vim.tbl_extend("force", opts, { desc = "Stop debugger" })
				)
				vim.keymap.set(
					"n",
					"<leader>gdr",
					"<cmd>lua require('dap').restart()<CR>",
					vim.tbl_extend("force", opts, { desc = "Restart debugger" })
				)
				vim.keymap.set(
					"n",
					"<leader>gdg",
					"<cmd>lua require('dap-go').debug_goroutines()<CR>",
					vim.tbl_extend("force", opts, { desc = "Debug goroutines" })
				)

				-- Test commands
				vim.keymap.set(
					"n",
					"<leader>gt",
					"<cmd>GoTest<CR>",
					vim.tbl_extend("force", opts, { desc = "Run tests" })
				)
				vim.keymap.set(
					"n",
					"<leader>gtf",
					"<cmd>GoTestFunc<CR>",
					vim.tbl_extend("force", opts, { desc = "Test function" })
				)
				vim.keymap.set(
					"n",
					"<leader>gtc",
					"<cmd>GoCoverage<CR>",
					vim.tbl_extend("force", opts, { desc = "Test coverage" })
				)

				-- Code actions
				vim.keymap.set(
					"n",
					"<leader>gfs",
					"<cmd>GoFillStruct<CR>",
					vim.tbl_extend("force", opts, { desc = "Fill struct" })
				)
				vim.keymap.set(
					"n",
					"<leader>gif",
					"<cmd>GoIfErr<CR>",
					vim.tbl_extend("force", opts, { desc = "Add if err" })
				)
				vim.keymap.set(
					"n",
					"<leader>gie",
					"<cmd>GoImpl<CR>",
					vim.tbl_extend("force", opts, { desc = "Implement interface" })
				)

				-- Navigation
				vim.keymap.set(
					"n",
					"<leader>gat",
					"<cmd>GoAlt<CR>",
					vim.tbl_extend("force", opts, { desc = "Go to alternate file" })
				)
				vim.keymap.set(
					"n",
					"<leader>gatv",
					"<cmd>GoAltV<CR>",
					vim.tbl_extend("force", opts, { desc = "Go to alternate file (vsplit)" })
				)
				vim.keymap.set(
					"n",
					"<leader>gats",
					"<cmd>GoAltS<CR>",
					vim.tbl_extend("force", opts, { desc = "Go to alternate file (split)" })
				)
			end,
		})

		-- Set up formatting on save with error handling
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.go" },
			callback = function()
				-- Let go.nvim handle imports and formatting with error handling
				local ok, err = pcall(function()
					require("go.format").goimport()
				end)
				if not ok then
					vim.notify("Go format failed: " .. tostring(err), vim.log.levels.WARN)
				end
			end,
		})

		-- Prevent mason from setting up gopls since go.nvim handles it
		-- This is now handled in mason.lua with the skip logic

		-- Set up statusline integration if available
		if package.loaded["lualine"] then
			-- Can be used in lualine to show Go version
			_G.go_version = function()
				local version = vim.fn.system("go version 2>/dev/null"):match("go([%d%.]+)")
				return version and "Go " .. version or ""
			end
		end

		-- Add additional Go-specific commands
		vim.api.nvim_create_user_command("GoModTidy", function()
			vim.cmd("!go mod tidy")
		end, { desc = "Run go mod tidy" })

		vim.api.nvim_create_user_command("GoModDownload", function()
			vim.cmd("!go mod download")
		end, { desc = "Run go mod download" })

		vim.api.nvim_create_user_command("GoVet", function()
			vim.cmd("!go vet ./...")
		end, { desc = "Run go vet on all packages" })

		-- Better integration with existing diagnostics
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "go",
			callback = function()
				-- Set Go-specific options
				vim.bo.expandtab = false
				vim.bo.tabstop = 4
				vim.bo.shiftwidth = 4
			end,
		})
	end,
}
