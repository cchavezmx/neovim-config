-- Obtenemos las capabilities de autocompletado y forzamos UTF-16
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-16" }
-- Retornamos la tabla de configuración completa
return {
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		-- Configuración de lsp_signature
		require("lsp_signature").on_attach({
			bind = true,
			doc_lines = 0,
			floating_window = true,
			fix_pos = true,
			hint_enable = true,
			hint_prefix = " ",
			hint_scheme = "String",
			use_lspsaga = false,
			hi_parameter = "Search",
			max_height = 12,
			max_width = 120,
			handler_opts = {
				border = "shadow",
			},
			extra_trigger_chars = {},
		})

		-- Atajos de teclado corregidos (bufnr dentro de la tabla de opciones)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "References" })
		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = bufnr, desc = "Format" })
		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = bufnr, desc = "Diagnostic Float" })
	end,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
			},
		},
	},
}
