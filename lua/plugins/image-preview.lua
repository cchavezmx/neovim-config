return {
  "edluffy/hologram.nvim",
  config = function()
    local hologram = require("hologram")

    vim.api.nvim_create_autocmd("BufReadPost", {
      callback = function(args)
        local buf = args.buf
        local filename = vim.api.nvim_buf_get_name(buf)

        -- Lista de extensiones soportadas
        local valid_ext = { ".png", ".jpg", ".jpeg", ".gif", ".bmp", ".webp" }

        -- Función para chequear si el archivo es imagen
        local function is_image(file)
          for _, ext in ipairs(valid_ext) do
            if file:lower():sub(- #ext) == ext then
              return true
            end
          end
          return false
        end

        -- Si es una imagen válida, renderizarla
        if is_image(filename) and vim.fn.filereadable(filename) == 1 then
          -- Render en el buffer actual (buf)
          hologram.render_image(filename, buf, {
            max_width = 80,
            max_height = 40,
          })
        end
      end,
    })

    -- Cargar tu script personalizado
    require("hologram").setup({
      auto_display = false, -- desactivamos para evitar errores
      render_options = {
        max_width = 80,
        max_height = 40,
      },
    })
  end,
}
