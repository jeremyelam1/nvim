return {
	"leath-dub/snipe.nvim",
	keys = {
		{
			"-",
			function()
				require("snipe").open_buffer_menu()
			end,
			desc = "Find buffers with Snipe",
		},
	},
	opts = {
		ui = {
			--- @type "topleft" | "bottomleft" | "topright" | "bottomright" | "center" | "cursor"
			position = "topleft",
			width = 0.8, -- Width of the window (0-1 for percentage of screen width)
			height = 0.7, -- Height of the window (0-1 for percentage of screen height)
			border = "rounded", -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
		},
		-- Notification integration with snacks.nvim if available
		on_select = function(selection)
			-- You can add custom logic here when a buffer is selected
			if package.loaded["snacks"] then
				Snacks.notifier.notify("Switched to buffer: " .. selection.name, { title = "Snipe" })
			end
		end,
	},
}
