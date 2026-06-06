-- ~/.config/nvim/lua/plugins.lua
-- Plugin config loader — loads all plugin configs

local function safe_require(name)
  pcall(require, name)
end

-- Load in order: base UI first, then language tools, then reference-repo plugins
safe_require('plugins.ui')
safe_require('plugins.lsp')
safe_require('plugins.treesitter')
safe_require('plugins.formatter')

-- Reference repo plugins
safe_require('plugins.fzf-lua')
safe_require('plugins.barbar')
safe_require('plugins.trouble')
safe_require('plugins.smart-splits')
safe_require('plugins.vim-test')
safe_require('plugins.autopairs')
safe_require('plugins.dashboard')
safe_require('plugins.diffview')
safe_require('plugins.dap')
safe_require('plugins.which-key')
