vim.cmd("colorscheme tokyodark")

-- Transparent background overrides
local function setup_transparent_highlights()
	local highlights = {
		"TelescopePromptNormal",
		"TelescopeResultsNormal", 
		"TelescopePreviewNormal",
		"TelescopePromptBorder",
		"TelescopeResultsBorder",
		"TelescopePreviewBorder", 
		"TelescopeNormal",
		"TelescopeBorder",
		"NvimTreeNormal",
		"NvimTreeNormalNC",
	}
	
	for _, highlight in ipairs(highlights) do
		vim.api.nvim_set_hl(0, highlight, { bg = "none" })
	end
end

setup_transparent_highlights()
