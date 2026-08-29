-- ~/.config/nvim/lua/config/autocmd.lua
-- Autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.hl.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
augroup('TrimWhitespace', { clear = true })
autocmd('BufWritePre', {
  group = 'TrimWhitespace',
  pattern = '*',
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Auto-resize splits on window resize
augroup('ResizeSplits', { clear = true })
autocmd('VimResized', {
  group = 'ResizeSplits',
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- Close certain filetypes with q
augroup('CloseOnQ', { clear = true })
autocmd('FileType', {
  group = 'CloseOnQ',
  pattern = { 'qf', 'help', 'man', 'lspinfo', 'spectre_panel' },
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true })
  end,
})

-- Show cursorline only in current window
augroup('CursorLine', { clear = true })
autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = 'CursorLine',
  callback = function()
    vim.opt.cursorline = true
  end,
})
autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = 'CursorLine',
  callback = function()
    vim.opt.cursorline = false
  end,
})

-- Remember last cursor position
augroup('LastCursorPosition', { clear = true })
autocmd('BufReadPost', {
  group = 'LastCursorPosition',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Enable spell checking for text files
augroup('SpellCheck', { clear = true })
autocmd('FileType', {
  group = 'SpellCheck',
  pattern = { 'gitcommit', 'markdown', 'text' },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Set nowrap for long lines in certain files
augroup('NoWrap', { clear = true })
autocmd('FileType', {
  group = 'NoWrap',
  pattern = { 'qf', 'help', 'man' },
  callback = function()
    vim.opt_local.wrap = false
  end,
})

-- Reload init.lua on change
augroup('ReloadInit', { clear = true })
autocmd('BufWritePost', {
  group = 'ReloadInit',
  pattern = vim.fn.stdpath('config') .. '/init.lua',
  callback = function()
    vim.cmd('source ' .. vim.fn.stdpath('config') .. '/init.lua')
    vim.notify('init.lua reloaded', vim.log.levels.INFO)
  end,
})

-- Open NvimTree on startup if no args
augroup('NvimTreeStartup', { clear = true })
autocmd('VimEnter', {
  group = 'NvimTreeStartup',
  callback = function()
    local args = vim.fn.argv()
    if #args == 0 then
      vim.cmd('NvimTreeToggle')
    end
  end,
})

-- Treesitter-based folding — set foldexpr after treesitter is available
augroup('TreeSitterFolding', { clear = true })
autocmd('FileType', {
  group = 'TreeSitterFolding',
  pattern = '*',
  callback = function()
    vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})
