return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettier.with({
          extra_args = { "--plugin=graphql-prettier" },
          filetypes = {
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "css",
            "scss",
            "json",
            "yaml",
            "markdown",
            "graphql",
          },
        }),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.erb_lint,
        null_ls.builtins.diagnostics.rubocop,
        null_ls.builtins.formatting.rubocop,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.gofmt,
      },
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
