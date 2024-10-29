return {
  {
    "tpope/vim-dotenv",
    config = function()
      -- Carga automáticamente el archivo .env si existe al abrir Neovim en el directorio del proyecto
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
          local env_file = ".env"
          if vim.fn.filereadable(env_file) == 1 then
            vim.cmd("Dotenv " .. env_file)
          end
        end,
      })
    end,
  },
}

