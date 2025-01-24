return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")

		local mason_lspconfig = require("mason-lspconfig")

		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- LSP keymaps
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

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Server specific configurations
		local server_configs = {
			svelte = {
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePost", {
						pattern = { "*.js", "*.ts" },
						callback = function(ctx)
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
						end,
					})
				end,
			},
			gopls = {
				cmd = { "gopls" },
				filetypes = { "go", "gomod" },
				root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
							shadow = true,
							unusedwrite = true,
							useany = true,
						},
						staticcheck = true,
						gofumpt = true,
						usePlaceholders = true,
						completeUnimported = true,
						importShortcut = "Both",
						symbolMatcher = "fuzzy",
						symbolStyle = "Dynamic",
					},
				},
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						pattern = "*.go",
						callback = function()
							-- Organize imports
							local params = vim.lsp.util.make_range_params()
							params.context = { only = { "source.organizeImports" } }
							local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
							for _, res in pairs(result or {}) do
								for _, r in pairs(res.result or {}) do
									if r.edit then
										vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
									end
								end
							end
							vim.lsp.buf.format({ async = false })
						end,
					})
				end,
			},
			graphql = {
				filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
			},
			emmet_ls = {
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
			},
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						completion = { callSnippet = "Replace" },
					},
				},
			},
		}

		-- Setup handlers for all servers
		mason_lspconfig.setup_handlers({
			function(server_name)
				local config = vim.tbl_deep_extend("force", {
					capabilities = capabilities,
				}, server_configs[server_name] or {})

				lspconfig[server_name].setup(config)
			end,
		})
	end,
}
