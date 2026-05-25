-- JSON ↔ Go structs / TypeScript interfaces
local M = {}

-- ── helpers compartidos ────────────────────────────────────────────────────────

local function pascal(s)
  s = s:gsub("_(%w)", function(c) return c:upper() end)
  s = s:gsub("-(%w)", function(c) return c:upper() end)
  return s:gsub("^%l", string.upper)
end

local function camel(s)
  s = s:gsub("_(%w)", function(c) return c:upper() end)
  s = s:gsub("-(%w)", function(c) return c:upper() end)
  return s:gsub("^%u", string.lower)
end

local function is_array(t)
  if type(t) ~= "table" or #t == 0 then return false end
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count == #t
end

local function elem_name(name)
  if #name > 2 and name:sub(-1) == "s" then return name:sub(1, -2) end
  return name .. "Item"
end

local function get_clipboard()
  local raw = vim.fn.getreg("+")
  if raw == "" then raw = vim.fn.getreg('"') end
  return raw
end

local function parse_json(raw)
  local ok, parsed = pcall(vim.fn.json_decode, raw)
  if not ok then return nil end
  if is_array(parsed) then parsed = parsed[1] end
  if type(parsed) ~= "table" then return nil end
  return parsed
end

local function insert_lines(lines)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)
end

-- ── JSON → Go struct ───────────────────────────────────────────────────────────

local analyze_go

local function add_struct(name, obj, registry)
  for _, e in ipairs(registry) do
    if e.name == name then return end
  end
  local entry = { name = name, fields = {} }
  table.insert(registry, entry)
  for k, v in pairs(obj) do
    local fname = pascal(k)
    local ftype = analyze_go(v, fname, registry)
    table.insert(entry.fields, { name = fname, type = ftype, key = k })
  end
end

analyze_go = function(val, hint, registry)
  local t = type(val)
  if t == "string" then return "string"
  elseif t == "number" then return math.floor(val) == val and "int" or "float64"
  elseif t == "boolean" then return "bool"
  elseif val == vim.NIL then return "interface{}"
  elseif t == "table" then
    if is_array(val) then
      local first = val[1]
      if type(first) == "table" and not is_array(first) then
        local child = elem_name(hint)
        add_struct(child, first, registry)
        return "[]" .. child
      end
      return "[]" .. (first ~= nil and analyze_go(first, hint, registry) or "interface{}")
    else
      add_struct(hint, val, registry)
      return hint
    end
  end
  return "interface{}"
end

local function render_go(registry)
  local lines = {}
  for i, entry in ipairs(registry) do
    table.insert(lines, "type " .. entry.name .. " struct {")
    for _, f in ipairs(entry.fields) do
      table.insert(lines, string.format(
        '\t%s %s `json:"%s" bson:"%s"`',
        f.name, f.type, f.key, f.key
      ))
    end
    table.insert(lines, "}")
    if i < #registry then table.insert(lines, "") end
  end
  return lines
end

