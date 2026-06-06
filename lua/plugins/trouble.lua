-- ~/.config/nvim/lua/plugins/trouble.lua
-- trouble.nvim configuration from reference repo

local ok, trouble = pcall(require, 'trouble')
if not ok then
  vim.schedule(function()
    vim.notify('[trouble.nvim] missing plugin, run :PlugInstall', vim.log.levels.WARN)
  end)
  return
end

trouble.setup({
  auto_close = false,
  auto_open = false,
  auto_preview = true,
  auto_refresh = true,
  focus = false,
  follow = true,
  warn_no_results = false,
  open_no_results = false,
  preview = { type = 'main', scratch = true },
  win = { type = 'split', position = 'right', size = 0.35 },
})
