-- ~/.config/nvim/init.lua
-- Neovim configuration entry point

-- Bootstrap vim-plug
local plug_path = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'
if vim.fn.empty(vim.fn.glob(plug_path)) > 0 then
  vim.fn.system({
    'curl', '-fLo', plug_path,
    '--create-dirs',
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  })
end

-- Run plugin definitions via vim.cmd so Plug global is available
vim.cmd([[
call plug#begin(stdpath('data') . '/plugged')

" Plugin manager
Plug 'junegunn/vim-plug'

" Theme
Plug 'folke/tokyonight.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" Buffer tabs
Plug 'romgrk/barbar.nvim'

" Status line
Plug 'nvim-lualine/lualine.nvim'

" File explorer
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" Fuzzy finder
Plug 'ibhagwan/fzf-lua'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" LSP
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Formatter / linter
Plug 'stevearc/conform.nvim'

" Git
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'sindrets/diffview.nvim'

" Terminal
Plug 'akinsho/toggleterm.nvim', { 'tag': '*' }

" Smart splits (pane navigation with arrow keys)
Plug 'mrjones2014/smart-splits.nvim'

" Testing
Plug 'vim-test/vim-test'

" Trouble / diagnostics
Plug 'folke/trouble.nvim'

" Which-key
Plug 'folke/which-key.nvim'

" Comment
Plug 'numToStr/Comment.nvim'

" Marks / bookmarks
Plug 'chentoast/marks.nvim'

" Indent guides
Plug 'lukas-reineke/indent-blankline.nvim'

" Auto-pairs
Plug 'windwp/nvim-autopairs'

" Dashboard
Plug 'nvimdev/dashboard-nvim'

call plug#end()
]])

-- Load config modules (pure Lua — no plugin dependencies)
require('config.options')
require('config.autocmd')
require('config.mappings')

-- Load plugin configs with pcall so startup succeeds even before plugins are installed
local function load_plugin_configs()
  pcall(require, 'plugins')
end
vim.defer_fn(load_plugin_configs, 100)

-- NvimTree setup must run synchronously here so the tree state is ready
-- before the VimEnter autocmd fires and before any keymaps use NvimTreeToggle.
-- A separate full re-setup happens in plugins/ui.lua via defer_fn (idempotent).
local ok_ntree, ntree = pcall(require, 'nvim-tree')
if ok_ntree then
  ntree.setup({
    view = { width = 25, side = 'left' },
    renderer = {
      indent_markers = { enable = true },
      icons = {
        show = { file = false, folder = false, folder_arrow = true, git = true },
      },
    },
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_cwd = true,
    update_focused_file = { enable = true, update_cwd = true, update_root = true },
  })
end

-- Toggleterm: setup synchronously so <Space>tt works before any defer delay.
-- Keymap set here so it uses our <Space> leader (not toggleterm's default <C-t>).
local ok_tterm, tterm = pcall(require, 'toggleterm')
if ok_tterm then
  tterm.setup({
    size = function(term)
      if term.direction == 'horizontal' then return 15
      elseif term.direction == 'vertical' then return math.floor(vim.o.columns * 0.4) end
    end,
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = false,
    start_in_insert = true,
    insert_mappings = false,
    terminal_mappings = true,
    persist_size = true,
    direction = 'horizontal',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = 'curved',
      winblend = 15,
      highlights = {
        border = 'Normal',
        background = 'Normal',
      },
    },
  })
  vim.keymap.set('n', '<Space>tt', '<cmd>ToggleTerm<cr>', { noremap = true, silent = true, desc = 'Terminal toggle' })
  vim.keymap.set('n', '<C-t>', '<cmd>ToggleTerm<cr>', { noremap = true, silent = true, desc = 'Terminal toggle' })
end
