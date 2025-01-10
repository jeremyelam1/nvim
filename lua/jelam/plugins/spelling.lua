return {
	{
		"kamykn/spelunker.vim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			-- Basic spelunker configuration
			vim.g.spelunker_check_type = 1 -- Aggressive checking
			vim.g.spelunker_highlight_type = 1 -- Use standard highlighting
			vim.g.enable_spelunker_vim = 1
			vim.g.spelunker_check_comments = 1 -- Enable checking in comments
			vim.g.spelunker_disable_uri_checking = 1
			vim.g.spelunker_disable_email_checking = 1
			vim.g.spelunker_disable_account_name_checking = 1
			vim.g.spelunker_target_min_char_len = 4 -- Ignore shorter words
			vim.g.spelunker_disable_auto_group = 0 -- Enable auto checking
			vim.g.spelunker_max_suggest_words = 15 -- Show more suggestions

			-- Set the spell checking colors with more visible highlighting
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					vim.cmd([[
						highlight clear SpelunkerSpellBad
						highlight clear SpelunkerComplexOrCompoundWord
						highlight SpelunkerSpellBad cterm=underline ctermfg=196 gui=undercurl,bold guifg=#ff0000 guisp=#ff0000
						highlight SpelunkerComplexOrCompoundWord cterm=underline ctermfg=196 gui=undercurl,bold guifg=#ff0000 guisp=#ff0000
						highlight SpellBad cterm=underline ctermfg=196 gui=undercurl,bold guifg=#ff0000 guisp=#ff0000
					]])
				end,
			})

			-- Apply highlights immediately
			vim.cmd([[
				highlight clear SpelunkerSpellBad
				highlight clear SpelunkerComplexOrCompoundWord
				highlight SpelunkerSpellBad cterm=underline ctermfg=196 gui=undercurl,bold guifg=#ff0000 guisp=#ff0000
				highlight SpelunkerComplexOrCompoundWord cterm=underline ctermfg=196 gui=undercurl,bold guifg=#ff0000 guisp=#ff0000
				highlight SpellBad cterm=underline ctermfg=196 gui=undercurl,bold guifg=#ff0000 guisp=#ff0000
			]])

			-- Common programming terms whitelist
			vim.g.spelunker_white_list_for_user = {
				-- Lua terms
				"nvim",
				"lua",
				"vim",
				"keymap",
				"filetype",
				"autocmd",
				"treesitter",
				"keybind",
				"config",
				"plugins",
				"neovim",
				-- Go terms
				"func",
				"struct",
				"chan",
				"goroutine",
				"println",
				"printf",
				"sprintf",
				"errorf",
				"const",
				"vars",
				"pkg",
				"fmt",
				"ctx",
				"init",
				"impl",
				"ptr",
				-- Common programming terms
				"str",
				"int",
				"bool",
				"func",
				"args",
				"param",
				"async",
				"sync",
				"err",
				"stdout",
				"stdin",
				"stderr",
				"null",
				"nil",
				"json",
				"xml",
			}

			-- Enable spell checking for specific file types
			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = { "lua", "go" },
				callback = function()
					-- Enable both vim's spell checker and spelunker
					vim.opt_local.spell = true
					vim.opt_local.spelllang = "en_us"
					-- Force check current buffer
					vim.schedule(function()
						vim.cmd([[silent! call spelunker#check()]])
					end)
				end,
			})

			-- Check spelling on text changes and buffer enter
			vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter", "InsertLeave" }, {
				pattern = { "*.lua", "*.go" },
				callback = function()
					vim.schedule(function()
						vim.cmd([[silent! call spelunker#check()]])
					end)
				end,
			})

			-- Add commands for manual checking
			vim.api.nvim_create_user_command("SpelunkerCheck", function()
				vim.cmd([[silent! call spelunker#check()]])
			end, { desc = "Check spelling in current buffer" })

			vim.api.nvim_create_user_command("SpelunkerClear", function()
				vim.cmd([[silent! call spelunker#clear()]])
			end, { desc = "Clear spelling highlights" })

			-- Initialize spelunker after the plugin is loaded
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					vim.schedule(function()
						vim.cmd([[silent! call spelunker#check()]])
					end)
				end,
			})

			-- Key mappings for spell checking
			vim.keymap.set(
				"n",
				"zl",
				"<Plug>(spelunker-correct-word)",
				{ silent = true, desc = "Correct word under cursor" }
			)

			-- Toggle spell check with visual feedback
			vim.keymap.set("n", "<leader>s", function()
				if vim.g.enable_spelunker_vim == 1 then
					-- Disable spell checking
					vim.g.enable_spelunker_vim = 0
					vim.opt_local.spell = false
					vim.cmd([[silent! call spelunker#clear()]])
					print("Spell check disabled")
				else
					-- Enable spell checking
					vim.g.enable_spelunker_vim = 1
					vim.opt_local.spell = true
					vim.cmd([[silent! call spelunker#check()]])
					print("Spell check enabled")
				end
			end, { silent = true, desc = "Toggle spell check" })

			-- Create user commands for spell check control
			vim.api.nvim_create_user_command("SpellCheckEnable", function()
				vim.g.enable_spelunker_vim = 1
				vim.opt_local.spell = true
				vim.cmd([[silent! call spelunker#check()]])
				print("Spell check enabled")
			end, { desc = "Enable spell checking" })

			vim.api.nvim_create_user_command("SpellCheckDisable", function()
				vim.g.enable_spelunker_vim = 0
				vim.opt_local.spell = false
				vim.cmd([[silent! call spelunker#clear()]])
				print("Spell check disabled")
			end, { desc = "Disable spell checking" })

			vim.api.nvim_create_user_command("SpellCheckToggle", function()
				if vim.g.enable_spelunker_vim == 1 then
					vim.cmd("SpellCheckDisable")
				else
					vim.cmd("SpellCheckEnable")
				end
			end, { desc = "Toggle spell checking" })
		end,
	},
}
