-- marks.nvim configuration
-- Enhances Neovim built-in marks with signs, navigation, and bookmarks.

local ok, marks = pcall(require, "marks")
if not ok then
  vim.schedule(function()
    vim.notify("[marks.nvim] missing plugin, run :PlugInstall", vim.log.levels.WARN)
  end)
  return
end

marks.setup({
  builtin_marks = { ".", "<", ">", "^" },
  cyclic = true,
  refresh_interval = 250,
})
