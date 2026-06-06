-- ~/.config/nvim/scripts/install-tools.lua
-- Installs all formatters/tools via Mason.
-- Run: nvim -l ~/.config/nvim/scripts/install-tools.lua
-- Or interactively: just :Mason and install manually

-- Bootstrap vim-plug so plugins load
local plug_path = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'
if vim.fn.empty(vim.fn.glob(plug_path)) > 0 then
  vim.fn.system({
    'curl', '-fLo', plug_path,
    '--create-dirs',
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  })
end
vim.cmd('runtime! autoload/plug.vim')

-- Check if Mason is available yet
local function wait_for_mason(deps, attempt)
  if attempt > 20 then
    vim.api.nvim_err_writeln('Mason not available after waiting')
    vim.cmd('qa!')
    return
  end

  local ok1, mason = pcall(require, 'mason')
  local ok2, mr = pcall(require, 'mason-registry')
  if ok1 and ok2 then
    install_tools(mason, mr)
  else
    vim.defer_fn(function() wait_for_mason(deps, attempt + 1) end, 200)
  end
end

local function install_tools(mason, mr)
  local tools = {
    'stylua', 'shfmt', 'ruff', 'black', 'rustfmt',
    'goimports', 'clang_format', 'prettier', 'taplo',
    'tree-sitter-cli',
  }

  local to_install = {}
  for _, name in ipairs(tools) do
    local ok, pkg = pcall(mr.get_package, name)
    if ok and not pkg:is_installed() then
      table.insert(to_install, pkg)
      print('Queued: ' .. name)
    else
      print('Skipped (already installed or unavailable): ' .. name)
    end
  end

  if #to_install == 0 then
    print('All tools already installed.')
    vim.cmd('qa!')
    return
  end

  mason.setup()

  local count = 0
  local total = #to_install

  vim.notify('Installing ' .. total .. ' tools via Mason...', vim.log.levels.INFO)

  for _, pkg in ipairs(to_install) do
    local name = pkg.name
    local installed, inst_err = pcall(function()
      local handle = require('mason-core.handle')
      local pkg_handle = handle.PackageHandle(name)

      pkg:once('install:success', function()
        print('✓ Installed: ' .. name)
      end)
      pkg:once('install:failed', function(err)
        vim.api.nvim_err_writeln('✗ Failed: ' .. name .. ' — ' .. vim.inspect(err))
      end)

      -- Use the install API
      pkg:install()
    end)

    if not installed then
      -- Try the simpler synchronous approach
      vim.cmd('MasonInstall ' .. name)
    end
  end

  vim.defer_fn(function()
    print('Mason install commands sent. Run :Mason to verify.')
    vim.cmd('qa!')
  end, 1000)
end

-- Start waiting for Mason
wait_for_mason(nil, 1)
