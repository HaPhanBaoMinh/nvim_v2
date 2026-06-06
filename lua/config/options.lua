-- ~/.config/nvim/lua/config/options.lua
-- Editor options

-- Set mapleader early
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Extend PATH so user-installed tools are found
vim.env.PATH = os.getenv('HOME') .. '/.local/bin:' .. vim.env.PATH

-- General
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.clipboard:append('unnamedplus')
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.shortmess:append('c')
vim.opt.whichwrap:append('<>[]hl')
vim.opt.iskeyword:append('-')
vim.opt.formatoptions:remove('cro')

-- Searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Folding — foldmethod and foldlevel set here; foldexpr deferred to after treesitter loads
vim.opt.foldmethod = 'expr'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Paths
vim.opt.path:append('**')

-- Persistence
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo'

-- UI
vim.opt.pumheight = 10
vim.opt.conceallevel = 0
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.statusline = '%f %m %r'
