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
					visible = false,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
				},
				mappings = {
					["Y"] = function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local filename = node.name
						local modify = vim.fn.fnamemodify

						local results = {
							filepath,
							modify(filepath, ":."),
							modify(filepath, ":~"),
							filename,
							modify(filename, ":r"),
							modify(filename, ":e"),
						}

						vim.ui.select({
							"1. Absolute path: " .. results[1],
							"2. Path relative to CWD: " .. results[2],
							"3. Path relative to HOME: " .. results[3],
							"4. Filename: " .. results[4],
							"5. Filename without extension: " .. results[5],
							"6. Extension of the filename: " .. results[6],
						}, { prompt = "Choose to copy to clipboard:" }, function(choice)
							local i = tonumber(choice:sub(1, 1))
							local result = results[i]
							vim.fn.setreg('"', result)
							vim.notify("Copied: " .. result)
						end)
					end,
				},
			},
		})
		-- Mapeo de teclas
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
	end,
}
