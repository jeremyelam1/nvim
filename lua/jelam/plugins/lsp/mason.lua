return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			max_concurrent_installers = 10,
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"gopls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"ts_ls",
				"jsonls",
				"rust_analyzer",
			},
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- formatters
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter

				"goimports", -- go imports formatter
				"gofumpt", -- go formatter
				"golines", -- line length formatter for go
				"rustfmt", -- rust formatter

				-- linters
				"pylint", -- python linter
				"eslint_d", -- js linter
				"golangci-lint", -- go linter
				"shellcheck", -- shell script linter

				-- debuggers
				"delve", -- go debugger (for GraphQL and Go)
				"codelldb", -- debugger for C, C++, Rust

				-- go tools
				"gomodifytags", -- go modify struct tags
				"gotests", -- go test generator
				"impl", -- go interface implementation generator
				"gopls", -- go language server
			},
			auto_update = true,
			run_on_start = true,
			start_delay = 3000, -- 3 second delay
		})
	end,
}
