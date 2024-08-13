return {
	"nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {
				"c",
				"lua",
				"python",
				"javascript",
				"astro",
				"bash",
				"css",
				"dockerfile",
				"git_config",
				"git_rebase",
				"gleam",
				"go",
				"html",
				"vue",
				"yaml",
			},
			sync_install = false,
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
      fold = { enable = true },
		})
	end,
}
