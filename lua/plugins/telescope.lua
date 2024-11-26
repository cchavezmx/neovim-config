vim.g.mapleader = " "
return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-fzf-native.nvim",
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>rg", ":Telescope registers<CR>", {})
			vim.keymap.set("n", "<leader>fp", ":Telescope git_files<CR>", {})
			require("telescope").load_extension("ui-select")
    end,
  }
}
