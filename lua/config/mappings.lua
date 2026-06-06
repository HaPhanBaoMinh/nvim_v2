-- ~/.config/nvim/lua/config/mappings.lua
-- Full keymap set migrated from HaPhanBaoMinh/nvim

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ============================================================
-- BUFFERS (barbar.nvim)
-- ============================================================
map('n', '<Space>bn', '<cmd>BufferNext<cr>', 'Buffer next')
map('n', '<Space>bp', '<cmd>BufferPrevious<cr>', 'Buffer previous')
map('n', '<Space>bd', '<cmd>BufferClose<cr>', 'Buffer close')
map('n', '<Space>bD', '<cmd>BufferClose!<cr>', 'Buffer close force')
map('n', '<Space>ba', '<cmd>bufdo bd<cr>', 'Buffer close all')
map('n', '<Space>bh', '<cmd>BufferMovePrevious<cr>', 'Buffer move left')
map('n', '<Space>bl', '<cmd>BufferMoveNext<cr>', 'Buffer move right')
map('n', '<Space>bP', '<cmd>BufferPin<cr>', 'Buffer pin')
for i = 0, 9 do
  map('n', '<Space>' .. i, '<cmd>BufferGoto ' .. i .. '<cr>', 'Buffer ' .. i)
end
map('n', '<Space>b0', '<cmd>BufferLast<cr>', 'Buffer last')

-- ============================================================
-- WINDOWS / SPLITS (smart-splits.nvim)
-- ============================================================
local ok_smart_splits, smart_splits = pcall(require, 'smart-splits')
local resize_step = 6

if ok_smart_splits then
  local function resize_with_count(direction)
    local amount = vim.v.count1 * resize_step
    return function()
      smart_splits['resize_' .. direction](amount)
    end
  end

  -- Ctrl+hjkl: navigate panes (matching old repo style)
  vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left, { noremap = true, silent = true, desc = 'Pane left' })
  vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down, { noremap = true, silent = true, desc = 'Pane down' })
  vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up, { noremap = true, silent = true, desc = 'Pane up' })
  vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right, { noremap = true, silent = true, desc = 'Pane right' })

  map('n', '<Space>hh', smart_splits.move_cursor_left, 'Pane left')
  map('n', '<Space>jj', smart_splits.move_cursor_down, 'Pane down')
  map('n', '<Space>kk', smart_splits.move_cursor_up, 'Pane up')
  map('n', '<Space>ll', smart_splits.move_cursor_right, 'Pane right')
  map('n', '<Space>sH', resize_with_count('left'), 'Split resize left (count x 6)')
  map('n', '<Space>sJ', resize_with_count('down'), 'Split resize down (count x 6)')
  map('n', '<Space>sK', resize_with_count('up'), 'Split resize up (count x 6)')
  map('n', '<Space>sL', resize_with_count('right'), 'Split resize right (count x 6)')
else
  local function resize_cmd(cmd_base)
    return function()
      vim.cmd(cmd_base .. (vim.v.count1 * resize_step))
    end
  end
  map('n', '<Space>hh', '<C-w>h', 'Pane left')
  map('n', '<Space>jj', '<C-w>j', 'Pane down')
  map('n', '<Space>kk', '<C-w>k', 'Pane up')
  map('n', '<Space>ll', '<C-w>l', 'Pane right')
  map('n', '<Space>sH', resize_cmd('vertical resize -'), 'Split resize left (count x 6)')
  map('n', '<Space>sJ', resize_cmd('resize +'), 'Split resize down (count x 6)')
  map('n', '<Space>sK', resize_cmd('resize -'), 'Split resize up (count x 6)')
  map('n', '<Space>sL', resize_cmd('vertical resize +'), 'Split resize right (count x 6)')
end

-- Resize mode
local resize_mode_active = false
local resize_mode_maps = {}
local function resize_mode_unmap_all()
  for _, lhs in ipairs(resize_mode_maps) do
    pcall(vim.keymap.del, 'n', lhs)
  end
  resize_mode_maps = {}
end

local function exit_resize_mode()
  if not resize_mode_active then return end
  resize_mode_unmap_all()
  resize_mode_active = false
end

