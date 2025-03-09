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
	config = function()
		require("go").setup({
			-- DAP settings
			dap_debug = true,
			dap_debug_gui = true,
			dap_debug_vt = true,
			dap_port = 38697,
			-- dap_configuration = {
			-- 	type = "go",
			-- 	request = "launch",
			-- 	program = "${file}",
			-- 	dlvToolPath = vim.fn.exepath("dlv"),
			-- 	buildFlags = "-gcflags='all=-N -l'",
			-- 	mode = "debug",
			-- 	cwd = "${workspaceFolder}",
			-- },
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
			test_runner = "go", -- richgo, go test, richgo, dlv, ginkgo
			run_in_floaterm = true,
			test_efm = false,
			test_timeout = "30s",
			test_popup = true,
			test_popup_width = 80,
			test_popup_height = 10,
			verbose_tests = true,
			test_dir = "", -- if empty, use `pwd`

			-- Icons and UI
			icons = {
				breakpoint = "🔴",
				currentpos = "👉",
			},

			-- Tags settings
			tags_name = "json",
			tags_options = { "json=omitempty" },
			tags_transform = "snakecase",
			tags_flags = { "-transform", "snakecase" },

			-- Additional features
			luasnip = true,
			trouble = true,
			symbol_highlight = true,

			-- Linting and formatting
			lint_prompt_style = "vt", -- virtual text
			lint_on_save = true,
			linter = "golangci-lint",
			linter_flags = "enable-all", -- e.g. "--enable-all --disable=errcheck"
			formatter = "gofumpt",
			fmt_on_save = true,
			max_line_len = 120,

			-- Performance
			lsp_inlay_hints = {
				enable = true, -- this is the only field apply to neovim > 0.10

				-- following are used for neovim < 0.10 which does not implement inlay hints
				-- hint style, set to 'eol' for end-of-line hints, 'inlay' for inline hints
				style = "inlay",
				-- Note: following setup only works for style = 'eol', you do not need to set it for 'inlay'
				-- Only show inlay hints for the current line
				only_current_line = false,
				-- Event which triggers a refersh of the inlay hints.
				-- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
				-- not that this may cause higher CPU usage.
				-- This option is only respected when only_current_line and
				-- autoSetHints both are true.
				only_current_line_autocmd = "CursorMoved",
				-- whether to show variable name before type hints with the inlay hints or not
				-- default: false
				show_variable_name = true,
				-- prefix for parameter hints
				parameter_hints_prefix = "󰊕 ",
				show_parameter_hints = true,
				-- prefix for all the other hints (type, chaining)
				other_hints_prefix = "=> ",
				-- whether to align to the length of the longest line in the file
				max_len_align = false,
				-- padding from the left if max_len_align is true
				max_len_align_padding = 1,
				-- whether to align to the extreme right or not
				right_align = false,
				-- padding from the right if right_align is true
				right_align_padding = 6,
				-- The color of the hints
				highlight = "Comment",
			},

			-- Keymaps
			disable_defaults = false, -- true|false when true set false to all boolean settings and replace all table
			go_alternate_mode = "edit", -- "edit"| "split" | "vsplit"

			-- Workspace
			gofmt = "golines", -- changed from gofumpt to golines to support max_line_len
			fillstruct = "gopls",
			impl_template = "", -- impl module template path

			-- UI customization
			floaterm = {
				-- position
				width = 0.8,
				height = 0.8,
				title_colors = "nord",
			},
		})

		-- Format and Import on save
		local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function()
				-- Use pcall to handle potential errors
				local format_success, format_err = pcall(function()
					require("go.format").goimport()
					require("go.format").gofmt()
				end)

				if not format_success then
					vim.notify("Go format error: " .. (format_err or "unknown"), vim.log.levels.WARN)
				end
			end,
			group = format_sync_grp,
		})
	end,
	ft = { "go", "gomod", "gowork", "gotmpl" },
	build = ':lua require("go.install").update_all_sync()',
}
