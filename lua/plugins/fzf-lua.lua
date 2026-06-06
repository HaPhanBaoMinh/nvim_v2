-- ~/.config/nvim/lua/plugins/fzf-lua.lua
-- fzf-lua configuration with image preview support

pcall(require, 'fzf-lua').setup({
  file_icon_padding = ' ',
  keymap = {
    builtin = {
      ['<F3>'] = 'toggle-preview-wrap',
      ['<F4>'] = 'toggle-preview',
      ['<S-down>']  = 'preview-page-down',
      ['<S-up>']    = 'preview-page-up',
    },
    fzf = {
      ['ctrl-z'] = 'abort',
      ['ctrl-u'] = 'unix-line-discard',
      ['ctrl-f'] = 'half-page-down',
      ['ctrl-b'] = 'half-page-up',
      ['ctrl-a'] = 'beginning-of-line',
      ['ctrl-e'] = 'end-of-line',
      ['alt-a']  = 'toggle-all',
      ['alt-g']  = 'first',
      ['alt-G']  = 'last',
    },
  },
  previewers = {
    builtin = {
      extensions = {
        -- neovim terminal only supports viu block output
        ['png']  = { 'viu', '-b' },
        ['gif']  = { 'viu', '-b' },
        ['jpg']  = { 'viu', '-b' },
        ['jpeg'] = { 'viu', '-b' },
      },
    },
  },
})
