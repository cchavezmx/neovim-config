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

		vim.keymap.set("n", "<F5>", dap.continue, {})
		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})

		dapgo.setup({
      dap_configurations = {
        type = "go",
        name = "Attach remote",
        mode = "remote",
        request = "attach",
      }
    })
    dapui.setup()
	end,
}
