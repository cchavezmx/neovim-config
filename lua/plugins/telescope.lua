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
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local action_state = require("telescope.actions.state")

      -- Configuración base
      telescope.setup({
        defaults = {
          prompt_prefix = "🔍 ",
          selection_caret = "➜ ",
          path_display = { "smart" },
          file_ignore_patterns = { "node_modules", ".git", "dist", "build" },
          mappings = {
            n = {
              ["dd"] = function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if not selection then
                  return
                end

                -- Intentamos obtener la marca de .mark (estándar)
                -- o del primer carácter de .ordinal (donde Telescope suele mostrar la letra)
                local mark = selection.mark or (selection.ordinal and selection.ordinal:sub(1, 1))

                -- Validamos que la marca sea un solo carácter (letras, números o símbolos como ')
                if mark and #mark == 1 then
                  -- Ejecutamos el borrado
                  vim.api.nvim_command("delmarks " .. mark)

                  -- Cerramos y reabrimos Telescope para que la lista se limpie de verdad
                  local actions = require("telescope.actions")
                  actions.close(prompt_bufnr)

                  -- Pequeño delay para que a Neovim le dé tiempo de procesar antes de reabrir
                  vim.schedule(function()
                    require("telescope.builtin").marks()
                    print("✓ Marca '" .. mark .. "' eliminada")
                  end)
                else
                  print("Error: No se pudo identificar la marca. Se detectó: " .. tostring(mark))
                end
              end,
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>rg", ":Telescope registers<CR>", {})
      vim.keymap.set("n", "<leader>fp", ":Telescope git_files<CR>", {})
      vim.keymap.set(
        "n",
        "<leader>fr",
        require("telescope.builtin").resume,
        { desc = "Reanudar última búsqueda" }
      )
      vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Buscar Marks en Telescope" })
      telescope.load_extension("ui-select")
      vim.keymap.set("n", "<leader>pi", ":TelescopeImagePreview<CR>", { desc = "Preview imágenes con Kitty" })

      vim.keymap.set("n", "<leader>ff", function()
        builtin.find_files({
          hidden = true,
          no_ignore = true,
          no_ignore_parent = true,
        })
      end, { desc = "Find files (incluye ocultos)" })
    end,
  },
}
