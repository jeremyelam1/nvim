-- return {
-- 	{
-- 		"folke/tokyonight.nvim",
-- 		priority = 1000, -- make sure to load this before all the other start plugins
-- 		config = function()
-- 			local bg = "#011628"
-- 			local bg_dark = "#011423"
-- 			local bg_highlight = "#143652"
-- 			local bg_search = "#0A64AC"
-- 			local bg_visual = "#275378"
-- 			local fg = "#CBE0F0"
-- 			local fg_dark = "#B4D0E9"
-- 			local fg_gutter = "#627E97"
-- 			local border = "#547998"
--
-- 			require("tokyonight").setup({
-- 				transparent = true,
-- 				styles = {
-- 					sidebars = "transparent",
-- 					floats = "transparent",
-- 				},
-- 				on_colors = function(colors)
-- 					colors.bg = bg
-- 					colors.bg_dark = bg_dark
-- 					colors.bg_float = bg_dark
-- 					colors.bg_highlight = bg_highlight
-- 					colors.bg_popup = bg_dark
-- 					colors.bg_search = bg_search
-- 					colors.bg_sidebar = bg_dark
-- 					colors.bg_statusline = bg_dark
-- 					colors.bg_visual = bg_visual
-- 					colors.border = border
-- 					colors.fg = fg
-- 					colors.fg_dark = fg_dark
-- 					colors.fg_float = fg
-- 					colors.fg_gutter = fg_gutter
-- 					colors.fg_sidebar = fg_dark
-- 				end,
-- 			})
-- 			-- load the colorscheme here
-- 			-- Tokyonight settings
-- 			vim.g.tokyonight_transparent = true
-- 			vim.g.tokyonight_transparent_sidebar = true
--
-- 			vim.g.tokyonight_transparent_floats = true
-- 			vim.cmd([[colorscheme tokyonight]])
-- 			-- nvim-tree settings for transparent background
-- 			vim.cmd([[highlight NvimTreeNormal guibg=none]])
-- 			vim.cmd([[highlight NvimTreeEndOfBuffer guibg=none]])
-- 			vim.cmd([[highlight NvimTreeVertSplit guibg=none]])
-- 			vim.cmd([[highlight NvimTreeNormalNC guibg=none]])
-- 			-- Telescope settings for transparent background
-- 			vim.cmd([[
-- 	  highlight TelescopeNormal guibg=none
-- 	  highlight TelescopeBorder guibg=none
-- 	  highlight TelescopePromptNormal guibg=none
-- 	  highlight TelescopePromptBorder guibg=none
-- 	  highlight TelescopeResultsNormal guibg=none
-- 	  highlight TelescopeResultsBorder guibg=none
-- 	  highlight TelescopePreviewNormal guibg=none
-- 	  highlight TelescopePreviewBorder guibg=none
-- 	]])
-- 		end,
-- 	},
-- }
--
return {
	{
		"eldritch-theme/eldritch.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- local bg = "#011628"
			-- local bg_dark = "#011423"
			-- local bg_highlight = "#143652"
			-- local bg_search = "#0A64AC"
			-- local bg_visual = "#275378"
			-- local fg = "#CBE0F0"
			-- local fg_dark = "#B4D0E9"
			-- local fg_gutter = "#627E97"
			-- local border = "#547998"

			require("eldritch").setup({
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
				-- on_colors = function(colors)
				-- 	colors.bg = bg
				-- 	colors.bg_dark = bg_dark
				-- 	colors.bg_float = bg_dark
				-- 	colors.bg_highlight = bg_highlight
				-- 	colors.bg_popup = bg_dark
				-- 	colors.bg_search = bg_search
				-- 	colors.bg_sidebar = bg_dark
				-- 	colors.bg_statusline = bg_dark
				-- 	colors.bg_visual = bg_visual
				-- 	colors.border = border
				-- 	colors.fg = fg
				-- 	colors.fg_dark = fg_dark
				-- 	colors.fg_float = fg
				-- 	colors.fg_gutter = fg_gutter
				-- 	colors.fg_sidebar = fg_dark
				-- end,
			})
			-- load the colorscheme here
			-- Tokyonight settings
			-- vim.g.tokyonight_transparent = true
			-- vim.g.tokyonight_transparent_sidebar = true

			-- vim.g.tokyonight_transparent_floats = true
			vim.cmd([[colorscheme eldritch]])
			-- nvim-tree settings for transparent background
			vim.cmd([[highlight NvimTreeNormal guibg=none]])
			vim.cmd([[highlight NvimTreeEndOfBuffer guibg=none]])
			vim.cmd([[highlight NvimTreeVertSplit guibg=none]])
			vim.cmd([[highlight NvimTreeNormalNC guibg=none]])
			-- Telescope settings for transparent background
			vim.cmd([[
	  highlight TelescopeNormal guibg=none
	  highlight TelescopeBorder guibg=none
	  highlight TelescopePromptNormal guibg=none
	  highlight TelescopePromptBorder guibg=none
	  highlight TelescopeResultsNormal guibg=none
	  highlight TelescopeResultsBorder guibg=none
	  highlight TelescopePreviewNormal guibg=none
	  highlight TelescopePreviewBorder guibg=none
	]])
		end,
	},
}
