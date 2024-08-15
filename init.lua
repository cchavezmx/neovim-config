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
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
require("lazy").setup("plugins", opts)
require("vim-options")
