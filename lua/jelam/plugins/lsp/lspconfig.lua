return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		local function setup_lsp_keymaps(ev)
			local keymaps = {
				{ mode = "n", lhs = "gR", rhs = "<cmd>Telescope lsp_references<CR>", desc = "Show LSP references" },
				{ mode = "n", lhs = "gD", rhs = vim.lsp.buf.declaration, desc = "Go to declaration" },
				{ mode = "n", lhs = "gd", rhs = "<cmd>Telescope lsp_definitions<CR>", desc = "Show LSP definitions" },
				{
					mode = "n",
					lhs = "gi",
					rhs = "<cmd>Telescope lsp_implementations<CR>",
					desc = "Show LSP implementations",
				},
				{
					mode = "n",
					lhs = "gt",
					rhs = "<cmd>Telescope lsp_type_definitions<CR>",
					desc = "Show LSP type definitions",
				},
				{
					mode = { "n", "v" },
					lhs = "<leader>ca",
					rhs = vim.lsp.buf.code_action,
					desc = "See available code actions",
				},
				{ mode = "n", lhs = "<leader>rn", rhs = vim.lsp.buf.rename, desc = "Smart rename" },
				{
					mode = "n",
					lhs = "<leader>D",
					rhs = "<cmd>Telescope diagnostics bufnr=0<CR>",
					desc = "Show buffer diagnostics",
				},
				{ mode = "n", lhs = "<leader>d", rhs = vim.diagnostic.open_float, desc = "Show line diagnostics" },
				{ mode = "n", lhs = "[d", rhs = vim.diagnostic.goto_prev, desc = "Go to previous diagnostic" },
				{ mode = "n", lhs = "]d", rhs = vim.diagnostic.goto_next, desc = "Go to next diagnostic" },
				{
					mode = "n",
					lhs = "K",
					rhs = vim.lsp.buf.hover,
					desc = "Show documentation for what is under cursor",
				},
				{ mode = "n", lhs = "<leader>rs", rhs = ":LspRestart<CR>", desc = "Restart LSP" },
			}

			local opts = { buffer = ev.buf, silent = true }
			for _, mapping in ipairs(keymaps) do
				opts.desc = mapping.desc
				vim.keymap.set(mapping.mode, mapping.lhs, mapping.rhs, opts)
			end
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = setup_lsp_keymaps,
		})

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.lsp.config.svelte = {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
					end,
				})
			end,
		}

		vim.lsp.config.graphql = {
			capabilities = capabilities,
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		}

		vim.lsp.config.emmet_ls = {
			capabilities = capabilities,
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		}

		vim.lsp.config.lua_ls = {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
					completion = { callSnippet = "Replace" },
				},
			},
		}

		vim.lsp.config.rust_analyzer = {
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					checkOnSave = {
						command = "clippy",
					},
					cargo = {
						allFeatures = true,
					},
					procMacro = {
						enable = true,
					},
				},
			},
		}

		vim.lsp.config.tsserver = {
			capabilities = capabilities,
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
		}

		require("mason").setup({
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"gopls",
				"lua_ls",
				"tsserver",
				"html",
				"cssls",
				"jsonls",
				"rust_analyzer",
			},
			automatic_installation = true,
		})

		local mason_lspconfig = require("mason-lspconfig")
		for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
			vim.lsp.enable(server_name)
		end
	end,
}
