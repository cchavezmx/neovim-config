return {
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvimtools/none-ls-extras.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local ok_null, null_ls = pcall(require, "null-ls")
			if not ok_null then
				return
			end
			local utils = require("null-ls.utils")

			local has = function(bin)
				return vim.fn.executable(bin) == 1
			end

			-- Prettier para JS/TS/TSX, etc. (sin plugin graphql)
			local prettier_ts = null_ls.builtins.formatting.prettier.with({
				prefer_local = "node_modules/.bin", -- usa el del proyecto si existe
				filetypes = {
					"javascript",
					"typescript",
					"javascriptreact",
					"typescriptreact",
					"css",
					"scss",
					"json",
					"yaml",
					"markdown",
				},
			})

			-- Prettier SOLO para GraphQL (si lo usas)
			local prettier_graphql = null_ls.builtins.formatting.prettier.with({
				prefer_local = "node_modules/.bin",
				extra_args = { "--plugin=@prettier/plugin-graphql" },
				filetypes = { "graphql" },
			})

			-- eslint_d (opcional) — protegido por pcall
			local ok_diag, eslintd_diag = pcall(require, "none-ls.diagnostics.eslint_d")
			local ok_actions, eslintd_actions = pcall(require, "none-ls.code_actions.eslint_d")

			null_ls.setup({
				root_dir = utils.root_pattern(
					".prettierrc",
					".prettierrc.*",
					"prettier.config.*",
					"package.json",
					".git"
				),
				sources = {
					prettier_ts,
					prettier_graphql, -- quítalo si no usas GraphQL
					null_ls.builtins.formatting.goimports,
					null_ls.builtins.formatting.gofmt,
					has("stylua") and null_ls.builtins.formatting.stylua or nil,
					ok_diag and eslintd_diag or nil,
					ok_actions and eslintd_actions or nil,
				},
			})

			-- Formateo: intenta null-ls; si no hay fuente activa, cae a otros clientes
			vim.keymap.set("n", "<leader>gf", function()
				local used = false
				vim.lsp.buf.format({
					async = false,
					filter = function(c)
						if c.name == "null-ls" then
							used = true
							return true
						end
						return false
					end,
				})
				if not used then
					vim.lsp.buf.format({ async = false })
				end
			end, { desc = "Format buffer (prefer null-ls)", silent = true })
		end,
	},
}
