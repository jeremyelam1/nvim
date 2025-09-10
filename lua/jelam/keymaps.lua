-- Plugin-specific Keymaps Configuration

local km = vim.keymap

-- Insert mode shortcuts (jk is already defined in core/keymaps.lua)
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
km.set("n", "<Leader>dt", ":DapUiToggle<CR>", { desc = "Debug: UI Toggle" })
km.set("n", "<Leader>db", ":DapToggleBreakpoint<CR>", { desc = "Debug: Break point" })
km.set("n", "<Leader>dc", ":DapContinue<CR>", { desc = "Debug: Continue" })
km.set("n", "<Leader>dr", ":lua require('dapui').open({reset = true})<CR>", { desc = "Debug: Run" })

-- Yazi keymaps (using <leader>y to avoid conflict with decrement)
km.set("n", "<leader>-", "<cmd>Yazi<cr>", { desc = "Yazi: current file" })
km.set("n", "<leader>_", "<cmd>Yazi cwd<cr>", { desc = "Yazi: nvim's working directory" })

-- Enhanced spell check keymaps
km.set("n", "<leader>sn", "]s", { silent = true, desc = "Next misspelled word" })
km.set("n", "<leader>sp", "[s", { silent = true, desc = "Previous misspelled word" })
km.set("n", "<leader>sa", "zg", { silent = true, desc = "Add word to spellfile" })
km.set("n", "<leader>sb", "zw", { silent = true, desc = "Mark word as incorrect" })
km.set("n", "<leader>ss", "z=", { silent = true, desc = "Suggest corrections" })
km.set("n", "<leader>st", function()
	vim.opt_local.spell = not vim.opt_local.spell:get()
	if vim.opt_local.spell:get() then
		vim.opt_local.spelllang = { "en_us", "programming" }
	end
	print("Spell check " .. (vim.opt_local.spell:get() and "enabled" or "disabled"))
end, { desc = "Toggle spell check" })
km.set("n", "<leader>sl", function()
	vim.ui.select({ "en_us", "en_gb", "programming" }, {
		prompt = "Select spell language: ",
	}, function(choice)
		if choice then
			vim.opt_local.spelllang = choice
			print("Spell language set to: " .. choice)
		end
	end)
end, { desc = "Select spell language" })

-- Quick Fix
km.set("n", "<Leader>qf", ":copen<CR>", { desc = "Open quick fix" })

-- Maximize/minimize a split
km.set("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "Maximize/minimize a split" })
