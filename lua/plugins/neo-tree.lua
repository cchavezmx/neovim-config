return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = function()
		local tree = require("neo-tree")
		tree.setup({
			filesystem = {
				filtered_items = {
					visible = false, -- Mostrar archivos ocultos de manera predeterminada
					hide_dotfiles = false, -- Ocultar archivos que empiezan con un punto
					hide_gitignored = false, -- Ocultar archivos ignorados por git
					hide_hidden = false, -- Ocultar archivos que están marcados como ocultos
				},
			},
		})
    -- Mapeo de teclas
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
	end,
}