local ok_ss, ss = pcall(require, 'smart-splits')
if ok_ss then
  local function resize_once(direction)
    local amount = vim.v.count1 * resize_step
    ss['resize_' .. direction](amount)
  end
  map('n', '<Space>sr', function()
    if resize_mode_active then
      exit_resize_mode()
      return
    end
    resize_mode_active = true
    local function bind(lhs, rhs)
      vim.keymap.set('n', lhs, rhs, { noremap = true, silent = true })
      table.insert(resize_mode_maps, lhs)
    end
    bind('<Space>hh', function() resize_once('left') end)
    bind('<Space>jj', function() resize_once('down') end)
    bind('<Space>kk', function() resize_once('up') end)
    bind('<Space>ll', function() resize_once('right') end)
    bind('<Esc>', exit_resize_mode)
  end, 'Split resize mode (Esc to quit)')
end

-- Split actions
map('n', '<Space>sv', '<cmd>vsplit<cr>', 'Split vertical')
map('n', '<Space>sh', '<cmd>split<cr>', 'Split horizontal')
map('n', '<Space>sc', '<cmd>close<cr>', 'Split close')
map('n', '<Space>so', '<cmd>only<cr>', 'Split only')
map('n', '<Space>se', '<cmd>wincmd =<cr>', 'Split equalize')

-- ============================================================
-- FIND / SEARCH (fzf-lua)
-- ============================================================
local ok_fzf, fzf_lua = pcall(require, 'fzf-lua')
if ok_fzf then
  map('n', '<Space>ff', function() fzf_lua.files() end, 'Find files')
  map('n', '<Space>fr', function() fzf_lua.resume() end, 'Find resume')
  map('n', '<Space>fg', function() fzf_lua.grep() end, 'Find grep')
  map('n', '<Space>fw', function() fzf_lua.grep_cword() end, 'Find word under cursor')
  map('n', '<Space>fh', function() fzf_lua.files({ cwd = '~/' }) end, 'Find home')
  map('n', '<Space>fc', function() fzf_lua.files({ cwd = '~/.config' }) end, 'Find config')
  map('n', '<Space>fl', function() fzf_lua.files({ cwd = '~/.local/src' }) end, 'Find local src')
end

-- ============================================================
-- QUICK NAV / HELP
-- ============================================================
map('n', '<Space><Space>', '<C-o>', 'Jump back')
map('n', '<Space>km', '<cmd>edit ~/.config/nvim/lua/config/mappings.lua<cr>', 'Open nvim keymaps')
map('n', '<Space>kt', '<cmd>edit ~/.tmux.conf<cr>', 'Open tmux keymaps')

-- ============================================================
-- GUI-STYLE SHORTCUTS
-- ============================================================
map('v', '<Space>gg', 'ggVG', 'Select all')
map('v', '<Space>y', '"+y', 'Copy to system clipboard')
map('n', '<Space>w', '<cmd>write<cr>', 'Save')
map('i', '<Space>w', '<Esc><cmd>write<cr>', 'Save (insert mode)')
map('v', '<Space>w', '<Esc><cmd>write<cr>', 'Save (visual)')

-- ============================================================
-- ACTIONS / FILE
-- ============================================================
map('n', '<Space>as', '<cmd>write<cr>', 'Action save')
map('n', '<Space>aa', '<cmd>saveas<cr>', 'Action save as')
map('n', '<Space>ax', '<cmd>!chmod +x %<cr>', 'Action chmod +x')
map('n', '<Space>am', '<cmd>!mv % ', 'Action move file')
-- <Space>e is set in plugins/ui.lua after nvimtree.setup() completes

-- ============================================================
-- TERMINAL
-- ============================================================
map('n', '<Space>tt', '<cmd>ToggleTerm<cr>', 'Terminal toggle')
map('t', '<Esc>', '<cmd>ToggleTerm<cr>', 'Terminal close')

-- ============================================================
-- REPLACE / RELOAD
-- ============================================================
map('n', '<Space>rr', ':%s//g<Left><Left>', 'Replace all')
map('n', '<Space>rc', '<cmd>source %<cr>', 'Reload current file')

