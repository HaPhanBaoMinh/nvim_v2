-- ~/.config/nvim/lua/plugins/ui.lua
-- UI plugins: theme, statusline, explorer, etc.

-- Theme: TokyoNight
pcall(require, 'tokyonight').setup({
  style = 'storm',
  transparent = false,
  term_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
  },
})

-- Theme: gruvbox
pcall(require, 'gruvbox').setup({
  terminal_colors = true,
  undercurl = true,
  underline = true,
  bold = true,
  strikethrough = true,
  dim_inactive = false,
  transparent_mode = false,
})

-- Theme: Catppuccin
pcall(require, 'catppuccin').setup({
  flavour = 'mocha',
  term_colors = true,
  transparent_background = false,
  styles = {
    comments = { 'italic' },
    keywords = { 'italic' },
  },
  integrations = {
    treesitter = true,
    lualine = true,
    dashboard = true,
  },
})

vim.cmd('colorscheme tokyonight')

-- Track current theme for <Space>ut toggle (global so mappings.lua can read it)
vim.g.current_theme = 'tokyonight'

-- Status line: Lualine
local ok_lualine, lualine = pcall(require, 'lualine')
if ok_lualine then
  lualine.setup({
    options = {
      theme = 'tokyonight',
      section_separators = { left = ' ', right = ' ' },
      component_separators = { left = ' ', right = ' ' },
      globalstatus = true,
      disabled_filetypes = { statusline = { 'dashboard', 'alpha' } },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff' },
      lualine_c = {
        { 'diagnostics', symbols = { error = 'E ', warn = 'W ', info = 'I ', hint = 'H ' } },
        { 'filename', path = 1 },
      },
      lualine_x = { 'filetype', 'progress' },
      lualine_y = { 'location' },
      lualine_z = { 'searchcount', 'selectioncount' },
    },
    extensions = { 'fzf', 'toggleterm', 'nvim-tree' },
  })
end

-- File explorer: NvimTree — setup runs synchronously in init.lua so tree state is
-- ready before VimEnter autocmd fires. This call is idempotent (double-setup is safe).
local ok_nvimtree, nvimtree = pcall(require, 'nvim-tree')
if ok_nvimtree then
  vim.keymap.set('n', '<Space>e', '<cmd>NvimTreeToggle<cr>', { noremap = true, silent = true, desc = 'Explorer toggle' })
end

-- Telescope with fzf
local ok_telescope, telescope = pcall(require, 'telescope')
if ok_telescope then
  telescope.setup({
    defaults = {
      prompt_prefix = ' ',
      selection_caret = ' ',
      entry_prefix = ' ',
      path_display = { 'smart' },
      file_ignore_patterns = { 'node_modules', '.git', '__pycache__' },
      winblend = 0,
      set_env = { ['COLORTERM'] = 'truecolor' },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case',
      },
    },
  })
  pcall(telescope.load_extension, 'fzf')
end

