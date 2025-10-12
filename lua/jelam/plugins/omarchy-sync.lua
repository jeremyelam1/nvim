local omarchy_theme_path = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")

local function apply_omarchy_theme()
	local theme_file = io.open(omarchy_theme_path, "r")
	if not theme_file then
		vim.notify("Omarchy theme file not found, using default", vim.log.levels.WARN)
		return
	end
	theme_file:close()

	local chunk, err = loadfile(omarchy_theme_path)
	if not chunk then
		vim.notify("Error loading Omarchy theme: " .. tostring(err), vim.log.levels.ERROR)
		return
	end

	local ok, theme_spec = pcall(chunk)
	if not ok or type(theme_spec) ~= "table" then
		return
	end

	local colorscheme_name = nil

	if theme_spec[1] then
		if type(theme_spec[1]) == "string" then
			local plugin_name = theme_spec[1]
			if plugin_name == "ribru17/bamboo.nvim" then
				colorscheme_name = "bamboo"
			end
		elseif theme_spec[1].opts and theme_spec[1].opts.colorscheme then
			colorscheme_name = theme_spec[1].opts.colorscheme
		end
	end

	if theme_spec[2] and theme_spec[2].opts and theme_spec[2].opts.colorscheme then
		colorscheme_name = theme_spec[2].opts.colorscheme
	end

	if colorscheme_name then
		vim.defer_fn(function()
			local success = pcall(vim.cmd.colorscheme, colorscheme_name)
			if success then
				local colors_module = require("jelam.utils.omarchy-colors")
				colors_module.sync_colors_from_theme()
				vim.notify("Synced to Omarchy theme: " .. colorscheme_name, vim.log.levels.INFO)
			end
		end, 200)
	end
end

local function watch_omarchy_theme()
	local w = vim.loop.new_fs_event()
	if not w then
		return
	end

	local theme_symlink = vim.fn.expand("~/.config/omarchy/current/theme")
	w:start(
		theme_symlink,
		{},
		vim.schedule_wrap(function()
			apply_omarchy_theme()
		end)
	)
end

return {
	{
		"ribru17/bamboo.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("bamboo").setup({})
		end,
	},
	{
		"neanias/everforest-nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"tahayvr/matteblack.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"gthelding/monokai-pro.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"omarchy-theme-sync",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		priority = 998,
		config = function()
			vim.api.nvim_create_user_command("OmarchySync", function()
				apply_omarchy_theme()
			end, { desc = "Sync Neovim theme with Omarchy" })

			vim.api.nvim_create_user_command("OmarchySyncColors", function()
				local colors_module = require("jelam.utils.omarchy-colors")
				if colors_module.sync_colors_from_theme() then
					vim.notify("Synced colors from Omarchy theme", vim.log.levels.INFO)
				else
					vim.notify("Failed to sync colors", vim.log.levels.WARN)
				end
			end, { desc = "Sync only colors from Omarchy theme" })

			vim.defer_fn(function()
				apply_omarchy_theme()
				watch_omarchy_theme()
			end, 300)
		end,
	},
}
