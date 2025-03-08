return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  "numToStr/Comment.nvim",
  config = function()
    local ts_context_commentstring = require("ts_context_commentstring")
    ts_context_commentstring.setup({
      enable_autocmd = false,
      lenguages = {
        typescriptreact = { default = "{/*", jsx = "{/* %s */}" },
        javascriptreact = { default = "{/*", jsx = "{/* %s */}" },
      },
    })

    require("Comment").setup({
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })
  end,
}
