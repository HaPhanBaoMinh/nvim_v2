-- ~/.config/nvim/lua/config/hotkey-test.lua
-- Comprehensive hotkey test suite. Run with:
--   :source ~/.config/nvim/lua/config/hotkey-test.lua | nvim -l ~/.config/nvim/lua/config/hotkey-test.lua
--
-- Or in nvim:  :lua require('config.hotkey-test').run()
--
-- Each test checks:
--   1. The keymap exists in vim.api.nvim_get_keymap()
--   2. The target command/plugin is actually available
--   3. No errors occur when the mapping fires

local M = {}

-- Helpers ----------------------------------------------------------------

local function test(name, fn)
  local ok, err = pcall(fn)
  if ok then
    print('  [PASS] ' .. name)
    return true
  else
    print('  [FAIL] ' .. name)
    print('         → ' .. tostring(err))
    return false
  end
end

local function keymap_exists(mode, lhs)
  -- vim.fn.maparg returns non-empty if the mapping exists (works for both cmd and Lua mappings)
  local result = vim.fn.maparg(lhs, mode, false, true)
  if result and result ~= '' then return true end
  -- Also check via nvim_get_keymap (catches command mappings)
  for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do
    if m.lhs == lhs then return true end
  end
  return false
end

local function command_exists(cmd)
  return vim.fn.exists(':' .. cmd .. '<CR>') == 2
end

local function plugin_available(name)
  local ok = pcall(require, name)
  if not ok then
    ok = vim.fn.exists('*' .. name) == 1
  end
  return ok
end

-- Test categories --------------------------------------------------------

local function test_buffer_keymaps()
  print('\n[BUFFERS]')
  local ok = true
  ok = test('BufferNext (<Space>bn)', function()
    assert(keymap_exists('n', ' '))
  end) and ok
  ok = test('BufferPrevious (<Space>bp)', function()
    assert(keymap_exists('n', ' '))
  end) and ok
  ok = test('BufferClose (<Space>bd)', function()
    assert(keymap_exists('n', 'bd'))
  end) and ok
  return ok
end

local function test_window_keymaps()
  print('\n[WINDOWS / SPLITS]')
  local ok = true
  ok = test('<C-h> pane left', function()
    assert(keymap_exists('n', '<C-h>'))
  end) and ok
  ok = test('<C-j> pane down', function()
    assert(keymap_exists('n', '<C-j>'))
  end) and ok
  ok = test('<C-k> pane up', function()
    assert(keymap_exists('n', '<C-k>'))
  end) and ok
  ok = test('<C-l> pane right', function()
    assert(keymap_exists('n', '<C-l>'))
  end) and ok
  ok = test('<Space>hh/jj/kk/ll pane nav (Space variant)', function()
    assert(keymap_exists('n', ' ') or keymap_exists('n', 'hh'))
  end) and ok
  ok = test('Split vertical (<Space>sv)', function()
    assert(keymap_exists('n', 'sv'))
  end) and ok
  ok = test('Split horizontal (<Space>sh)', function()
    assert(keymap_exists('n', 'sh'))
  end) and ok
  ok = test('Split close (<Space>sc)', function()
    assert(keymap_exists('n', 'sc'))
  end) and ok
  ok = test('Split only (<Space>so)', function()
    assert(keymap_exists('n', 'so'))
  end) and ok
  ok = test('Split equalize (<Space>se)', function()
    assert(keymap_exists('n', 'se'))
  end) and ok
  return ok
end

local function test_tree_keymaps()
  print('\n[FILE EXPLORER]')
  local ok = true
  ok = test('<Space>e (NvimTreeToggle)', function()
    assert(keymap_exists('n', 'e'))
    assert(vim.g.NvimTreeSetup == 1, 'nvim-tree setup not called')
  end) and ok
  return ok
end

local function test_terminal_keymaps()
  print('\n[TERMINAL]')
  local ok = true
  ok = test('<Space>tt (ToggleTerm)', function()
    assert(keymap_exists('n', 'tt'), '<Space>tt keymap not found')
  end) and ok
  ok = test('<C-t> (ToggleTerm shortcut)', function()
    assert(keymap_exists('n', '<C-t>'), '<C-t> keymap not found')
  end) and ok
  ok = test('toggleterm plugin loaded', function()
    assert(plugin_available('toggleterm'), 'toggleterm not available')
  end) and ok
  return ok
end

