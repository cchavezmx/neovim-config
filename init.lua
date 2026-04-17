-- ~/.config/nvim/init.lua
-- Configuración de nvim-lint para usar biome
---https://www.youtube.com/watch?v=iXIwm4mCpuc-
-- Configuración de lazy.nvim
-- videos para ver
-- https://www.youtube.com/watch?v=_6OqJrdbfs0
-- https://www.youtube.com/watch?v=n5_WLgxwkU8--
-- https://neovim.discourse.group/t/delete-all-but-current-buffer/3953
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.relativenumber = true
vim.opt.number = true
vim.keymap.set("n", "<leader>m", ":set relativenumber!<CR>", { desc = "Toggle Relative Numbers" })
vim.opt.rtp:prepend(lazypath)
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.termguicolors = true
vim.api.nvim_set_keymap("i", "<C-b>", "`", { noremap = true, silent = true })

local opts = {}
require("lazy").setup("plugins", opts)
require("lsp")
require("vim-options")
