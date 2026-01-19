local km = vim.keymap

-- km.set("n", "<leader>ff", function() require("fzf-lua").files() end, { desc = "FZF Files" })
km.set("n", "<leader>fr", function() require("fzf-lua").registers() end, { desc = "Registers" })
km.set("n", "<leader>fm", function() require("fzf-lua").marks() end, { desc = "Marks" })
km.set("n", "<leader>fk", function() require("fzf-lua").keymaps() end, { desc = "Keymaps" })
-- km.set("n", "<leader>fw", function() require("fzf-lua").live_grep() end, { desc = "FZF Grep" })
km.set("n", "<leader>fb", function() require("fzf-lua").buffers() end, { desc = "FZF Buffers" })
-- km.set("n", "<leader>fj", function() require("fzf-lua").helptags() end, { desc = "Help Tags" })
-- km.set("n", "<leader>fgc", function() require("fzf-lua").git_bcommits() end, { desc = "Browse File Commits" })
-- km.set("n", "<leader>fgs", function() require("fzf-lua").git_status() end, { desc = "Git Status" })
km.set("n", "<leader>fs", function() require("fzf-lua").spell_suggest() end, { desc = "Spelling Suggestions" })
-- km.set("n", "fd", require("fzf-lua").lsp_definitions, { desc = "Jump to Definition" })
km.set(
	"n",
	"<leader>tb",
	":lua require'fzf-lua'.lsp_document_symbols({winopts = {preview={wrap='wrap'}}})<cr>",
	{ desc = "Document Symbols" }
)
-- km.set("n", "<leader>fcr", require("fzf-lua").lsp_references, { desc = "LSP Refe:ences" })
-- km.set(
-- 	"n",
-- 	"<leader>cd",
-- 	":lua require'fzf-lua'.diagnostics_document({fzf_opts = { ['--wrap'] = true }})<cr>",
-- 	{ desc = "Document Diagnostics" }
-- )
--
-- km.set(
-- 	"n",
-- 	"<leader>fa",
-- 	":lua require'fzf-lua'.lsp_code_actions({ winopts = {relative='cursor',row=1.01, col=0, height=0.2, width=0.4} })<cr>",
-- 	{ desc = "Code Actions" }
-- )

-- Auto-Session Keymaps
km.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
km.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory

-- Theme Keymaps
km.set("n", "<leader>ct", ":ThemeToggle<CR>", { desc = "Toggle through themes" })
km.set("n", "<leader>cs", ":ThemeSelect<CR>", { desc = "Select theme from menu" })
km.set("n", "<leader>co", ":OmarchySync<CR>", { desc = "Sync with Omarchy theme" })
km.set("n", "<leader>cO", ":OmarchySyncColors<CR>", { desc = "Sync colors from Omarchy" })

-- Telescope Keybinds
km.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
km.set("n", "<leader>fe", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
km.set("n", "<leader>fw", function()
	require("fzf-lua").live_grep()
end, { desc = "Find string in cwd" })
-- km.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
km.set("n", "<leader>fc", function()
	require("fzf-lua").grep_cword()
end, { desc = "Find string under cursor in cwd" })
-- km.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
km.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

-- Hop Keybinds
km.set("n", "<leader>hl", "<cmd>HopLine<cr>", { desc = "Hop Line" })

--Go Extended Keybinds
km.set("n", "<leader>gr", "<cmd>GoRun<cr>", { desc = "Go Run" })
km.set("n", "<leader>gi", "<cmd>GoImport<cr>", { desc = "Go Import" })

--Go: Test/Coverage Extended Keybinds
km.set("n", "<leader>gtf", "<cmd>GoTestFunc<cr>", { desc = "Go Test Function" })
km.set("n", "<leader>gtF", "<cmd>GoTestFile<cr>", { desc = "Go Test File" })
km.set("n", "<leader>gc", "<cmd>GoCoverage<cr>", { desc = "Go Coverage" })

--Go: Debug Extended Keybinds
km.set("n", "<leader>gd", "<cmd>GoDebug<cr>", { desc = "Go Debugger: start" })
km.set("n", "<leader>gds", "<cmd>GoDebug -s<cr>", { desc = "Go Debugger: stop" })
km.set("n", "<leader>gdr", "<cmd>GoDebug -r<cr>", { desc = "Go Debugger: run" })
km.set("n", "<leader>gdb", "<cmd>GoDebug -b<cr>", { desc = "Go Debugger: break point" })

--Go: Fill Extended Keybinds
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

km.set("n", "<leader>gota", "<cmd>GoAddTag<cr>", { desc = "Go Tag: Add" })
km.set("n", "<leader>gotr", "<cmd>GoRmTag<cr>", { desc = "Go Tag: Remove" })
km.set("n", "<leader>gotc", "<cmd>GoClearTag<cr>", { desc = "Go Tag: Clear" })

-- Dap Keybinds
km.set("n", "<Leader>dt", ":DapUiToggle<CR>", { desc = "Debug: UI Toggle" })
km.set("n", "<Leader>db", ":DapToggleBreakpoint<CR>", { desc = "Debug: Toggle breakpoint" })
km.set(
	"n",
	"<Leader>dB",
	":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ desc = "Debug: Conditional breakpoint" }
)
km.set("n", "<Leader>dc", ":DapContinue<CR>", { desc = "Debug: Continue" })
km.set("n", "<Leader>dr", ":lua require('dapui').open({reset = true})<CR>", { desc = "Debug: Reset UI" })
km.set("n", "<Leader>di", ":DapStepInto<CR>", { desc = "Debug: Step into" })
km.set("n", "<Leader>do", ":DapStepOver<CR>", { desc = "Debug: Step over" })
km.set("n", "<Leader>dO", ":DapStepOut<CR>", { desc = "Debug: Step out" })
km.set("n", "<Leader>dx", ":DapTerminate<CR>", { desc = "Debug: Terminate" })
km.set("n", "<Leader>dp", ":lua require('dap').pause()<CR>", { desc = "Debug: Pause" })
km.set("n", "<Leader>dh", ":lua require('dap.ui.widgets').hover()<CR>", { desc = "Debug: Hover" })
km.set("n", "<Leader>dR", ":DapRestartFrame<CR>", { desc = "Debug: Restart frame" })
km.set("n", "<F5>", ":DapContinue<CR>", { desc = "Debug: Continue" })
km.set("n", "<F10>", ":DapStepOver<CR>", { desc = "Debug: Step over" })
km.set("n", "<F11>", ":DapStepInto<CR>", { desc = "Debug: Step into" })
km.set("n", "<F12>", ":DapStepOut<CR>", { desc = "Debug: Step out" })

-- Yazi
km.set("n", "<leader>-", "<cmd>Yazi<cr>", { desc = "Yazi: current file" })
km.set("n", "<leader>cw", "<cmd>Yazi cwd<cr>", { desc = "Yazi: nvim's working directory" })

-- Spellcheck
vim.keymap.set("n", "<leader>zn", "]s", { silent = true, desc = "Next misspelled word" })
vim.keymap.set("n", "<leader>zp", "[s", { silent = true, desc = "Previous misspelled word" })
vim.keymap.set("n", "<leader>zf", "zg", { silent = true, desc = "Add word to spellfile" })
vim.keymap.set("n", "<leader>zb", "zw", { silent = true, desc = "Mark word as incorrect" })

-- Quick Fix
km.set("n", "<Leader>qf", ":copen<CR>", { desc = "open quick fix" })

-- Maximize/minimize a split
km.set("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "Maximize/minimize a split" })
