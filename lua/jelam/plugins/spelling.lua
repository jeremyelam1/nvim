return {
	-- ltex-ls is configured in lspconfig.lua through Mason

	-- Simple but effective spell checking setup
	{
		"f3fora/cmp-spell",
		dependencies = { "hrsh7th/nvim-cmp" },
		ft = { "markdown", "text", "gitcommit", "tex", "rst" },
		config = function()
			-- Auto-enable spell checking for text-like files
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "markdown", "text", "gitcommit", "tex", "rst" },
				callback = function()
					vim.opt_local.spell = true
					vim.opt_local.spelllang = { "en_us", "programming" }
					-- Better spell highlighting
					vim.api.nvim_set_hl(0, "SpellBad", { 
						undercurl = true, 
						sp = "#ff6b6b",
						cterm = { underline = true }
					})
					vim.api.nvim_set_hl(0, "SpellCap", { 
						undercurl = true, 
						sp = "#4ecdc4",
						cterm = { underline = true }
					})
				end,
			})

			-- Smart spell checking for code files (comments only)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "lua", "go", "javascript", "typescript", "python", "rust", "c", "cpp" },
				callback = function()
					-- Enable spell checking but only in comments
					vim.opt_local.spell = false -- Disabled by default for code files
					vim.opt_local.spelllang = { "en_us", "programming" }
				end,
			})
		end,
	},

	-- Programming dictionary for common terms
	{
		"psliwka/vim-dirtytalk",
		event = "VeryLazy",
		config = function()
			vim.opt.spelllang:append("programming")
		end,
		build = ":DirtytalkUpdate",
	},

	-- Improved spell checking configuration
	{
		"folke/which-key.nvim",
		optional = true,
		opts = {
			spec = {
				{ "<leader>s", group = "spell" },
			},
		},
	},
}
