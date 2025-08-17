return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,
	opts = {
		provider = "openai",
		providers = {
			openai = {
				endpoint = "https://api.openai.com/v1",
				-- Elige UNO de estos modelos según disponibilidad en tu cuenta:
				-- model = "gpt-4.1-mini",
				-- model = "gpt-5",         -- si ya lo tienes habilitado
				-- model = "gpt-5-mini",    -- si existe en tu cuenta y prefieres costo/velocidad
				model = "gpt-4.1-mini",
				timeout = 30000,
				extra_request_body = {
					temperature = 0,
					max_completion_tokens = 12000,
					-- reasoning_effort = "medium", -- opcional; solo afecta modelos reasoning
				},
			},
		},
	},
	build = "make",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"echasnovski/mini.pick",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
		"ibhagwan/fzf-lua",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua",
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = { insert_mode = true },
					use_absolute_path = true,
				},
			},
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = { file_types = { "markdown", "Avante" } },
			ft = { "markdown", "Avante" },
		},
	},
}
