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
			local dap, dapui = require("dap"), require("dapui")

			require("dapui").setup()
			require("nvim-dap-virtual-text").setup()

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
						name = "Debug Main",
						request = "launch",
						-- Instead of ${workspaceRoot}/cmd/server/main.go
						program = function()
							return vim.fn.getcwd() .. "/cmd/server/main.go"
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

			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "⏺", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)

			-- GraphQL with Go debugger configuration
			dap.configurations.graphql = {
				{
					name = "Debug GraphQL (Go)",
					type = "go",
					request = "launch",
					program = "${workspaceFolder}",
					args = {},
					buildFlags = "",
				},
				{
					name = "Debug GraphQL Server",
					type = "go",
					request = "launch",
					program = function()
						-- Prompt for the main package path
						return vim.fn.input("Path to main package: ", vim.fn.getcwd(), "file")
					end,
					args = function()
						local args_str = vim.fn.input("Arguments: ")
						return vim.split(args_str, " ", true)
					end,
				},
				{
					name = "Debug GraphQL Test",
					type = "go",
					request = "launch",
					mode = "test",
					program = "${file}",
				},
				{
					name = "Attach to GraphQL Process",
					type = "go",
					request = "attach",
					mode = "remote",
					port = function()
						return tonumber(vim.fn.input("Port: ", "38697"))
					end,
					host = function()
						return vim.fn.input("Host: ", "127.0.0.1")
					end,
				},
			}

			-- Add keymaps for debugging
			vim.keymap.set("n", "<leader>db", function()
				dap.toggle_breakpoint()
			end, { desc = "Toggle Breakpoint" })

			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Set Conditional Breakpoint" })

			vim.keymap.set("n", "<leader>dc", function()
				dap.continue()
			end, { desc = "Continue" })

			vim.keymap.set("n", "<leader>dC", function()
				dap.run_to_cursor()
			end, { desc = "Run to Cursor" })

			vim.keymap.set("n", "<leader>dg", function()
				dap.goto_()
			end, { desc = "Go to Line (no execute)" })

			vim.keymap.set("n", "<leader>di", function()
				dap.step_into()
			end, { desc = "Step Into" })

			vim.keymap.set("n", "<leader>dj", function()
				dap.down()
			end, { desc = "Down" })

			vim.keymap.set("n", "<leader>dk", function()
				dap.up()
			end, { desc = "Up" })

			vim.keymap.set("n", "<leader>dl", function()
				dap.run_last()
			end, { desc = "Run Last" })

			vim.keymap.set("n", "<leader>do", function()
				dap.step_out()
			end, { desc = "Step Out" })

			vim.keymap.set("n", "<leader>dO", function()
				dap.step_over()
			end, { desc = "Step Over" })

			vim.keymap.set("n", "<leader>dp", function()
				dap.pause()
			end, { desc = "Pause" })

			vim.keymap.set("n", "<leader>dr", function()
				dap.repl.toggle()
			end, { desc = "Toggle REPL" })

			vim.keymap.set("n", "<leader>ds", function()
				dap.session()
			end, { desc = "Session" })

			vim.keymap.set("n", "<leader>dt", function()
				dap.terminate()
			end, { desc = "Terminate" })

			vim.keymap.set("n", "<leader>dw", function()
				require("dap.ui.widgets").hover()
			end, { desc = "Widgets" })

			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle()
			end, { desc = "Toggle UI" })

			-- GraphQL specific debug commands (Go)
			vim.keymap.set("n", "<leader>dgl", function()
				dap.run({
					type = "go",
					request = "launch",
					name = "Debug GraphQL (Go)",
					program = vim.fn.getcwd(),
				})
			end, { desc = "Debug GraphQL (Go)" })

			vim.keymap.set("n", "<leader>dgs", function()
				local program = vim.fn.input("Path to main package: ", vim.fn.getcwd(), "file")
				local args_str = vim.fn.input("Arguments: ")
				local args = vim.split(args_str, " ", true)

				dap.run({
					type = "go",
					request = "launch",
					name = "Debug GraphQL Server",
					program = program,
					args = args,
				})
			end, { desc = "Debug GraphQL Server" })

			vim.keymap.set("n", "<leader>dgt", function()
				dap.run({
					type = "go",
					request = "launch",
					name = "Debug GraphQL Test",
					mode = "test",
					program = vim.fn.expand("%:p:h"),
				})
			end, { desc = "Debug GraphQL Test" })

			vim.keymap.set("n", "<leader>dga", function()
				local port = tonumber(vim.fn.input("Port: ", "38697"))
				local host = vim.fn.input("Host: ", "127.0.0.1")

				dap.run({
					type = "go",
					request = "attach",
					name = "Attach to GraphQL Process",
					mode = "remote",
					port = port,
					host = host,
				})
			end, { desc = "Attach to GraphQL Process" })
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