-- ============================================================
-- OPEN / URL
-- ============================================================
map('n', '<Space>ou', '<cmd>silent !xdg-open " "<Left>', 'Open URL')
map('n', '<Space>of', '<cmd>silent !xdg-open %:p:h &<cr>', 'Open file folder')

-- ============================================================
-- UI TOGGLES
-- ============================================================
map('n', '<Space>ut', function()
  local themes = { 'tokyonight', 'gruvbox', 'catppuccin' }
  local current = vim.g.current_theme or 'tokyonight'
  for i, t in ipairs(themes) do
    if t == current then
      local next_theme = themes[(i % #themes) + 1]
      vim.cmd('colorscheme ' .. next_theme)
      vim.g.current_theme = next_theme
      return
    end
  end
  vim.cmd('colorscheme tokyonight')
  vim.g.current_theme = 'tokyonight'
end, 'UI toggle theme')
map('n', '<Space>uw', '<cmd>set wrap!<cr>', 'UI toggle wrap')
map('n', '<Space>un', function()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.wo.number = true
  else
    vim.wo.relativenumber = true
  end
end, 'UI toggle relative numbers')

-- ============================================================
-- GIT (vim-fugitive)
-- ============================================================
map('n', '<Space>gs', '<cmd>Git<cr>', 'Git status')
map('n', '<Space>gd', '<cmd>Gvdiffsplit<cr>', 'Git diff split')
map('n', '<Space>gb', '<cmd>Git blame<cr>', 'Git blame')
map('n', '<Space>gD', '<cmd>DiffviewOpen<cr>', 'Git diffview open')
map('n', '<Space>gh', '<cmd>DiffviewFileHistory %<cr>', 'Git file history')
map('n', '<Space>gq', '<cmd>DiffviewClose<cr>', 'Git diffview close')

-- ============================================================
-- TESTING (vim-test)
-- ============================================================
map('n', '<Space>tn', '<cmd>TestNearest<cr>', 'Test nearest')
map('n', '<Space>tf', '<cmd>TestFile<cr>', 'Test file')
map('n', '<Space>ts', '<cmd>TestSuite<cr>', 'Test suite')
map('n', '<Space>tl', '<cmd>TestLast<cr>', 'Test last')
map('n', '<Space>tv', '<cmd>TestVisit<cr>', 'Test visit')

-- ============================================================
-- TROUBLE (trouble.nvim)
-- ============================================================
map('n', '<Space>xx', '<cmd>Trouble diagnostics toggle<cr>', 'Trouble toggle diagnostics')
map('n', '<Space>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', 'Trouble buffer diagnostics')
map('n', '<Space>xq', '<cmd>Trouble qflist toggle<cr>', 'Trouble quickfix list')
map('n', '<Space>xl', '<cmd>Trouble loclist toggle<cr>', 'Trouble location list')

-- ============================================================
-- FOLDS
-- ============================================================
map('n', '<Space>zc', 'zc', 'Fold close')
map('n', '<Space>zo', 'zo', 'Fold open')
map('n', '<Space>za', 'za', 'Fold toggle')
map('n', '<Space>zM', 'zM', 'Fold close all')
map('n', '<Space>zR', 'zR', 'Fold open all')

-- ============================================================
-- PLUGINS
-- ============================================================
map('n', '<Space>pi', '<cmd>PlugInstall<cr>', 'Plugins install')

-- ============================================================
-- DAP (debug)
-- ============================================================
local ok_dap, dap = pcall(require, 'dap')
if ok_dap then
  map('n', '<Space>db', dap.toggle_breakpoint, 'DAP toggle breakpoint')
  map('n', '<Space>dB', function()
    dap.set_breakpoint(vim.fn.input('Condition: '))
  end, 'DAP conditional breakpoint')
  map('n', '<Space>dc', dap.continue, 'DAP continue')
  map('n', '<Space>di', dap.step_into, 'DAP step into')
  map('n', '<Space>do', dap.step_over, 'DAP step over')
  map('n', '<Space>dO', dap.step_out, 'DAP step out')
  map('n', '<Space>dr', dap.repl.open, 'DAP REPL')
end
local ok_dapui, dapui = pcall(require, 'dapui')
if ok_dapui then
  map('n', '<Space>du', dapui.toggle, 'DAP UI toggle')
end
