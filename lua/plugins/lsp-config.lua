return {
  {
    "b0o/schemastore.nvim",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    }
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function ()
      require("mason").setup()
    end
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     local lspconfig = require('lspconfig')
  --     local cmp = require('cmp')
  --     lspconfig.tsserver.setup({
  --       capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  --     })
  --
  --     lspconfig.gopls.setup({
  --       on_attch = on_attach,
  --       capabilities = capabilities,
  --       cmd = {"gopls"},
  --       filetypes = {"go", "gomod", "gowork", "gotmpl"},
  --       root_dir = lspconfig.util.root_pattern("go.mod", "go.work", ".git"),
  --     })
  --   end
  -- }
}
