return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	opts = { ["--wrap"] = true },

	previewers = {
		builtin = {
			syntax_limit_b = -102400, -- 100KB limit on highlighting files
		},
	},

	grep = {
		rg_glob = true,
		-- first returned string is the new search query
		-- second returned string are (optional) additional rg flags
		-- @return string, string?
		rg_glob_fn = function(query, opts)
			local regex, flags = query:match("^(.-)%s%-%-(.*)$")
			-- If no separator is detected will return the original query
			return (regex or query), flags
		end,
	},
	winopts = {
		preview = {
			wrap = "wrap",
		},
	},
	defaults = {
		git_icons = true,
		file_icons = true,
		color_icons = true,
		formatter = "path.filename_first",
	},
}
