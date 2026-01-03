local M = {}

function M.parse_kitty_colors(theme_path)
	local colors = {}
	local kitty_conf = theme_path .. "/kitty.conf"
	local file = io.open(kitty_conf, "r")
	if not file then
		return nil
	end

	for line in file:lines() do
		local key, value = line:match("^([%w_]+)%s+#(%x+)")
		if key and value then
			colors[key] = "#" .. value
		end
	end
	file:close()
	return colors
end

function M.parse_alacritty_colors(theme_path)
	local colors = {}
	local alacritty_toml = theme_path .. "/alacritty.toml"
	local file = io.open(alacritty_toml, "r")
	if not file then
		return nil
	end

	local content = file:read("*all")
	file:close()

	colors.background = content:match('background%s*=%s*[\'"]#(%x+)[\'"]')
	colors.foreground = content:match('foreground%s*=%s*[\'"]#(%x+)[\'"]')
	colors.cursor = content:match('cursor%s*=%s*[\'"]#(%x+)[\'"]')

	local normal_section = content:match("%[colors%.normal%](.-)%[")
	if normal_section then
		for name, hex in normal_section:gmatch('(%w+)%s*=%s*"#(%x+)"') do
			colors["color_" .. name] = "#" .. hex
		end
	end

	local bright_section = content:match("%[colors%.bright%](.-)%[")
	if bright_section then
		for name, hex in bright_section:gmatch('(%w+)%s*=%s*"#(%x+)"') do
			colors["bright_" .. name] = "#" .. hex
		end
	end

	if colors.background then
		colors.background = "#" .. colors.background
	end
	if colors.foreground then
		colors.foreground = "#" .. colors.foreground
	end
	if colors.cursor then
		colors.cursor = "#" .. colors.cursor
	end

	return colors
end

function M.apply_terminal_colors(colors)
	if not colors then
		return
	end

	vim.schedule(function()
		local set_hl = vim.api.nvim_set_hl

		for i = 0, 15 do
			local color_key = "color" .. i
			if colors[color_key] then
				vim.g["terminal_color_" .. i] = colors[color_key]
			end
		end

		if colors.color1 then
			set_hl(0, "Error", { fg = colors.color1 })
			set_hl(0, "ErrorMsg", { fg = colors.color1 })
			set_hl(0, "DiagnosticError", { fg = colors.color1 })
		end

		if colors.color2 then
			set_hl(0, "String", { fg = colors.color2 })
			set_hl(0, "@string", { fg = colors.color2 })
		end

		if colors.color3 then
			set_hl(0, "WarningMsg", { fg = colors.color3 })
			set_hl(0, "DiagnosticWarn", { fg = colors.color3 })
		end

		if colors.color4 then
			set_hl(0, "Function", { fg = colors.color4 })
			set_hl(0, "@function", { fg = colors.color4 })
			set_hl(0, "Identifier", { fg = colors.color4 })
		end

		if colors.color5 then
			set_hl(0, "Keyword", { fg = colors.color5 })
			set_hl(0, "@keyword", { fg = colors.color5 })
			set_hl(0, "Statement", { fg = colors.color5 })
		end

		if colors.color6 then
			set_hl(0, "DiagnosticInfo", { fg = colors.color6 })
			set_hl(0, "Type", { fg = colors.color6 })
			set_hl(0, "@type", { fg = colors.color6 })
		end

		if colors.color8 then
			set_hl(0, "Comment", { fg = colors.color8, italic = true })
			set_hl(0, "@comment", { fg = colors.color8, italic = true })
			set_hl(0, "NonText", { fg = colors.color8 })
		end

		if colors.color14 then
			set_hl(0, "DiagnosticHint", { fg = colors.color14 })
		end

		if colors.cursor then
			set_hl(0, "Cursor", { bg = colors.cursor })
			set_hl(0, "lCursor", { bg = colors.cursor })
			set_hl(0, "CursorIM", { bg = colors.cursor })
			set_hl(0, "TermCursor", { bg = colors.cursor })
		end
	end)
end

function M.sync_colors_from_theme()
	local theme_path = vim.fn.expand("~/.config/omarchy/current/theme")
	local theme_link = vim.fn.resolve(theme_path)

	local colors = M.parse_kitty_colors(theme_link)
	if not colors then
		colors = M.parse_alacritty_colors(theme_link)
	end

	if colors then
		M.apply_terminal_colors(colors)
		return true
	end
	return false
end

return M
