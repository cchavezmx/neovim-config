return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dapgo = require("dap-go")

		dapui.setup()
		dapgo.setup()
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end

		-- Include the next few lines until the comment only if you feel you need it
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
		-- Include everything after this
		vim.api.nvim_set_keymap("n", "<leader>dt", ":DapUiToggle<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>db", ":DapToggleBreakpoint<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>dc", ":DapContinue<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap(
			"n",
			"<leader>dr",
			":lua require('dap').open({ restart = true })<CR>",
			{ noremap = true, silent = true }
		)
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
		dap.configurations.go = {
			{
				type = "go",
				name = "Debug Station Server gRPC",
				request = "launch",
				program = "${workspaceFolder}/cmd/grpcserver/main.go",
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
			}
		}
	end,
}