function M.paste_as_struct(name)
  name = name or "Response"
  local raw = get_clipboard()
  if raw == "" then vim.notify("Clipboard vacío", vim.log.levels.WARN); return end
  local parsed = parse_json(raw)
  if not parsed then vim.notify("JSON inválido en clipboard", vim.log.levels.ERROR); return end
  local registry = {}
  add_struct(name, parsed, registry)
  insert_lines(render_go(registry))
  vim.notify(string.format("Go: %d struct(s) generado(s)", #registry), vim.log.levels.INFO)
end

-- ── JSON → TypeScript interface ────────────────────────────────────────────────

local analyze_ts

local function add_interface(name, obj, registry)
  for _, e in ipairs(registry) do
    if e.name == name then return end
  end
  local entry = { name = name, fields = {} }
  table.insert(registry, entry)
  for k, v in pairs(obj) do
    local fname = camel(k)
    local ftype, optional = analyze_ts(v, pascal(k), registry)
    table.insert(entry.fields, { name = fname, type = ftype, optional = optional })
  end
end

analyze_ts = function(val, hint, registry)
  local t = type(val)
  if t == "string" then return "string", false
  elseif t == "number" then return "number", false
  elseif t == "boolean" then return "boolean", false
  elseif val == vim.NIL then return "null", true
  elseif t == "table" then
    if is_array(val) then
      local first = val[1]
      if type(first) == "table" and not is_array(first) then
        local child = elem_name(hint)
        add_interface(child, first, registry)
        return child .. "[]", false
      end
      local et = first ~= nil and (analyze_ts(first, hint, registry)) or "unknown"
      return et .. "[]", false
    else
      add_interface(hint, val, registry)
      return hint, false
    end
  end
  return "unknown", false
end

local function render_ts(registry)
  local lines = {}
  for i, entry in ipairs(registry) do
    table.insert(lines, "interface " .. entry.name .. " {")
    for _, f in ipairs(entry.fields) do
      local key = f.optional and (f.name .. "?") or f.name
      table.insert(lines, string.format("  %s: %s;", key, f.type))
    end
    table.insert(lines, "}")
    if i < #registry then table.insert(lines, "") end
  end
  return lines
end

function M.paste_as_interface(name)
  name = name or "Response"
  local raw = get_clipboard()
  if raw == "" then vim.notify("Clipboard vacío", vim.log.levels.WARN); return end
  local parsed = parse_json(raw)
  if not parsed then vim.notify("JSON inválido en clipboard", vim.log.levels.ERROR); return end
  local registry = {}
  add_interface(name, parsed, registry)
  insert_lines(render_ts(registry))
  vim.notify(string.format("TS: %d interface(s) generada(s)", #registry), vim.log.levels.INFO)
end

-- ── Go struct → JSON para Postman ─────────────────────────────────────────────

-- Valor de ejemplo por tipo Go
local function go_val(gotype)
  gotype = gotype:gsub("^%*", "")  -- quita puntero
  if gotype == "string" then return ""
  elseif gotype:match("^int") or gotype:match("^uint") or gotype == "byte" or gotype == "rune" then return 0
  elseif gotype:match("^float") then return 0
  elseif gotype == "bool" then return false
  elseif gotype:match("^%[%]") then return {}
  elseif gotype == "interface{}" or gotype == "any" then return vim.NIL
  elseif gotype == "time.Time" then return "2024-01-01T00:00:00Z"
  else return vim.empty_dict()
  end
end

local function parse_struct_fields(lines)
  local fields = {}
  for _, line in ipairs(lines) do
    if line:match("^%s*//") or line:match("^%s*$") then goto continue end
    if line:match("type%s+%w+%s+struct") or line:match("^%s*}%s*$") then goto continue end

    -- Extrae el json key del tag (si existe)
    local json_key = line:match('json:"([^",`]+)')
    if json_key == "-" then goto continue end

    -- Extrae FieldName y Type (campo exportado empieza con mayúscula)
    local fname, ftype = line:match("^%s+(%u%w*)%s+([^%s`{/]+)")
    if not fname then goto continue end

    -- Sin tag json → convierte PascalCase a camelCase
    if not json_key then json_key = camel(fname) end

    table.insert(fields, { key = json_key, type = ftype })
    ::continue::
  end
  return fields
end

-- Detecta el struct más cercano al cursor (busca hacia arriba la declaración)
local function find_struct_at_cursor()
  local total = vim.api.nvim_buf_line_count(0)
  local lines = vim.api.nvim_buf_get_lines(0, 0, total, false)
  local cur = vim.api.nvim_win_get_cursor(0)[1]

  local start_i
  for i = cur, 1, -1 do
    if lines[i]:match("^type%s+%w+%s+struct%s*{") then
      start_i = i; break
    end
  end
  if not start_i then return nil end

  local depth = 0
  for i = start_i, total do
    for _ in (lines[i] or ""):gmatch("{") do depth = depth + 1 end
    for _ in (lines[i] or ""):gmatch("}") do depth = depth - 1 end
    if depth == 0 then
      local result = {}
      for j = start_i, i do table.insert(result, lines[j]) end
      return result
    end
  end
  return nil
end

local function pretty_json(obj)
  local compact = vim.fn.json_encode(obj)
  local result = vim.fn.system(
    "python3 -c 'import sys,json; print(json.dumps(json.loads(sys.stdin.read()), indent=2, ensure_ascii=False))'",
    compact
  )
  if vim.v.shell_error ~= 0 then return { compact } end
  local lines = {}
  for line in (result .. "\n"):gmatch("([^\n]*)\n") do
    table.insert(lines, line)
  end
  while lines[#lines] == "" do table.remove(lines) end
  return lines
end

local function show_json_float(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "json"
  vim.bo[buf].modifiable = false

  local w = math.min(60, vim.o.columns - 4)
  local h = math.min(#lines, vim.o.lines - 6)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = w, height = h,
    row = math.floor((vim.o.lines - h) / 2),
    col = math.floor((vim.o.columns - w) / 2),
    style = "minimal",
    border = "rounded",
    title = " Postman JSON  q=cerrar · y=copiar todo ",
    title_pos = "center",
  })

  -- q cierra, y copia todo al clipboard del sistema
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
  vim.keymap.set("n", "y", function()
    vim.fn.setreg("+", table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n"))
    vim.notify("JSON copiado al clipboard", vim.log.levels.INFO)
  end, { buffer = buf, silent = true })
end

function M.struct_to_json()
  local struct_lines = find_struct_at_cursor()
  if not struct_lines then
    vim.notify("No se encontró un struct cerca del cursor", vim.log.levels.WARN)
    return
  end

  local fields = parse_struct_fields(struct_lines)
  if #fields == 0 then
    vim.notify("El struct no tiene campos exportados", vim.log.levels.WARN)
    return
  end

  local obj = {}
  for _, f in ipairs(fields) do
    obj[f.key] = go_val(f.type)
  end

  local lines = pretty_json(obj)
  vim.fn.setreg("+", table.concat(lines, "\n"))
  show_json_float(lines)
end

-- ── keymaps ────────────────────────────────────────────────────────────────────

function M.setup()
  vim.keymap.set("n", "<leader>pj", function()
    vim.ui.input({ prompt = "Nombre del struct (Go): ", default = "Response" }, function(name)
      if name and name ~= "" then M.paste_as_struct(name) end
    end)
  end, { desc = "Pegar JSON como Go struct" })

  vim.keymap.set("n", "<leader>pt", function()
    vim.ui.input({ prompt = "Nombre de la interface (TS): ", default = "Response" }, function(name)
      if name and name ~= "" then M.paste_as_interface(name) end
    end)
  end, { desc = "Pegar JSON como TypeScript interface" })

  vim.keymap.set("n", "<leader>gj", M.struct_to_json,
    { desc = "Generar JSON para Postman desde Go struct" })
end

return M