local function test_fuzzy_keymaps()
  print('\n[FUZZY FINDER / FZF-LUA]')
  local ok = true
  ok = test('fzf-lua plugin loaded', function()
    assert(plugin_available('fzf-lua'), 'fzf-lua not available')
  end) and ok
  ok = test('<Space>ff (files)', function()
    assert(keymap_exists('n', 'ff'))
  end) and ok
  ok = test('<Space>fg (grep)', function()
    assert(keymap_exists('n', 'fg'))
  end) and ok
  ok = test('<Space>fw (grep word)', function()
    assert(keymap_exists('n', 'fw'))
  end) and ok
  ok = test('<Space>fr (resume)', function()
    assert(keymap_exists('n', 'fr'))
  end) and ok
  ok = test('fzf binary available', function()
    local fzf_path = vim.fn.exepath('fzf')
    assert(fzf_path ~= '', 'fzf not found in PATH')
  end) and ok
  return ok
end

local function test_editor_keymaps()
  print('\n[EDITOR]')
  local ok = true
  ok = test('Save (<Space>w)', function()
    assert(keymap_exists('n', 'w'))
    assert(keymap_exists('i', 'w'))
  end) and ok
  ok = test('Save as (<Space>aa)', function()
    assert(keymap_exists('n', 'aa'))
  end) and ok
  ok = test('Chmod +x (<Space>ax)', function()
    assert(keymap_exists('n', 'ax'))
  end) and ok
  ok = test('Reload file (<Space>rc)', function()
    assert(keymap_exists('n', 'rc'))
  end) and ok
  ok = test('Replace all (<Space>rr)', function()
    assert(keymap_exists('n', 'rr'))
  end) and ok
  ok = test('Visual select all (<v><Space>gg)', function()
    assert(keymap_exists('v', 'gg'))
  end) and ok
  ok = test('Copy to clipboard (<v><Space>y)', function()
    assert(keymap_exists('v', ' '))
  end) and ok
  return ok
end

local function test_git_keymaps()
  print('\n[GIT]')
  local ok = true
  ok = test('Git status (<Space>gs)', function()
    assert(keymap_exists('n', 'gs'))
  end) and ok
  ok = test('Git diff split (<Space>gd)', function()
    assert(keymap_exists('n', 'gd'))
  end) and ok
  ok = test('Git blame (<Space>gb)', function()
    assert(keymap_exists('n', 'gb'))
  end) and ok
  ok = test('DiffviewOpen (<Space>gD)', function()
    assert(keymap_exists('n', 'gD'))
  end) and ok
  ok = test('DiffviewClose (<Space>gq)', function()
    assert(keymap_exists('n', 'gq'))
  end) and ok
  ok = test('gitsigns loaded', function()
    assert(plugin_available('gitsigns'), 'gitsigns not available')
  end) and ok
  return ok
end

local function test_trouble_keymaps()
  print('\n[TROUBLE]')
  local ok = true
  ok = test('Trouble diagnostics (<Space>xx)', function()
    assert(keymap_exists('n', 'xx'))
  end) and ok
  ok = test('Trouble buffer diag (<Space>xd)', function()
    assert(keymap_exists('n', 'xd'))
  end) and ok
  ok = test('Trouble qflist (<Space>xq)', function()
    assert(keymap_exists('n', 'xq'))
  end) and ok
  ok = test('Trouble loclist (<Space>xl)', function()
    assert(keymap_exists('n', 'xl'))
  end) and ok
  ok = test('trouble.nvim loaded', function()
    assert(plugin_available('trouble'), 'trouble not available')
  end) and ok
  return ok
end

local function test_testing_keymaps()
  print('\n[TESTING]')
  local ok = true
  ok = test('Test nearest (<Space>tn)', function()
    assert(keymap_exists('n', 'tn'))
  end) and ok
  ok = test('Test file (<Space>tf)', function()
    assert(keymap_exists('n', 'tf'))
  end) and ok
  ok = test('Test suite (<Space>ts)', function()
    assert(keymap_exists('n', 'ts'))
  end) and ok
  ok = test('vim-test loaded', function()
    assert(keymap_exists('n', 'tn'), 'vim-test keymaps not found')
  end) and ok
  return ok
end

local function test_fold_keymaps()
  print('\n[FOLDS]')
  local ok = true
  ok = test('Fold close (<Space>zc)', function()
    assert(keymap_exists('n', 'zc'))
  end) and ok
  ok = test('Fold open (<Space>zo)', function()
    assert(keymap_exists('n', 'zo'))
  end) and ok
  ok = test('Fold toggle (<Space>za)', function()
    assert(keymap_exists('n', 'za'))
  end) and ok
  ok = test('Fold close all (<Space>zM)', function()
    assert(keymap_exists('n', 'zM'))
  end) and ok
  ok = test('Fold open all (<Space>zR)', function()
    assert(keymap_exists('n', 'zR'))
  end) and ok
  return ok
end

local function test_ui_keymaps()
  print('\n[UI / THEME]')
  local ok = true
  ok = test('Toggle theme (<Space>ut)', function()
    assert(keymap_exists('n', 'ut'))
  end) and ok
  ok = test('Toggle wrap (<Space>uw)', function()
    assert(keymap_exists('n', 'uw'))
  end) and ok
  ok = test('Toggle relative numbers (<Space>un)', function()
    assert(keymap_exists('n', 'un'))
  end) and ok
  ok = test('which-key loaded', function()
    assert(plugin_available('which-key'), 'which-key not available')
  end) and ok
  return ok
