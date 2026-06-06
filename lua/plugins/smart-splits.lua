-- ~/.config/nvim/lua/plugins/smart-splits.lua
-- smart-splits.nvim configuration from reference repo

pcall(require, 'smart-splits').setup({
  ignored_buftypes = { 'nofile', 'quickfix', 'prompt' },
  ignored_filetypes = { 'NvimTree' },
  default_amount = 6,
  resize_mode = {
    quit_key = '<Space>',
    resize_keys = { 'h', 'j', 'k', 'l' },
    silent = true,
  },
})
