-- Lightweight Neovim configuration for low-spec machines.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local plug = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
if vim.fn.empty(vim.fn.glob(plug)) > 0 then
	vim.notify("vim-plug is missing. Run scripts/install-tools.sh first.", vim.log.levels.ERROR)
	return
end

vim.cmd([[
call plug#begin(stdpath('data') . '/plugged')

Plug 'folke/tokyonight.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'ibhagwan/fzf-lua'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

Plug 'mason-org/mason.nvim'
Plug 'mason-org/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'saghen/blink.cmp', { 'branch': 'v1' }
Plug 'stevearc/conform.nvim'

Plug 'lewis6991/gitsigns.nvim'
Plug 'echasnovski/mini.nvim'
Plug 'folke/which-key.nvim'
Plug 'akinsho/toggleterm.nvim', { 'tag': '*' }

call plug#end()
]])

require("config.options")
require("config.autocmd")
require("config.mappings")
require("plugins")
