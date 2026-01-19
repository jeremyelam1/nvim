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
		callback = function(ev)
			setup_lsp_keymaps(ev)
			
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if client and client.server_capabilities.inlayHintProvider then
				vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
			end
		end,
	})

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = signs.Error,
					[vim.diagnostic.severity.WARN] = signs.Warn,
					[vim.diagnostic.severity.HINT] = signs.Hint,
					[vim.diagnostic.severity.INFO] = signs.Info,
				},
			},
			virtual_text = false,
			virtual_lines = false,
			float = {
				source = "if_many",
				border = "rounded",
				format = function(diagnostic)
					local message = diagnostic.message
					message = message:gsub("\n.*for further information visit.*", "")
					message = message:gsub("\n.*`#%[warn%(.*%)%]`.*", "")
					message = message:gsub("\n.*`#%[deny%(.*%)%]`.*", "")
					return message
				end,
			},
			severity_sort = true,
			update_in_insert = false,
		})

		vim.lsp.config("*", {
			capabilities = capabilities,
			root_markers = { ".git" },
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



	vim.lsp.config.ts_ls = {
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

		vim.lsp.config.ltex = {
			capabilities = capabilities,
			filetypes = { "markdown", "text", "gitcommit", "tex" },
			settings = {
				ltex = {
					language = "en-US",
					diagnosticSeverity = "information",
					sentenceCacheSize = 2000,
					additionalRules = {
						enablePickyRules = true,
						motherTongue = "en-US",
					},
					disabledRules = {
						["en-US"] = { "MORFOLOGIK_RULE_EN_US" },
					},
					dictionary = {
						["en-US"] = {
							"nvim", "lua", "lsp", "treesitter", "config"
						},
					},
				},
			},
		}


	end,
}
