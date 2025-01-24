return {

	-- Better quickfix window
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		cmd = "BqfAutoToggle",
		event = { "QuickFixCmdPost", "FileType" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			auto_resize_height = true, -- automatically adjust height
			preview = {
				auto_preview = true,
				border = "rounded",
				show_title = true,
				show_scroll_bar = true,
				delay_syntax = 50,
				win_height = 15,
				win_vheight = 15,
				wrap = false,
				buf_label = true,
				should_preview_cb = function(bufnr)
					-- file size greater than 100kb can't be previewed automatically
					local filename = vim.api.nvim_buf_get_name(bufnr)
					local fsize = vim.fn.getfsize(filename)
					if fsize > 100 * 1024 then
						return false
					end
					return true
				end,
			},
			func_map = {
				tab = "st",
				split = "sv",
				vsplit = "sg",

				stoggleup = "K",
				stoggledown = "J",

				ptoggleitem = "p",
				ptoggleauto = "P",
				ptogglemode = "zp",

				pscrollup = "<C-b>",
				pscrolldown = "<C-f>",

				prevfile = "gk",
				nextfile = "gj",

				prevhist = "<S-Tab>",
				nexthist = "<Tab>",

				filter = "zn",
				filterr = "zN",
			},
			filter = {
				fzf = {
					action_for = {
						["ctrl-t"] = "tabedit",
						["ctrl-v"] = "vsplit",
						["ctrl-s"] = "split",
					},
					extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
				},
			},
		},
	},
}
