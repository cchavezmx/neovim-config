return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<Tab>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-j>",
			},
			ignore_filetypes = { cpp = true }, -- Puedes agregar los lenguajes que quieras ignorar
			color = {
				suggestion_color = "#8a8a8a", -- Color gris para el texto fantasma
				cterm = 244,
			},
			log_level = "info", -- "info", "warn", "error", "off"
			disable_inline_completion = false, -- Asegura que el texto fantasma esté activado
			disable_keymaps = false,
			condition = function()
				return false -- Devuelve true para deshabilitar en condiciones específicas
			end,
		})
	end,
}
