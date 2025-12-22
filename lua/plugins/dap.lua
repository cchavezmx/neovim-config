return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
		"rcarriga/nvim-dap-ui",
	},
	config = function()
		require("dapui").setup()
		require("dap-go").setup()

		local dap, dapui = require("dap"), require("dapui")

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

		dap.configurations.go = {
			{
				type = "go",
				name = "Debug grpcserver/main.go",
				request = "launch",
				program = "${workspaceFolder}/cmd/grpcserver/main.go",
				mode = "debug",
				outputMode = "remote",
			},
			{
				type = "go",
				name = "Debug wms",
				request = "launch",
				program = "${workspaceFolder}/cmd/induction-xxs/",
				mode = "debug",
				outputMode = "remote",
			},
			{
				type = "go",
				name = "Debug CMD/main.go",
				request = "launch",
				program = "${workspaceFolder}/cmd/main.go",
				mode = "debug",
				outputMode = "remote",
			},
			{
				type = "go",
				name = "Debug CMD/Service/main.go",
				request = "launch",
				program = "${workspaceFolder}/cmd/service/main.go",
				mode = "debug",
				outputMode = "remote",
			},
			{
				type = "go",
				name = "Debug CMD/server/main.go",
				request = "launch",
				program = "${workspaceFolder}/cmd/server/main.go",
				mode = "debug",
				outputMode = "remote",
			},
		}

		vim.keymap.set("n", "<Leader>dt", ":DapToggleBreakpoint<CR>")
		vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
		vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>")
		vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR>")
		vim.keymap.set("n", "<Leader>do", ":DapStepOver<CR>")
	end,
}
