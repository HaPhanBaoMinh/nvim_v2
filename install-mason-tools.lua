-- ~/.config/nvim/install-mason-tools.lua
-- Installs all formatter and tool packages via Mason
-- Run with: nvim --headless -l ~/.config/nvim/install-mason-tools.lua

-- Source init.lua to bootstrap vim-plug and load plugins
vim.cmd([[
runtime! init.lua
]])

-- Give plugins time to load
vim.defer_fn(function()
  local ok, mason = pcall(require, 'mason')
  local ok2, mr = pcall(require, 'mason-registry')
  if not ok or not ok2 then
    vim.api.nvim_err_writeln('Mason or registry not loaded')
    vim.cmd('qa!')
    return
  end

  local packages = {
    'stylua',
    'shfmt',
    'ruff',
    'black',
    'rustfmt',
    'goimports',
    'clang_format',
    'prettier',
    'taplo',
    'tree-sitter-cli',
  }

  local function try_install(pkg_name)
    local ok_pkg, pkg = pcall(mr.get_package, pkg_name)
    if not ok_pkg then
      vim.api.nvim_err_writeln('Package not in registry: ' .. pkg_name)
      return false
    end
    if pkg:is_installed() then
      print('Already installed: ' .. pkg_name)
      return true
    end
    print('Installing: ' .. pkg_name)
    local handle = require('mason-core.handle')
    local pkg_handle = handle.PackageHandle(pkg.name)
    -- Use synchronous-ish install via spawn
    require('mason-core.spawn')(pkg_name, {})
    return true
  end

  for _, p in ipairs(packages) do
    try_install(p)
  end

  vim.defer_fn(function() vim.cmd('qa!') end, 2000)
end, 500)
