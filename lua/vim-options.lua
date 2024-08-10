vim = vim or {}

vim.g.mapleader = " "
vim.opt.number = true

-- Configuraciones básicas de Neovim
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set clipboard=unnamedplus")
vim.cmd("set foldmethod=indent")
vim.cmd("set foldlevel=99")
--Keymaps
-- Mapeo para guardar con Ctrl + S en modo normal y de inserción
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>a', { noremap = true, silent = true })

