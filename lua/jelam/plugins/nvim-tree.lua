-- nvim-tree is currently disabled in favor of yazi
-- To enable, uncomment the plugin spec below and remove yazi.lua

-- return {
--   "nvim-tree/nvim-tree.lua",
--   dependencies = "nvim-tree/nvim-web-devicons",
--   keys = {
--     { "<C-n>", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Toggle file explorer" },
--   },
--   config = function()
--     vim.g.loaded_netrw = 1
--     vim.g.loaded_netrwPlugin = 1
--
--     require("nvim-tree").setup({
--       view = { width = 35, relativenumber = true },
--       renderer = { indent_markers = { enable = true } },
--       actions = { open_file = { window_picker = { enable = false } } },
--       filters = { custom = { ".DS_Store" } },
--       git = { ignore = false },
--     })
--   end,
-- }

return {}
