return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			-- 1. Biome: Nueva sintaxis de Neovim 0.11+
			vim.lsp.config("biome", {
				single_file_support = true,
			})
			-- Encendemos el servidor de Biome
			vim.lsp.enable("biome")

			-- 2. TypeScript: Inteligencia de código sin formateo
			vim.lsp.config("ts_ls", {
				on_attach = function(client)
					-- Evita que TS intente formatear (dejamos esa tarea a Biome)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
			})
			-- Encendemos el servidor de TypeScript
			vim.lsp.enable("ts_ls")

			-- 3. Formatear automáticamente al guardar (:w)
			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end,
	},
}
