return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        ensure_installed = {
          "lua",
          "typescript",
          "ts_ls",
          "gopls",
          "rust",
          "delve",
          "buf-language-server",
          "pylsp",
          "tailwindcss",
          "html",
          "ast_grep",
          "graphql",
          "prettier",
          "prettierd",
          "yamlfix",
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/nvim-cmp" },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v4.x",
    config = function()
      local lsp_zero = require("lsp-zero")
      vim.opt.updatetime = 500

      -- TODO: This is a temporary fix for the issue with the lsp-zero plugin
      local lsp_attch = function(client, bufnr)
        local opts = { buffer = bufnr }
        lsp_zero.highlight_symbol(client, bufnr)

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
      end

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attch,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      local lspconfig = require("lspconfig")
      lspconfig.ts_ls.setup({})
      lspconfig.gopls.setup({
        cmd = { "gopls", "-remote=auto" },
        settings = {
          gopls = {
            staticcheck = true,
            matcher = "fuzzy",
            usePlaceholders = true,
            completeUnimported = true,
            analyses = {
              unusedparams = true,
              shadow = true,
              nilness = true,
              fieldalignment = true,
            },
            gofumpt = true,
          },
        },
        on_attach = lsp_attch,
        flags = {
          debounce_text_changes = 150,
        },
      })
      lspconfig.rust_analyzer.setup({})
      lspconfig.lua_ls.setup({})
      lspconfig.eslint.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.html.setup({})
      lspconfig.cssls.setup({})
      lspconfig.pylsp.setup({})
      lspconfig.tailwindcss.setup({})
      lspconfig.ast_grep.setup({})
      lspconfig.protols.setup({})
      lspconfig.graphql.setup({})
      lspconfig.yamlls.setup({})
    end,
  },
}
