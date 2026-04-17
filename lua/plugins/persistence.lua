-- Cierra Neo-tree automáticamente antes de salir de Neovim
vim.api.nvim_create_autocmd("VimLeavePre", {
  desc = "Cerrar Neo-tree antes de salir para no romper la sesión",
  callback = function()
    pcall(vim.cmd, "Neotree close")
  end,
})

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize" },
    },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restaurar Sesión",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restaurar Última Sesión",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "No guardar sesión",
      },
    },
  },
}