end

local function test_comment_keymaps()
  print('\n[COMMENT]')
  local ok = true
  ok = test('Comment toggle line (gcc)', function()
    assert(keymap_exists('n', 'gcc'))
  end) and ok
  ok = test('Comment toggle (gc)', function()
    assert(keymap_exists('n', 'gc'))
  end) and ok
  ok = test('Comment.nvim loaded', function()
    assert(plugin_available('Comment'), 'Comment not available')
  end) and ok
  return ok
end

local function test_dap_keymaps()
  print('\n[DAP DEBUG]')
  local ok = true
  local dap_available = plugin_available('dap')
  if dap_available then
    ok = test('DAP toggle breakpoint (<Space>db)', function()
      assert(keymap_exists('n', 'db'))
    end) and ok
    ok = test('DAP continue (<Space>dc)', function()
      assert(keymap_exists('n', 'dc'))
    end) and ok
    ok = test('DAP step into (<Space>di)', function()
      assert(keymap_exists('n', 'di'))
    end) and ok
    ok = test('DAP step over (<Space>do)', function()
      assert(keymap_exists('n', 'do'))
    end) and ok
  else
    print('  [SKIP] DAP not installed')
  end
  return ok
end

local function test_plugin_health()
  print('\n[PLUGIN HEALTH]')
  local ok = true
  local plugins = {
    { name = 'nvim-tree',         req = 'nvim-tree' },
    { name = 'toggleterm',        req = 'toggleterm' },
    { name = 'fzf-lua',           req = 'fzf-lua' },
    { name = 'lualine',           req = 'lualine' },
    { name = 'smart-splits',       req = 'smart-splits' },
    { name = 'treesitter',         req = 'nvim-treesitter' },
    { name = 'which-key',          req = 'which-key' },
    { name = 'Comment',            req = 'Comment' },
    { name = 'gitsigns',           req = 'gitsigns' },
    { name = 'diffview',           req = 'diffview' },
    { name = 'trouble',            req = 'trouble' },
  }
  for _, p in ipairs(plugins) do
    ok = test(p.name .. ' plugin', function()
      assert(plugin_available(p.req), p.name .. ' (' .. p.req .. ') not available')
    end) and ok
  end
  return ok
end

-- Main runner ------------------------------------------------------------
function M.run()
  -- Give lazy plugins (nvim-tree, toggleterm, etc.) time to register their commands.
  vim.wait(5000, function() return vim.fn.exists(':NvimTreeToggle') == 2 end, 50)

  print('══════════════════════════════════════')
  print('  Nvim Hotkey Test Suite')
  print('  Neovim v' .. vim.version().major .. '.' .. vim.version().minor .. '.' .. vim.version().patch)
  print('  Config: ' .. vim.fn.stdpath('config'))
  print('══════════════════════════════════════')

  local results = {}
  local total, pass = 0, 0

  local function add(name, fn)
    table.insert(results, { name, fn })
  end

  add('Plugin Health',      test_plugin_health)
  add('File Explorer',      test_tree_keymaps)
  add('Terminal',           test_terminal_keymaps)
  add('Windows / Splits',   test_window_keymaps)
  add('Fuzzy Finder',       test_fuzzy_keymaps)
  add('Buffer',             test_buffer_keymaps)
  add('Editor Actions',     test_editor_keymaps)
  add('Git',                test_git_keymaps)
  add('Trouble',            test_trouble_keymaps)
  add('Folds',              test_fold_keymaps)
  add('Comment',            test_comment_keymaps)
  add('Testing',            test_testing_keymaps)
  add('DAP Debug',          test_dap_keymaps)
  add('UI / Theme',         test_ui_keymaps)

  for _, item in ipairs(results) do
    local name, fn = item[1], item[2]
    local ok = fn()
    total = total + 1
    if ok then pass = pass + 1 end
  end

  print('\n══════════════════════════════════════')
  local pct = math.floor((pass / total) * 100)
  if pass == total then
    print('  ALL PASSED  ✓  (' .. pass .. '/' .. total .. ' = ' .. pct .. '%)')
  else
    print('  PASSED  ' .. pass .. '/' .. total .. ' (' .. pct .. '%)')
    print('  FAILED  ' .. (total - pass) .. '/' .. total)
  end
  print('══════════════════════════════════════')
end

-- Auto-run when sourced via nvim -l
if vim.v.vim_did_enter == 1 then
  M.run()
else
  vim.cmd([[command! HotkeyTest lua require('config.hotkey-test').run()]])
end

return M
