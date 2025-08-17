return {
	{
		"rcarriga/nvim-notify",
		lazy = true,
		opts = {
			stages = "fade_in_slide_out",
			timeout = 3000,
			max_width = 50,
			max_height = 8,
			background_colour = "#000000",
			top_down = false,
		},
		init = function()
			vim.notify = function(msg, level, opts)
				opts = opts or {}
				if level == vim.log.levels.ERROR or level == vim.log.levels.WARN then
					opts.timeout = 7000
				else
					opts.timeout = 3000
				end
				require("notify")(msg, level, opts)
			end
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			-- 🔹 Barra clásica para comandos y búsqueda
			cmdline = { view = "cmdline" },
			presets = {
				bottom_search = true,
				command_palette = false, -- Desactiva el popup centrado
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = false,
			},
			views = {
				notify = { backend = "notify", replace = true },
			},
			routes = {
				{ filter = { event = "lsp", kind = "progress" }, opts = { skip = true } },
			},
		},
	},
}
