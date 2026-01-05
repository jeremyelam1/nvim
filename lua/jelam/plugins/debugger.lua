return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"leoluz/nvim-dap-go",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("dapui").setup()
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				virt_text_pos = "eol",
			})

			-- Custom setup for Go debugging to fix the ${workspaceRoot} issue
			require("dap-go").setup({
				-- dap-go configuration
				dap_configurations = {
					{
						type = "go",
						name = "Debug",
						request = "launch",
						program = "${file}",
					},
					{
						type = "go",
						name = "Debug Package",
						request = "launch",
						program = "${fileDirname}",
					},
					{
						type = "go",
						name = "Debug Main Package",
						request = "launch",
						program = "./cmd/server", -- Adjust this path to your main package
					},
					{
						type = "go",
						name = "Debug Custom Path",
						request = "launch",
						program = function()
							return vim.fn.input("Path to main package: ", vim.fn.getcwd() .. "/", "file")
						end,
					},
				},
				-- Ensure delve is properly configured
				delve = {
					path = "dlv", -- Path to the delve command
					initialize_timeout_sec = 20,
					port = "${port}",
					args = {},
					build_flags = "",
				},
			})

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			vim.fn.sign_define("DapBreakpoint", {
				text = "⏺",
				texthl = "DapBreakpoint",
				linehl = "DapBreakpoint",
				numhl = "DapBreakpoint",
			})
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function(_, opts)
			local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python3"
			require("dap-python").setup(path)
			-- require("core.utils").load_mappings("dap_python")
		end,
	},
}
