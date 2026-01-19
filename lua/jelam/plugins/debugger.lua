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

		require("dap-go").setup({
			delve = {
					path = "dlv", -- Path to the delve command
					initialize_timeout_sec = 20,
					port = "${port}",
					args = {},
					build_flags = "",
				},
			})

			dap.configurations.go = {
				{
					type = "go",
					name = "Debug main.go",
					request = "launch",
					program = "${workspaceFolder}/main.go",
				},
				{
					type = "go",
					name = "Debug config view",
					request = "launch",
					program = "${workspaceFolder}",
					args = { "config", "view" },
				},
				{
					type = "go",
					name = "Debug Scheduler Service",
					request = "launch",
					program = "${workspaceFolder}/cmd/scheduler",
					cwd = "${workspaceFolder}/cmd/scheduler",
				},
				{
					type = "go",
					name = "Debug Posting Service",
					request = "launch",
					program = "${workspaceFolder}/cmd/posting",
					cwd = "${workspaceFolder}/cmd/posting",
				},
				{
					type = "go",
					name = "Debug Current File",
					request = "launch",
					program = "${file}",
					buildFlags = "-gcflags='all=-N -l'",
					showGoroutineStack = true,
				},
				{
					type = "go",
					name = "Debug Package",
					request = "launch",
					program = "${fileDirname}",
					buildFlags = "-gcflags='all=-N -l'",
					showGoroutineStack = true,
				},
				{
					type = "go",
					name = "Debug Main Package",
					request = "launch",
					program = function()
						if vim.fn.filereadable("./cmd/server/main.go") == 1 then
							return "./cmd/server/main.go"
						elseif vim.fn.filereadable("./main.go") == 1 then
							return "./main.go"
						end
						return vim.fn.input("Path to main.go: ", "", "file")
					end,
					buildFlags = "-gcflags='all=-N -l'",
					showGoroutineStack = true,
				},
				{
					type = "go",
					name = "Debug Test",
					request = "launch",
					mode = "test",
					program = "${file}",
					buildFlags = "-gcflags='all=-N -l'",
					showGoroutineStack = true,
				},
				{
					type = "go",
					name = "Attach to Process",
					request = "attach",
					mode = "remote",
					port = function()
						return tonumber(vim.fn.input("Delve port: ", "2345"))
					end,
					host = "127.0.0.1",
					showGoroutineStack = true,
				},
			}

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