-- WhichKey — loaded AFTER all keymaps are registered (mappings.lua runs first)
local ok_wk, wk = pcall(require, 'which-key')
if ok_wk then
  wk.setup({
    delay = 120,
    notify = false,
    window = { border = 'single' },
    layout = { align = 'center' },
  })

  wk.add({
    { '<Space> b',  group = 'buffers' },
    { '<Space> s',  group = 'split/screen' },
    { '<Space> f',  group = 'find/files' },
    { '<Space> a',  group = 'actions/file' },
    { '<Space> t',  group = 'test/term' },
    { '<Space> u',  group = 'ui' },
    { '<Space> o',  group = 'open' },
    { '<Space> g',  group = 'git' },
    { '<Space> k',  group = 'help/keymaps' },
    { '<Space> p',  group = 'plugins' },
    { '<Space> r',  group = 'replace/reload' },
    { '<Space> x',  group = 'trouble/lists' },
    { '<Space> z',  group = 'folds' },
    { '<Space> m',  group = 'make' },
    { '<Space> c',  group = 'code' },
    { 'gcc',        desc = 'Comment toggle line' },
    { 'gc',         desc = 'Comment toggle (text object)' },
    { '<Space> sv', desc = 'Split vertical' },
    { '<Space> sh', desc = 'Split horizontal' },
    { '<Space> sc', desc = 'Split close' },
    { '<Space> so', desc = 'Split only' },
    { '<Space> se', desc = 'Split equalize' },
    { '<Space> sr', desc = 'Split resize mode (Esc to quit)' },
    { '<Space> sH', desc = 'Split resize left (count x 6)' },
    { '<Space> sJ', desc = 'Split resize down (count x 6)' },
    { '<Space> sK', desc = 'Split resize up (count x 6)' },
    { '<Space> sL', desc = 'Split resize right (count x 6)' },
    { '<Space> ff', desc = 'Find files' },
    { '<Space> fg', desc = 'Find grep' },
    { '<Space> fw', desc = 'Find word under cursor' },
    { '<Space> fr', desc = 'Find resume' },
    { '<Space> fh', desc = 'Find home' },
    { '<Space> fc', desc = 'Find config' },
    { '<Space> fl', desc = 'Find local src' },
    { '<Space> as', desc = 'Action save' },
    { '<Space> aa', desc = 'Action save as' },
    { '<Space> am', desc = 'Action move file' },
    { '<Space> ax', desc = 'Action chmod +x' },
    { '<Space> e',  desc = 'Explorer toggle' },
    { '<Space> tt', desc = 'Terminal toggle' },
    { '<Space> tn', desc = 'Test nearest' },
    { '<Space> tf', desc = 'Test file' },
    { '<Space> ts', desc = 'Test suite' },
    { '<Space> tl', desc = 'Test last' },
    { '<Space> tv', desc = 'Test visit' },
    { '<Space> ut', desc = 'UI toggle theme' },
    { '<Space> uw', desc = 'UI toggle wrap' },
    { '<Space> un', desc = 'UI toggle relative numbers' },
    { '<Space> ou', desc = 'Open URL' },
    { '<Space> of', desc = 'Open file folder' },
    { '<Space> gs', desc = 'Git status' },
    { '<Space> gd', desc = 'Git diff split' },
    { '<Space> gD', desc = 'Git diffview open' },
    { '<Space> gb', desc = 'Git blame' },
    { '<Space> gh', desc = 'Git file history' },
    { '<Space> gq', desc = 'Git diffview close' },
    { '<Space> km', desc = 'Open nvim keymaps' },
    { '<Space> kt', desc = 'Open tmux keymaps' },
    { '<Space> pi', desc = 'Plugins install' },
    { '<Space> rr', desc = 'Replace all' },
    { '<Space> rc', desc = 'Reload current file' },
    { '<Space> xx', desc = 'Trouble toggle diagnostics' },
    { '<Space> xd', desc = 'Trouble buffer diagnostics' },
    { '<Space> xq', desc = 'Trouble quickfix list' },
    { '<Space> xl', desc = 'Trouble location list' },
    { '<Space> zc', desc = 'Fold close' },
    { '<Space> zo', desc = 'Fold open' },
    { '<Space> za', desc = 'Fold toggle' },
    { '<Space> zM', desc = 'Fold close all' },
    { '<Space> zR', desc = 'Fold open all' },
  })
end

-- Comment
local ok_comment, Comment = pcall(require, 'Comment')
if ok_comment then Comment.setup() end

-- Indent blankline
local ok_ibl, ibl = pcall(require, 'ibl')
if ok_ibl then ibl.setup({ scope = { enabled = true } }) end

-- Neoscroll
local ok_neoscroll, neoscroll = pcall(require, 'neoscroll')
if ok_neoscroll then
  neoscroll.setup({ easing_function = 'cubic', hide_cursor = true })
end

-- Gitsigns
local ok_gitsigns, gitsigns = pcall(require, 'gitsigns')
if ok_gitsigns then
  gitsigns.setup({
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = { follow_files = true },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = false,
    current_line_blame_opts = { virt_text = true, virt_text_pos = 'eol', delay = 1000 },
    sign_priority = 6,
    update_debounce = 100,
    max_file_length = 40000,
    preview_config = { border = 'single', style = 'minimal', relative = 'cursor', row = 0, col = 1 },
  })
end

-- Toggleterm: setup runs synchronously in init.lua so commands are ready immediately.
-- The keymap (<Space>tt) is set there too.
