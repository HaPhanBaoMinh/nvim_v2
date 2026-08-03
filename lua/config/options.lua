local data_bin = vim.fn.stdpath("data") .. "/plugged/fzf/bin"
vim.env.PATH = data_bin .. ":" .. vim.fn.expand("~/.local/bin") .. ":" .. vim.env.PATH

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = { "menu", "menuone", "noselect" }

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.scrolloff = 6
opt.sidescrolloff = 4
opt.signcolumn = "yes"
opt.cursorline = true
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.showmode = false
opt.laststatus = 3
opt.pumheight = 10
opt.confirm = true
opt.shortmess:append("I")

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99

opt.statusline = " %f %m%r %= %y  %l:%c  %p%% "
