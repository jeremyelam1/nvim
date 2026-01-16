-- List of available themes
local themes = {
	"eldritch",
	"rose-pine",
	"gruvbox",
	"kanagawa",
	"catppuccin",
	"solarized-osaka",
	"tokyonight",
	"dracula",
	"monokai-pro",
	"nightfox",
	"cyberdream",
	"tokyodark",
	"fluoromachine",
}

-- Colors Testing
local linkarzu_color10 = "#0D1116"
local colors = {

	lazy_color01 = "#ebfafa",

	linkarzu_color18 = "#5b4996",
	linkarzu_color19 = "#21925b",
	linkarzu_color20 = "#027d95",
	linkarzu_color21 = "#585c89",
	linkarzu_color22 = "#0f857c",
	linkarzu_color23 = "#396592",

	linkarzu_color04 = "#ebfafa",
	-- linkarzu_color04 = "#987afb",
	linkarzu_color02 = "#37f499",
	linkarzu_color03 = "#04d1f9",
	linkarzu_color01 = "#949ae5",
	linkarzu_color05 = "#19dfcf",
	linkarzu_color08 = "#5fa9f4",
	linkarzu_color06 = "#1682ef",
	linkarzu_color07 = "#1c242f",
	linkarzu_color09 = "#a5afc2",
	linkarzu_color10 = "#0D1116",
	linkarzu_color11 = "#f16c75",
	linkarzu_color12 = "#f1fc79",
	linkarzu_color13 = "#314154",
	linkarzu_color14 = "#ebfafa",
	linkarzu_color15 = "#013e4a",
	linkarzu_color16 = "#e9b3fd",
	linkarzu_color17 = "#141b22",
	linkarzu_color24 = "#F712FF",
	linkarzu_color25 = "#232e3b",
}

