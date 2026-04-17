-- 1. Copiamos las mismas capabilities forzando UTF-16
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-16" }

-- 2. Retornamos la configuración de ruff
return {
	capabilities = capabilities, -- ¡Esta es la línea clave que le falta a tu Ruff!
}
