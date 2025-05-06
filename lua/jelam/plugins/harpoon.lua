return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup({
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
				key = function()
					return vim.loop.cwd()
				end,
			},
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>e", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Add file" })
		vim.keymap.set("n", "<C-_>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Toggle menu" })

		-- Navigate to files
		vim.keymap.set("n", "<C-1>", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: File 1" })
		vim.keymap.set("n", "<C-2>", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: File 2" })
		vim.keymap.set("n", "<C-3>", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: File 3" })
		vim.keymap.set("n", "<C-4>", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: File 4" })

		-- Navigate through list
		vim.keymap.set("n", "<C-m>", function()
			harpoon:list():next()
		end, { desc = "Harpoon: Next file" })
		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():prev()
		end, { desc = "Harpoon: Previous file" })
	end,
}
