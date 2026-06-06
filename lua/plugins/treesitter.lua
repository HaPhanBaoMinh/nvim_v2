-- ~/.config/nvim/lua/plugins/treesitter.lua
-- Treesitter configuration

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'lua', 'vim', 'vimdoc', 'query',
    'python', 'javascript', 'typescript', 'tsx', 'jsx',
    'go', 'gomod', 'gosum', 'rust', 'toml',
    'yaml', 'json', 'jsonc', 'json5',
    'bash', 'sh', 'zsh', 'dockerfile',
    'markdown', 'markdown_inline', 'html', 'css', 'scss',
    'sql', 'ruby', 'php', 'c', 'cpp', 'cmake',
  },
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  modules = {},
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true, disable = {} },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      scope_incremental = '<S-CR>',
      node_decremental = '<BS>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['ai'] = '@conditional.outer',
        ['ii'] = '@conditional.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
      },
    },
    swap = {
      enable = true,
      swap_previous = { ['<leader>a'] = '@parameter.inner' },
      swap_next = { ['<leader>A'] = '@parameter.inner' },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
      goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
      goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
      goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
    },
    lsp_interop = {
      enable = true,
      border = 'single',
      floating_preview_opts = {},
      peek_definition_code = {
        ['<leader>pf'] = '@function.outer',
        ['<leader>pF'] = '@class.outer',
      },
    },
  },
})

-- Treesitter textobjects keymaps
vim.keymap.set({ 'n', 'x', 'o' }, 'if', ":<c-u>lua require('treesitter').select_textobject('@function.inner')<cr>",
  { desc = 'Select inside function' })
vim.keymap.set({ 'n', 'x', 'o' }, 'af', ":<c-u>lua require('treesitter').select_textobject('@function.outer')<cr>",
  { desc = 'Select around function' })
vim.keymap.set({ 'n', 'x', 'o' }, 'ic', ":<c-u>lua require('treesitter').select_textobject('@class.inner')<cr>",
  { desc = 'Select inside class' })
vim.keymap.set({ 'n', 'x', 'o' }, 'ac', ":<c-u>lua require('treesitter').select_textobject('@class.outer')<cr>",
  { desc = 'Select around class' })
