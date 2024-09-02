-- return {
--   "catppuccin/nvim",
--   name = "catppuccin",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require 'catppuccin'.setup()
--     vim.cmd.colorscheme 'catppuccin'
--   end
-- }
return {
  "nyngwang/nvimgelion",
  -- "catppuccin/nvim",
  config = function()
    -- require("nvimgelion").setup()
    -- require("catppuccin.palettes").get_palette("mocha")
    vim.cmd.colorscheme("nvimgelion")
    vim.api.nvim_create_autocmd({ "ColorScheme", "FileType" }, {
      callback = function()
        vim.cmd([[
      hi IndentBlanklineChar gui=nocombine guifg=#444C55
      hi IndentBlanklineSpaceChar gui=nocombine guifg=#444C55
      hi IndentBlanklineContextChar gui=nocombine guifg=#FB5E2A
      hi IndentBlanklineContextStart gui=underline guisp=#FB5E2A
    ]])
      end,
    })
  end,
}
