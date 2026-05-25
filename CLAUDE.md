# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal Neovim configuration managed with [lazy.nvim](https://github.com/folke/lazy.nvim). All plugins live under `lua/plugins/`, each in its own file returning a lazy.nvim plugin spec table.

## Entry points

- `init.lua` — bootstraps lazy.nvim, loads `plugins/`, `lsp`, and `vim-options`
- `lua/vim-options.lua` — global options, keymaps, and autocmds (leader = `<Space>`)
- `lua/lsp.lua` — enables LSP servers via `vim.lsp.enable()` and sets LSP keymaps on `LspAttach`
- `lsp/pyright.lua` — per-server config file (capabilities, on_attach, settings); pyright uses `cmp_nvim_lsp`

## Plugin file conventions

Each file in `lua/plugins/` returns a lazy.nvim spec:

```lua
return {
  "author/plugin-name",
  dependencies = { ... },
  config = function()
    require("plugin").setup({ ... })
    -- keymaps go here
  end,
}
```

`lua/plugins.lua` is intentionally empty (`return {}`); lazy.nvim auto-discovers specs from every file in the `plugins/` directory.

## Adding / modifying plugins

1. Create or edit a file in `lua/plugins/`.
2. Return the lazy.nvim spec table from that file.
3. Restart Neovim or run `:Lazy sync` to apply changes.
4. Pin versions in `lazy-lock.json` — edit that file to downgrade a plugin.

## LSP servers in use

Enabled in `lua/lsp.lua`: `lua_ls`, `ts_ls`, `gopls`, `pyright`, `tailwindcss`, `cssls`, `html`, `ruff`, `rust_analyzer`, `eslint`. Biome is disabled (commented out).

## Formatting (conform.nvim)

Auto-formats on save. Formatter mapping (`lua/plugins/conform.lua`):

| Language | Formatter |
|---|---|
| Python | `black` |
| JS/TS/HTML/CSS/JSON/YAML/MD | `prettier` |
| Lua | `stylua` |
| Rust | `rustfmt` |

Go is intentionally absent from conform — formatting is handled entirely by the `BufWritePre *.go` autocmd in `vim-options.lua`, which runs `source.organizeImports` + `vim.lsp.buf.format` via gopls. Having both active caused an LSP sync crash.

## Key mappings reference

| Key | Action |
|---|---|
| `<C-n>` | Toggle Neo-tree file explorer |
| `<leader>ff` | Telescope: find files (includes hidden) |
| `<leader>fg` | Telescope: live grep |
| `<leader><leader>` | Telescope: recent files |
| `<leader>fb` | Telescope: buffers |
| `<leader>fp` | Telescope: git files |
| `<leader>fm` | Telescope: marks |
| `<leader>fr` | Telescope: resume last search |
| `<leader>gr` | Go runner menu (Telescope picker over `cmd/*/main.go`) |
| `<leader>gs` | Stop/close Go terminal |
| `<leader>pj` | Clipboard JSON → Go struct (con tags `json` + `bson`) |
| `<leader>pt` | Clipboard JSON → TypeScript interface |
| `<leader>gj` | Go struct bajo cursor → JSON para Postman (floating window) |
| `<Leader>dt` | DAP: toggle breakpoint |
| `<Leader>dc` | DAP: continue |
| `<Leader>dx` | DAP: terminate |
| `<Leader>do` | DAP: step over |
| `K` | Lspsaga hover doc |
| `F` | Lspsaga finder |
| `gd` | LSP go to definition |
| `gr` | LSP references |
| `<leader>ca` | Lspsaga code action |
| `<leader>rn` | LSP rename |
| `<C-s>` | Save (normal + insert mode) |
| `<leader>m` | Toggle relative numbers |
| `<leader>j` | Format JSON with `jq` (JSON buffers only) |

## Custom modules

- `lua/go_runner/init.lua` — Telescope picker that scans `cmd/*/main.go` entries and runs the selected one in a split terminal. Initialized by `govim.lua` via `require("go_runner").setup()`.

