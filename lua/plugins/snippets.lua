return {
  "L3MON4D3/LuaSnip",
  config = function()
    local ls = require("luasnip")
    ls.snippets = {
      javascriptreact = {
        ls.parser.parse_snippet("comment", "{/* $1 */}"),
      },
      typescriptreact = {
        ls.parser.parse_snippet("comment", "{/* $1 */}"),
      },
    }

    vim.api.nvim_set_keymap("i", "<C-e>", "<Plug>luasnip-expand-or-jump", {})
  end,
}
