return {
  {
    "junegunn/fzf.vim",
    dependencies = {
      "junegunn/fzf", -- Esto asume que usas lazy.nvim y puede instalar binario también
    },
    config = function()
      -- Puedes agregar keymaps aquí si gustas
      vim.keymap.set("n", "<leader>f", ":Files<CR>", { desc = "FZF: Buscar archivos" })
      vim.keymap.set("n", "<leader>b", ":Buffers<CR>", { desc = "FZF: Buffers abiertos" })
    end
  }
}