- `lua/json_to_struct/init.lua` — Three-way JSON ↔ code converter. Initialized by `govim.lua` via `require("json_to_struct").setup()`.

### json_to_struct — referencia completa

#### JSON → Go struct (`<leader>pj`)

Lee el JSON del clipboard del sistema (`+`) o del registro `"` como fallback. Pide el nombre del struct raíz y lo inserta en la línea actual.

- Infiere tipos: `string`, `int`, `float64`, `bool`, `interface{}`, structs anidados, slices
- Genera tags `json:"key" bson:"key"` en cada campo
- Structs anidados se declaran como tipos separados; el nombre viene del campo en PascalCase
- Arrays de objetos generan un tipo hijo con nombre singularizado (`Items → Item`, `Users → User`; si no termina en `s`, agrega `Item`: `Data → DataItem`)
- JSON nulo (`null`) produce `interface{}`
- Si el root del JSON es un array, usa el primer elemento para inferir la forma

**Ejemplo:**
```json
{"order_id": 1, "address": {"city": "CDMX"}, "tags": ["go"]}
```
```go
type Response struct {
    OrderId int     `json:"order_id" bson:"order_id"`
    Address Address `json:"address" bson:"address"`
    Tags    []string `json:"tags" bson:"tags"`
}

type Address struct {
    City string `json:"city" bson:"city"`
}
```

#### JSON → TypeScript interface (`<leader>pt`)

Mismo proceso que el modo Go, pero genera interfaces TypeScript.

- Nombres de campos en camelCase
- Tipos: `string`, `number`, `boolean`, `null`, `Type[]`, interfaces anidadas
- Campos cuyo valor era `null` en el JSON se marcan como opcionales (`field?: null`)

**Ejemplo:**
```typescript
interface Response {
  orderId: number;
  address: Address;
  tags: string[];
}

interface Address {
  city: string;
}
```

#### Go struct → JSON para Postman (`<leader>gj`)

Detecta automáticamente el struct más cercano al cursor (busca hacia arriba la línea `type X struct {`). No requiere selección manual.

- Lee el `json:"key"` tag de cada campo; si no tiene tag, convierte el nombre PascalCase a camelCase
- Campos con `json:"-"` son ignorados
- Genera valores de ejemplo por tipo:

| Tipo Go | Valor en JSON |
|---|---|
| `string` | `""` |
| `int`, `int64`, `uint*`, `byte`, `rune` | `0` |
| `float32`, `float64` | `0` |
| `bool` | `false` |
| `[]T` | `[]` |
| `time.Time` | `"2024-01-01T00:00:00Z"` |
| `*T` | igual que `T` (desreferencia el puntero) |
| `interface{}`, `any` | `null` |
| struct anidado / tipo desconocido | `{}` |

El JSON se pretty-prints con `python3` y se abre en un floating window centrado con syntax highlight de JSON. Al mismo tiempo se copia al clipboard automáticamente.

Controles del floating window:
- `y` — copia todo el contenido al clipboard del sistema
- `q` — cierra el window

**Limitaciones conocidas:**
- Campos embedded (`type Foo struct { Base }`) son ignorados
- Structs anidados se generan como `{}` vacío; no se expanden recursivamente
- Requiere `python3` en `$PATH` para el pretty-print; sin él muestra JSON compacto en una línea

## DAP configurations (Go)

Pre-configured launch targets in `lua/plugins/dap.lua`:
- `cmd/grpcserver/main.go`
- `cmd/induction-xxs/`
- `cmd/main.go`
- `cmd/service/main.go`
- `cmd/server/main.go`

## Treesitter parsers

Auto-installed: `c`, `lua`, `python`, `typescript`, `javascript`, `astro`, `bash`, `css`, `dockerfile`, `git_config`, `git_rebase`, `gleam`, `go`, `html`, `vue`, `yaml`, `pug`, `markdown_inline`. Folding uses `nvim_treesitter#foldexpr()` with `foldlevel=99`.