-- Function to cycle through themes
local function cycle_themes()
	local current_theme = vim.g.colors_name
	local next_theme_index = 1

	-- Find current theme index
	for i, theme in ipairs(themes) do
		if current_theme == theme then
			next_theme_index = (i % #themes) + 1
			break
		end
	end

	-- Set the next theme
	local next_theme = themes[next_theme_index]
	vim.cmd.colorscheme(next_theme)
	vim.notify("Switched to " .. next_theme)
end

-- Create user commands
vim.api.nvim_create_user_command("ThemeToggle", function()
	cycle_themes()
end, {})

vim.api.nvim_create_user_command("ThemeSelect", function()
	vim.ui.select(themes, {
		prompt = "Select Theme",
		format_item = function(item)
			return item
		end,
	}, function(theme)
		if theme then
			vim.cmd.colorscheme(theme)
			vim.notify("Switched to " .. theme)
		end
	end)
end, {})

-- NOTE: eldritch
return {
	{
		"eldritch-theme/eldritch.nvim",
		lazy = true,
		name = "eldritch",
		opts = {
			transparent = false, -- Enable transparency
			-- Overriding colors globally using a definitions table
			on_colors = function(global_colors)
				-- Define all color overrides in a single table
				local color_definitions = {
					-- https://github.com/eldritch-theme/eldritch.nvim/blob/master/lua/eldritch/colors.lua
					bg = linkarzu_color10,
					fg = colors["linkarzu_color14"],
					selection = colors["linkarzu_color16"],
					comment = colors["linkarzu_color09"],
					red = colors["linkarzu_color08"], -- default #f16c75
					orange = colors["linkarzu_color06"], -- default #f7c67f
					yellow = colors["linkarzu_color05"], -- default #f1fc79
					green = colors["linkarzu_color02"],
					purple = colors["linkarzu_color04"], -- default #a48cf2
					cyan = colors["linkarzu_color03"],
					pink = colors["linkarzu_color01"], -- default #f265b5
					bright_red = colors["linkarzu_color08"],
					bright_green = colors["linkarzu_color02"],
					bright_yellow = colors["linkarzu_color05"],
					bright_blue = colors["linkarzu_color04"],
					bright_magenta = colors["linkarzu_color01"],
					bright_cyan = colors["linkarzu_color03"],
					bright_white = colors["linkarzu_color14"],
					menu = linkarzu_color10,
					visual = colors["linkarzu_color16"],
					gutter_fg = colors["linkarzu_color16"],
					nontext = colors["linkarzu_color16"],
					white = colors["linkarzu_color14"],
					black = linkarzu_color10,
					git = {
						change = colors["linkarzu_color03"],
						add = colors["linkarzu_color02"],
						delete = colors["linkarzu_color11"],
					},
					gitSigns = {
						change = colors["linkarzu_color03"],
						add = colors["linkarzu_color02"],
						delete = colors["linkarzu_color11"],
					},
					bg_dark = colors["linkarzu_color13"],
					-- Lualine line across
					bg_highlight = colors["linkarzu_color17"],
					terminal_black = colors["linkarzu_color13"],
					fg_dark = colors["linkarzu_color14"],
					fg_gutter = colors["linkarzu_color13"],
					dark3 = colors["linkarzu_color13"],
					dark5 = colors["linkarzu_color13"],
					bg_visual = colors["linkarzu_color16"],
					dark_cyan = colors["linkarzu_color03"],
					magenta = colors["linkarzu_color01"],
					magenta2 = colors["linkarzu_color01"],
					magenta3 = colors["linkarzu_color01"],
					dark_yellow = colors["linkarzu_color05"],
					dark_green = colors["linkarzu_color02"],
				}

				-- Apply each color definition to global_colors
				for key, value in pairs(color_definitions) do
					global_colors[key] = value
				end

				-- Set transparent background if enabled
				if vim.g.transparent_enabled then
					global_colors.bg = "NONE"
					global_colors.bg_dark = "NONE"
					global_colors.bg_float = "NONE"
				end
			end,

			-- This function is found in the documentation
			on_highlights = function(highlights)
				local highlight_definitions = {
					-- nvim-spectre or grug-far.nvim highlight colors
					DiffChange = { bg = colors["linkarzu_color03"], fg = "black" },
					DiffDelete = { bg = colors["linkarzu_color11"], fg = "black" },
					DiffAdd = { bg = colors["linkarzu_color02"], fg = "black" },
					TelescopeResultsDiffDelete = { bg = colors["linkarzu_color01"], fg = "black" },

					-- horizontal line that goes across where cursor is
					CursorLine = { bg = colors["linkarzu_color13"] },

					-- Set cursor color, these will be called by the "guicursor" option in
					-- the options.lua file, which will be used by neovide
					Cursor = { bg = colors["linkarzu_color24"] },
					lCursor = { bg = colors["linkarzu_color24"] },
					CursorIM = { bg = colors["linkarzu_color24"] },

					-- I do the line below to change the color of bold text
					["@markup.strong"] = { fg = colors["linkarzu_color24"], bold = true },

					-- Inline code in markdown
					["@markup.raw.markdown_inline"] = { fg = colors["linkarzu_color02"] },

					-- Change the spell underline color
					SpellBad = { sp = colors["linkarzu_color11"], undercurl = true },
					SpellCap = { sp = colors["linkarzu_color12"], undercurl = true },
					SpellLocal = { sp = colors["linkarzu_color12"], undercurl = true },
					SpellRare = { sp = colors["linkarzu_color04"], undercurl = true },

					MiniDiffSignAdd = { fg = colors["linkarzu_color05"], bold = true },
					MiniDiffSignChange = { fg = colors["linkarzu_color02"], bold = true },

					-- Codeblocks for the render-markdown plugin
					RenderMarkdownCode = { bg = colors["linkarzu_color07"] },

					-- This is the plugin that shows you where you are at the top
					TreesitterContext = { sp = linkarzu_color10 },
					MiniFilesNormal = { sp = linkarzu_color10 },
					MiniFilesBorder = { sp = linkarzu_color10 },
					MiniFilesTitle = { sp = linkarzu_color10 },
					MiniFilesTitleFocused = { sp = linkarzu_color10 },

					NormalFloat = { bg = linkarzu_color10 },
					FloatBorder = { bg = linkarzu_color10 },
					FloatTitle = { bg = linkarzu_color10 },
					NotifyBackground = { bg = linkarzu_color10 },
					NeoTreeNormalNC = { bg = linkarzu_color10 },
					NeoTreeNormal = { bg = linkarzu_color10 },
					NvimTreeWinSeparator = { fg = colors["linkarzu_color10"], bg = colors["linkarzu_color10"] },
					NvimTreeNormalNC = { bg = colors["linkarzu_color10"] },
					NvimTreeNormal = { bg = colors["linkarzu_color10"] },
					TroubleNormal = { bg = colors["linkarzu_color10"] },

					NoiceCmdlinePopupBorder = { fg = colors["linkarzu_color10"] },
					NoiceCmdlinePopupTitle = { fg = colors["linkarzu_color10"] },
					NoiceCmdlinePopupBorderFilter = { fg = colors["linkarzu_color10"] },
					NoiceCmdlineIconFilter = { fg = colors["linkarzu_color10"] },
					NoiceCmdlinePopupTitleFilter = { fg = colors["linkarzu_color10"] },
					NoiceCmdlineIcon = { fg = colors["linkarzu_color10"] },
					NoiceCmdlineIconCmdline = { fg = colors["linkarzu_color03"] },
					NoiceCmdlinePopupBorderCmdline = { fg = colors["linkarzu_color02"] },
					NoiceCmdlinePopupTitleCmdline = { fg = colors["linkarzu_color03"] },
					NoiceCmdlineIconSearch = { fg = colors["linkarzu_color04"] },
					NoiceCmdlinePopupBorderSearch = { fg = colors["linkarzu_color03"] },
					NoiceCmdlinePopupTitleSearch = { fg = colors["linkarzu_color04"] },
					NoiceCmdlineIconLua = { fg = colors["linkarzu_color05"] },
					NoiceCmdlinePopupBorderLua = { fg = colors["linkarzu_color01"] },
					NoiceCmdlinePopupTitleLua = { fg = colors["linkarzu_color05"] },
					NoiceCmdlineIconHelp = { fg = colors["linkarzu_color12"] },
					NoiceCmdlinePopupBorderHelp = { fg = colors["linkarzu_color08"] },
					NoiceCmdlinePopupTitleHelp = { fg = colors["linkarzu_color12"] },
					NoiceCmdlineIconInput = { fg = colors["linkarzu_color10"] },
					NoiceCmdlinePopupBorderInput = { fg = colors["linkarzu_color10"] },
					NoiceCmdlinePopupTitleInput = { fg = colors["linkarzu_color10"] },
					NoiceCmdlineIconCalculator = { fg = colors["linkarzu_color10"] },
					NoiceCmdlinePopupBorderCalculator = { fg = colors["linkarzu_color10"] },
					NoiceCmdlinePopupTitleCalculator = { fg = colors["linkarzu_color10"] },
					NoiceCompletionItemKindDefault = { fg = colors["linkarzu_color10"] },

					NoiceMini = { bg = colors["linkarzu_color10"] },
					StatusLine = { bg = colors["linkarzu_color10"] },
					Folded = { bg = colors["linkarzu_color10"] },

					DiagnosticInfo = { fg = colors["linkarzu_color03"] },
					DiagnosticHint = { fg = colors["linkarzu_color02"] },
					DiagnosticWarn = { fg = colors["linkarzu_color12"] },
					DiagnosticOk = { fg = colors["linkarzu_color04"] },
					DiagnosticError = { fg = colors["linkarzu_color11"] },
					RenderMarkdownQuote = { fg = colors["linkarzu_color12"] },

					-- visual mode selection
					Visual = { bg = colors["linkarzu_color16"], fg = colors["linkarzu_color10"] },
					PreProc = { fg = colors["linkarzu_color06"] },
					["@operator"] = { fg = colors["linkarzu_color02"] },

					KubectlHeader = { fg = colors["linkarzu_color04"] },
					KubectlWarning = { fg = colors["linkarzu_color03"] },
					KubectlError = { fg = colors["linkarzu_color01"] },
					KubectlInfo = { fg = colors["linkarzu_color02"] },
					KubectlDebug = { fg = colors["linkarzu_color05"] },
					KubectlSuccess = { fg = colors["linkarzu_color02"] },
					KubectlPending = { fg = colors["linkarzu_color03"] },
					KubectlDeprecated = { fg = colors["linkarzu_color08"] },
					KubectlExperimental = { fg = colors["linkarzu_color09"] },
					KubectlNote = { fg = colors["linkarzu_color03"] },
					KubectlGray = { fg = colors["linkarzu_color10"] },

					-- Colorcolumn that helps me with markdown guidelines
					ColorColumn = { bg = colors["linkarzu_color13"] },

					FzfLuaFzfPrompt = { fg = colors["linkarzu_color04"], bg = colors["linkarzu_color10"] },
					FzfLuaCursorLine = { fg = colors["linkarzu_color02"], bg = colors["linkarzu_color10"] },
					FzfLuaTitle = { fg = colors["linkarzu_color03"], bg = colors["linkarzu_color10"] },
					FzfLuaSearch = { fg = colors["linkarzu_color14"], bg = colors["linkarzu_color10"] },
					FzfLuaBorder = { fg = colors["linkarzu_color02"], bg = colors["linkarzu_color10"] },
					FzfLuaNormal = { fg = colors["linkarzu_color14"], bg = colors["linkarzu_color10"] },

					TelescopeNormal = { fg = colors["linkarzu_color14"], bg = colors["linkarzu_color10"] },
					TelescopeMultiSelection = { fg = colors["linkarzu_color02"], bg = colors["linkarzu_color10"] },
					TelescopeSelection = { fg = colors["linkarzu_color14"], bg = colors["linkarzu_color13"] },
				}

				-- Apply all highlight definitions at once
				for group, props in pairs(highlight_definitions) do
					highlights[group] = props
				end
			end,
		},
	},
	-- NOTE: Rose pine
	{
		"rose-pine/neovim",
		name = "rose-pine",
		-- priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "main", -- auto, main, moon, or dawn
				dark_variant = "main", -- main, moon, or dawn
				dim_inactive_windows = false,
				disable_background = false,
				-- 	disable_nc_background = false,
				-- 	disable_float_background = false,
				-- extend_background_behind_borders = false,
				styles = {
					bold = true,
					italic = false,
					transparency = false,
				},
				highlight_groups = {
					ColorColumn = { bg = "#1C1C21" },
					Normal = { bg = "none" }, -- Main background remains transparent
					Pmenu = { bg = "", fg = "#e0def4" }, -- Completion menu background
					PmenuSel = { bg = "#4a465d", fg = "#f8f5f2" }, -- Highlighted completion item
					PmenuSbar = { bg = "#191724" }, -- Scrollbar background
					PmenuThumb = { bg = "#9ccfd8" }, -- Scrollbar thumb
				},
				enable = {
					terminal = false,
					legacy_highlights = false, -- Improve compatibility for previous versions of Neovim
					migrations = true, -- Handle deprecated options automatically
				},
			})

			-- HACK: set this on the color you want to be persistent
			-- when quit and reopening nvim
			-- vim.cmd("colorscheme rose-pine")
		end,
	},
	-- NOTE: gruvbox
	{
		"ellisonleao/gruvbox.nvim",
		-- priority = 1000 ,
		config = function()
			require("gruvbox").setup({
				terminal_colors = true, -- add neovim terminal colors
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = false,
					emphasis = false,
					comments = false,
					folds = false,
					operators = false,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true, -- invert background for search, diffs, statuslines and errors
				contrast = "", -- can be "hard", "soft" or empty string
				palette_overrides = {},
				overrides = {
					Pmenu = { bg = "" }, -- Completion menu background
				},
				dim_inactive = false,
				transparent_mode = false,
			})
		end,
	},
	-- NOTE: Kanagwa
	{
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({
				compile = false, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = false },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = true, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,17}
				colors = { -- add/modify theme and palette colors
					palette = {},
					theme = {
						wave = {},
						dragon = {},
						all = {
							ui = {
								bg_gutter = "none",
								border = "rounded",
							},
						},
					},
				},
				overrides = function(colors) -- add/modify highlights
					local theme = colors.theme
					return {
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						Pmenu = { fg = theme.ui.shade0, bg = "NONE", blend = vim.o.pumblend }, -- add `blend = vim.o.pumblend` to enable transparency
						PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
						PmenuSbar = { bg = theme.ui.bg_m1 },
						PmenuThumb = { bg = theme.ui.bg_p2 },

						-- Save an hlgroup with dark background and dimmed foreground
						-- so that you can use it where your still want darker windows.
						-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
						NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

						-- Popular plugins that open floats will link to NormalFloat by default;
						-- set their background accordingly if you wish to keep them dark and borderless
						LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
						MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
						TelescopeTitle = { fg = theme.ui.special, bold = true },
						TelescopePromptBorder = { fg = theme.ui.special },
						TelescopeResultsNormal = { fg = theme.ui.fg_dim },
						TelescopeResultsBorder = { fg = theme.ui.special },
						TelescopePreviewBorder = { fg = theme.ui.special },
					}
				end,
				theme = "wave", -- Load "wave" theme when 'background' option is not set
				background = { -- map the value of 'background' option to a theme
					dark = "wave", -- try "dragon" !
				},
			})
		end,
	},
	-- NOTE catppuccin
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		config = function()
			require("catppuccin").setup({
				transparent_background = false,
				term_colors = true,
				styles = {
					comments = { "italic" },
					functions = { "italic" },
					keywords = { "italic" },
					strings = {},
					variables = {},
				},
				integrations = {
					nvimtree = true,
					telescope = true,
					notify = false,
					mini = false,
				},
				custom_highlights = function(colors)
					return {
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						TelescopeNormal = { bg = "none" },
						TelescopeBorder = { bg = "none" },
						TelescopePromptNormal = { bg = "none" },
						TelescopeResultsNormal = { bg = "none" },
						TelescopePreviewNormal = { bg = "none" },
						NvimTreeNormal = { bg = "none" },
						NvimTreeNormalNC = { bg = "none" },
						NvimTreeWinSeparator = { bg = "none" },
					}
				end,
			})
		end,
	},
	-- NOTE: neosolarized
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		config = function()
			require("solarized-osaka").setup({
				transparent = false,
				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = true },
					keywords = { italic = false },
					functions = {},
					variables = {},
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "transparent", -- style for sidebars, see below
					floats = "transparent", -- style for floating windows
				},
				sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
				day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
				hide_inactive_statusline = true, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
				dim_inactive = false, -- dims inactive windows
				lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
			})
		end,
	},
	-- NOTE : tokyonight
	{
		"folke/tokyonight.nvim",
		name = "folkeTokyonight",
		-- priority = 1000,
		config = function()
			local transparent = true
			local bg = "#011628"
			local bg_dark = "#011423"
			local bg_highlight = "#143652"
			local bg_search = "#0A64AC"
			local bg_visual = "#275378"
			local fg = "#CBE0F0"
			local fg_dark = "#B4D0E9"
			local fg_gutter = "#627E97"
			local border = "#547998"

			require("tokyonight").setup({
				style = "night",
				transparent = transparent,

				styles = {
					comments = { italic = false },
					keywords = { italic = false },
					sidebars = transparent and "transparent" or "dark",
					floats = transparent and "transparent" or "dark",
				},
				on_colors = function(colors)
					colors.bg = transparent and colors.none or bg
					colors.bg_dark = transparent and colors.none or bg_dark
					colors.bg_float = transparent and colors.none or bg_dark
					colors.bg_highlight = bg_highlight
					colors.bg_popup = bg_dark
					colors.bg_search = bg_search
					colors.bg_sidebar = transparent and colors.none or bg_dark
					colors.bg_statusline = transparent and colors.none or bg_dark
					colors.bg_visual = bg_visual
					colors.border = border
					colors.fg = fg
					colors.fg_dark = fg_dark
					colors.fg_float = fg
					colors.fg_gutter = fg_gutter
					colors.fg_sidebar = fg_dark
				end,
			})
			-- vim.cmd("colorscheme tokyonight")
			-- NOTE: Auto switch to tokyonight for markdown files only
			-- vim.api.nvim_create_autocmd("FileType", {
			--     pattern = { "markdown" },
			--     callback = function()
			--         -- Ensure the theme switch only happens once for a buffer
			--         local buffer = vim.api.nvim_get_current_buf()
			--         if not vim.b[buffer].tokyonight_applied then
			--             if vim.fn.expand("%:t") ~= "" and vim.api.nvim_buf_get_option(0, "buftype") ~= "nofile" then
			--                 vim.cmd("colorscheme tokyonight")
			--             end
			--             vim.b[buffer].tokyonight_applied = true
			--         end
			--     end,
			-- })
		end,
	},

	-- NOTE : dracula
	{
		"Mofiqul/dracula.nvim",
		name = "dracula",
		-- priority = 1000,
		config = function()
			local transparent = true

			require("dracula").setup({
				-- transparent_bg = transparent,

				styles = {
					comments = { italic = false },
					keywords = { italic = false },
					sidebars = transparent and "transparent" or "dark",
					floats = transparent and "transparent" or "dark",
				},
			})
		end,
	},

	-- NOTE : nightfox
	{
		"EdenEast/nightfox.nvim",
		name = "nightfox",
		-- priority = 1000,
		config = function()
			local transparent = true

			require("nightfox").setup({
				options = {
					-- Compiled file's destination location
					compile_path = vim.fn.stdpath("cache") .. "/nightfox",
					compile_file_suffix = "_compiled", -- Compiled file suffix
					transparent = false, -- Disable setting background
					terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
					dim_inactive = false, -- Non focused panes set to alternative background
					module_default = true, -- Default enable value for modules
					colorblind = {
						enable = false, -- Enable colorblind support
						simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
						severity = {
							protan = 0, -- Severity [0,1] for protan (red)
							deutan = 0, -- Severity [0,1] for deutan (green)
							tritan = 0, -- Severity [0,1] for tritan (blue)
						},
					},
					styles = { -- Style to be applied to different syntax groups
						comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
						conditionals = "NONE",
						constants = "NONE",
						functions = "NONE",
						keywords = "NONE",
						numbers = "NONE",
						operators = "NONE",
						strings = "NONE",
						types = "NONE",
						variables = "NONE",
					},
					inverse = { -- Inverse highlight for different types
						match_paren = false,
						visual = false,
						search = false,
					},
					modules = { -- List of various plugins and additional options
						-- ...
					},
				},
				palettes = {},
				specs = {},
				groups = {},
			})
		end,
	},

	-- NOTE : monokai-pro
	{
		"loctvl842/monokai-pro.nvim",
		name = "monokai-pro",
		-- priority = 1000,
		config = function()
			local transparent = true

			require("monokai-pro").setup({
				transparent_background = transparent,
				terminal_colors = true,
				devicons = true, -- highlight the icons of `nvim-web-devicons`
				styles = {
					comment = { italic = true },
					keyword = { italic = true }, -- any other keyword
					type = { italic = true }, -- (preferred) int, long, char, etc
					storageclass = { italic = true }, -- static, register, volatile, etc
					structure = { italic = true }, -- struct, union, enum, etc
					parameter = { italic = true }, -- parameter pass in function
					annotation = { italic = true },
					tag_attribute = { italic = true }, -- attribute of tag in reactjs
				},
				filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
				-- Enable this will disable filter option
				day_night = {
					enable = false, -- turn off by default
					day_filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
					night_filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
				},
				inc_search = "background", -- underline | background
				background_clear = {
					-- "float_win",
					"toggleterm",
					"telescope",
					"which-key",
					"renamer",
					"notify",
					"nvim-tree",
					"fzf-lua",
					-- "neo-tree",
					-- "bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
				}, -- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree", "nvim-tree", "bufferline"
				plugins = {
					bufferline = {
						underline_selected = false,
						underline_visible = false,
					},
					indent_blankline = {
						context_highlight = "default", -- default | pro
						context_start_underline = false,
					},
				},
			})
		end,
	},

	-- NOTE:: cyberdream
	{

		-- High-contrast, futuristic & vibrant colorscheme
		{
			"scottmckendry/cyberdream.nvim",
			opts = {
				transparent = true,
				italic_comments = true,
				hide_fillchars = false,
				borderless_telescope = true,
				terminal_colors = true,
			},
		},
	},

	-- NOTE:: tokyodark
	{
		"tiagovla/tokyodark.nvim",
		opts = {
			-- custom options here
		},
		config = function(_, opts)
			require("tokyodark").setup(opts) -- calling setup is optional
			vim.cmd([[colorscheme tokyodark]])
		end,
	},

	-- NOTE:: fluoromachine

	{
		"maxmx03/fluoromachine.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local fm = require("fluoromachine")

			fm.setup({
				glow = true,
				theme = "fluoromachine",
				transparent = false,
			})

			vim.cmd.colorscheme("fluoromachine")
		end,
	},
}
