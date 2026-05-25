return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			notify_on_error = true,
			format_on_save = {
				timeout_ms = 3000,
				lsp_fallback = false,
			},

			formatters_by_ft = {
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				rust = { "rustfmt" },
			},
		})
	end,
}
