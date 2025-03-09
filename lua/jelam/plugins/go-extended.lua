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

		go.setup({
			-- Core settings
			disable_defaults = false,
			go_alternate_mode = "edit",

			-- Formatting and linting
			formatter = "gofumpt",
			gofmt = "golines", -- Use golines to support max_line_len
			max_line_len = 120,
			lint_prompt_style = "vt",
			lint_on_save = true,
			linter = "golangci-lint",
			linter_flags = "enable-all",
			fmt_on_save = false, -- We handle this with a custom autocmd

			-- DAP settings
			dap_debug = true,
			dap_debug_gui = true,
			dap_debug_vt = true,
			dap_port = 38697,

			dap_configuration = {
				type = "go",
				request = "launch",
				program = "${file}",
				dlvToolPath = vim.fn.exepath("dlv"),
				buildFlags = "-gcflags='all=-N -l'",
				mode = "debug",
				cwd = "${workspaceFolder}",
				substitutePath = {
					{
						from = "${workspaceFolder}",
						to = vim.fn.getcwd(),
					},
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
				-- Add more icons for better visual feedback
				test_pass = "✅",
				test_fail = "❌",
			},
			floaterm = {
				width = 0.8,
				height = 0.8,
				title_colors = "nord",
				border = "rounded",
			},

			-- Inlay hints - simplified for Neovim >= 0.10
			lsp_inlay_hints = {
				enable = true,
				-- For Neovim < 0.10 compatibility
				style = "inlay",

				show_variable_name = true,

				parameter_hints_prefix = "󰊕 ",
				show_parameter_hints = true,

				other_hints_prefix = "=> ",

				highlight = "Comment",
			},

			-- Gopls settings
			gopls_cmd = vim.fn.executable("gopls") == 1 and { "gopls" } or nil,
			gopls_remote_auto = true,
			gopls_flags = {
				"-remote=auto",
				"-logfile=auto",
			},

			-- Diagnostic settings
			diagnostic = {
				hdlr = true,
				underline = true,
				virtual_text = { space = 0, prefix = "■" },
				signs = true,
			},
		})

		-- Optimize format and import on save with debouncing
		local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
		local format_timer = nil
		local format_debounce_ms = 100 -- Adjust as needed

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",

			group = format_sync_grp,
			callback = function()
				-- Cancel any pending format operations
				if format_timer then
					vim.loop.timer_stop(format_timer)
					format_timer = nil
				end

				-- Create a new timer for debouncing
				format_timer = vim.defer_fn(function()
					local go_format = require("go.format")

					-- Use protected calls for each operation separately for better error reporting
					local import_success, import_err = pcall(go_format.goimport)
					if not import_success then
						vim.notify("Go import error: " .. tostring(import_err), vim.log.levels.WARN)
					end

					local fmt_success, fmt_err = pcall(go_format.gofmt)
					if not fmt_success then
						vim.notify("Go format error: " .. tostring(fmt_err), vim.log.levels.WARN)
					end

					format_timer = nil
				end, format_debounce_ms)
			end,
		})

		-- Lazy load commands
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "go", "gomod", "gowork", "gotmpl" },
			callback = function()
				-- Load commands only when needed
				require("go.commands")

				-- Set up buffer-local keymaps for Go files
				local bufnr = vim.api.nvim_get_current_buf()
				vim.keymap.set("n", "<leader>gtt", function()
					require("go.test").test(true)
				end, { buffer = bufnr, desc = "Go Test This" })

				vim.keymap.set("n", "<leader>gta", function()
					require("go.test").test_all()
				end, { buffer = bufnr, desc = "Go Test All" })
			end,
		})

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
