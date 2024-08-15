return {
	{
		"github/copilot.vim",
	},
	{
		"L3MON4D3/LuaSnip",
		tag = "v2.*",
		build = "make install_jsregexp",
		config = function()
			local luasnip = require("luasnip")
			luasnip.setup({
				sources = {
					require("luasnip.loaders.from_vscode").load(),
				},
			})

			vim.keymap.set({ "i" }, "<C-K>", function()
				luasnip.expand()
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-L>", function()
				luasnip.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-J>", function()
				luasnip.jump(-1)
			end, { silent = true })
		end,
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "nvim_lua" },
					{ name = "treesitter" },
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
						vim.snippet.expand(args.body)
					end,
				},
				maping = cmp.mapping.preset.insert({
					select = true,
					complete = true,
				}),
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		-- See Commands section for default commands if you want to lazy load on them
		vim.keymap.set("n", "<leader>ccq", function()
			local input = vim.fn.input("Preguntame mi chavo!!!!: ")
			if input ~= "" then
				require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
			end
		end, { noremap = true, silent = true }),
	},
}
