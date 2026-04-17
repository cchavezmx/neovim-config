vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("gopls")
-- vim.lsp.enable("biome")
vim.lsp.enable("pyright")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("cssls")
vim.lsp.enable("html")
vim.lsp.enable("ruff")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("eslint")

-- Configuramos los atajos de teclado del LSP
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Acciones LSP",
  callback = function(event)
    -- Esta variable asegura que el atajo solo afecte al archivo actual
    local opts = { buffer = event.buf }

    -- Ir a la definición (Go to definition)
    -- Uso: Pon el cursor sobre una función y presiona 'gd'
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

    -- Ver documentación (Hover)
    -- Uso: Pon el cursor sobre una función y presiona 'K' mayúscula
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    -- Ver referencias (Dónde más se usa esta función/variable)
    -- Uso: Presiona 'gr' (Go to references)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

    -- Renombrar un símbolo en todo el proyecto (Rename)
    -- Uso: Pon el cursor en una variable y presiona Espacio + rn
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    -- Acción de código (Code Action) - Sugerencias para arreglar errores
    -- Uso: Sobre un error, presiona Espacio + ca
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})

-- Configuración global de diagnósticos
vim.diagnostic.config({
  virtual_text = true,     -- Muestra el mensaje de error junto a la línea
  signs = true,            -- Muestra el ícono (e.g., ✘) en la columna izquierda
  underline = true,        -- Subraya la palabra que tiene el error
  update_in_insert = false, -- Evita que los errores se actualicen mientras escribes
  severity_sort = true,
})
