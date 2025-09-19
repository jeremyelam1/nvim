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
				"tsserver",
				"jsonls",
				"rust_analyzer",
				"ltex",  -- Advanced spell/grammar checking
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

		-- Setup LSP servers after mason-lspconfig is ready
		-- Use vim.schedule to ensure lspconfig.lua has run first
		vim.schedule(function()
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			
			-- Get capabilities and server configs from lspconfig.lua if available
			local capabilities = _G.lsp_capabilities or cmp_nvim_lsp.default_capabilities()
			local server_configs = _G.lsp_server_configs or {}
			
			-- Get all installed servers
			local installed_servers = mason_lspconfig.get_installed_servers()
			
			for _, server_name in ipairs(installed_servers) do
				-- Skip gopls - it's handled by go.nvim
				if server_name ~= "gopls" then
					local config = vim.tbl_deep_extend("force", {
						capabilities = capabilities,
					}, server_configs[server_name] or {})
					
					lspconfig[server_name].setup(config)
				end
			end
		end)
	end,
}
