-- Plugin-specific Keymaps Configuration

local km = vim.keymap

-- Insert mode shortcuts
km.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
km.set("i", "kj", "<Esc>", { desc = "Exit insert mode" })

-- FZF-Lua keymaps (wrapped to avoid module not found error)
local function setup_fzf_lua_keymaps()
	local fzf_lua = require("fzf-lua")
	km.set("n", "<leader>fr", fzf_lua.registers, { desc = "Registers" })
	km.set("n", "<leader>fm", fzf_lua.marks, { desc = "Marks" })
	km.set("n", "<leader>fk", fzf_lua.keymaps, { desc = "Keymaps" })
	km.set("n", "<leader>fb", fzf_lua.buffers, { desc = "Buffers" })
	km.set("n", "<leader>fs", fzf_lua.spell_suggest, { desc = "Spelling Suggestions" })
	km.set(
		"n",
		"<leader>tb",
		":lua require'fzf-lua'.lsp_document_symbols({winopts = {preview={wrap='wrap'}}})<cr>",
		{ desc = "Document Symbols" }
	)
end

-- Set up fzf-lua keymaps when plugin is loaded
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyDone",
	callback = function()
		if pcall(require, "fzf-lua") then
			setup_fzf_lua_keymaps()
		end
	end,
})

-- Auto-Session keymaps
km.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
km.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })

-- Theme keymaps
km.set("n", "<leader>ct", ":ThemeToggle<CR>", { desc = "Toggle through themes" })
km.set("n", "<leader>cs", ":ThemeSelect<CR>", { desc = "Select theme from menu" })

-- Telescope keymaps
km.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
km.set("n", "<leader>fe", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
km.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
km.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
km.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

-- Hop keymaps
km.set("n", "<leader>hl", "<cmd>HopLine<cr>", { desc = "Hop Line" })

-- Go Extended keymaps
km.set("n", "<leader>gr", "<cmd>GoRun<cr>", { desc = "Go Run" })
km.set("n", "<leader>gi", "<cmd>GoImport<cr>", { desc = "Go Import" })

-- Go Test/Coverage keymaps
km.set("n", "<leader>gtf", "<cmd>GoTestFunc<cr>", { desc = "Go Test Function" })
km.set("n", "<leader>gtF", "<cmd>GoTestFile<cr>", { desc = "Go Test File" })
km.set("n", "<leader>gc", "<cmd>GoCoverage<cr>", { desc = "Go Coverage" })

-- Go Debug keymaps
km.set("n", "<leader>gd", "<cmd>GoDebug<cr>", { desc = "Go Debugger: start" })
km.set("n", "<leader>gds", "<cmd>GoDebug -s<cr>", { desc = "Go Debugger: stop" })
km.set("n", "<leader>gdr", "<cmd>GoDebug -r<cr>", { desc = "Go Debugger: run" })
km.set("n", "<leader>gdb", "<cmd>GoDebug -b<cr>", { desc = "Go Debugger: break point" })

-- Go Fill keymaps
km.set("n", "<leader>gat", "<cmd>GoAlt<cr>", { desc = "Go Alternate" })
km.set("n", "<leader>gfs", "<cmd>GoFillStruct<cr>", { desc = "Go Fill Struct" })
km.set("n", "<leader>gfw", "<cmd>GoFillSwitch<cr>", { desc = "Go Fill: Switch" })
km.set("n", "<leader>gfe", "<cmd>GoIfErr<cr>", { desc = "Go Fill: If Error" })
km.set(
	"n",
	"<leader>gofp",
	"<cmd>GoFixPlurals<cr>",
	{ desc = "change func foo(b int, a int, r int) -> func foo(b, a, r int)" }
)

-- Go Tag keymaps
km.set("n", "<leader>gota", "<cmd>GoAddTag<cr>", { desc = "Go Tag: Add" })
km.set("n", "<leader>gotr", "<cmd>GoRmTag<cr>", { desc = "Go Tag: Remove" })
km.set("n", "<leader>gotc", "<cmd>GoClearTag<cr>", { desc = "Go Tag: Clear" })

-- DAP keymaps
km.set("n", "<Leader>dt", "<CR>DapUiToggle<CR>", { desc = "Debug: UI Toggle" })
km.set("n", "<Leader>db", ":DapToggleBreakpoint<CR>", { desc = "Debug: Break point" })
km.set("n", "<Leader>dc", "<CR>DapContinue<CR>", { desc = "Debug: Continue" })
km.set("n", "<Leader>dr", ":lua require('dapui').open({reset = true})<CR>", { desc = "Debug: Run" })

-- Yazi keymaps
km.set("n", "<leader>-", "<cmd>Yazi<cr>", { desc = "Yazi: current file" })
km.set("n", "<leader>cw", "<cmd>Yazi cwd<cr>", { desc = "Yazi: nvim's working directory" })

-- Spellcheck keymaps
km.set("n", "<leader>zn", "]s", { silent = true, desc = "Next misspelled word" })
km.set("n", "<leader>zp", "[s", { silent = true, desc = "Previous misspelled word" })
km.set("n", "<leader>zf", "zg", { silent = true, desc = "Add word to spellfile" })
km.set("n", "<leader>zb", "zw", { silent = true, desc = "Mark word as incorrect" })

-- Quick Fix
km.set("n", "<Leader>qf", ":copen<CR>", { desc = "Open quick fix" })

-- Maximize/minimize a split
km.set("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "Maximize/minimize a split" })
