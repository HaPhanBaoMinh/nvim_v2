-- ~/.config/nvim/scripts/mason-install.lua
-- Installs all Mason tools.
-- Usage: nvim -l ~/.config/nvim/scripts/mason-install.lua
--
-- Key: uses defer_fn to wait for plugins to initialize (which happens
-- asynchronously in the event loop, so even --headless needs to let
-- the loop run to load them).

local tools = {
  'stylua', 'shfmt', 'ruff', 'black', 'rustfmt',
  'goimports', 'clang_format', 'prettier', 'taplo',
  'tree-sitter-cli',
}

local function wait_and_install(attempt)
  attempt = attempt or 0
  if attempt > 40 then
    vim.api.nvim_err_writeln('Mason did not become available after 40 tries (20s)')
    vim.cmd('qa!')
    return
  end

  local ok_mason = pcall(require, 'mason')
  local ok_mr = pcall(require, 'mason-registry')

  if not ok_mason or not ok_mr then
    vim.defer_fn(function() wait_and_install(attempt + 1) end, 500)
    return
  end

  print('Mason ready after ' .. attempt .. ' checks.')
  local mr = require('mason-registry')

  local installed = {}
  local failed = {}
  local pending = {}

  for _, tool in ipairs(tools) do
    local ok_pkg, pkg = pcall(mr.get_package, tool)
    if not ok_pkg then
      print('NOT IN REGISTRY: ' .. tool)
      table.insert(failed, tool)
    elseif pkg:is_installed() then
      print('ALREADY INSTALLED: ' .. tool)
      table.insert(installed, tool)
    else
      print('INSTALLING: ' .. tool)
      pkg:once('install:failed', function(err)
        print('FAILED: ' .. tool .. ' — ' .. vim.inspect(err))
      end)
      pkg:once('install:success', function()
        print('SUCCESS: ' .. tool)
      end)
      pkg:install()
      table.insert(pending, tool)
    end
  end

  if #pending == 0 then
    print('All tools already installed.')
    vim.cmd('qa!')
    return
  end

  print('Queued ' .. #pending .. ' installs, waiting for completion...')

  -- Check install status every 5s for up to 3 minutes
  local check_count = 0
  local function check_status()
    check_count = check_count + 1
    if check_count > 36 then  -- 3 minutes max
      print('Timeout reached, some installs may still be running.')
      vim.cmd('qa!')
      return
    end

    local all_done = true
    for _, tool in ipairs(pending) do
      local ok_pkg, pkg = pcall(mr.get_package, tool)
      if ok_pkg then
        if not pkg:is_installed() then
          all_done = false
          break
        end
      end
    end

    if all_done then
      print('All installs complete!')
      vim.cmd('qa!')
    else
      print('Still installing... (' .. check_count .. '/36)')
      vim.defer_fn(check_status, 5000)
    end
  end

  vim.defer_fn(check_status, 5000)
end

wait_and_install(1)
