-- ~/.config/nvim/lua/plugins/lsp.lua
-- LSP configuration (Neovim 0.10/0.11/0.12 compatible — no vim.lsp.config)

local ok_luasnip, luasnip = pcall(require, 'luasnip')
if ok_luasnip then
  luasnip.loaders.from_vscode.lazy_load()
end

-- Completion
local ok_cmp, cmp = pcall(require, 'cmp')
if not ok_cmp then return end

cmp.setup({
  completion = { keyword_length = 1 },
  snippet = { expand = function(args)
    if ok_luasnip then luasnip.lsp_expand(args.body) end
  end },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<S-CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif ok_luasnip and luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      elseif ok_luasnip and luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources(
    { { name = 'nvim_lsp' }, { name = 'luasnip' } },
    { { name = 'buffer' }, { name = 'path' }, { name = 'cmdline' } }
  ),
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = 'LSP',
        luasnip = 'LuaSnip',
        buffer = 'Buffer',
        path = 'Path',
        cmdline = 'Cmd',
      })[entry.source.name] or ''
      return vim_item
    end,
  },
  window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
  experimental = { ghost_text = true },
})

cmp.setup.filetype('gitcommit', { sources = { { name = 'cmp_git' }, { name = 'buffer' } } })
cmp.setup.cmdline({ '/', '?' }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })
cmp.setup.cmdline(':', { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'path' }, { name = 'cmdline' } } })

-- LSP capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Mason setup
local ok_mason, mason = pcall(require, 'mason')
if not ok_mason then return end
mason.setup({ ui = { border = 'single' } })

local ok_mason_lspconfig, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not ok_mason_lspconfig then return end

-- rust-analyzer binary detection (from reference repo)
local function rust_analyzer_cmd()
  local data = vim.fn.stdpath('data')
  local mason_ra = data .. '/mason/bin/rust-analyzer'
  if vim.fn.executable(mason_ra) == 1 then return { mason_ra } end
  local pkg = data .. '/mason/packages/rust-analyzer'
  if vim.fn.isdirectory(pkg) == 1 then
    for _, p in ipairs(vim.fn.glob(pkg .. '/rust-analyzer*', false, true)) do
      if vim.fn.executable(p) == 1 and vim.fn.isdirectory(p) == 0 then return { p } end
    end
  end
  local out = vim.fn.system('rustup which rust-analyzer 2>/dev/null')
  if vim.v.shell_error == 0 and out and vim.trim(out) ~= '' then
    local p = vim.trim(out)
    if vim.fn.executable(p) == 1 then return { p } end
  end
  return nil
end

local rust_cmd = rust_analyzer_cmd()
if not rust_cmd then
  vim.notify_once(
    '[nvim] rust-analyzer not found. Run :MasonInstall rust-analyzer OR: rustup component add rust-analyzer',
    vim.log.levels.WARN
  )
end

-- Mason servers config
local mason_servers = {
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file('', true) },
      },
    },
  },
  pyright = {},
  gopls = {
    settings = {
      gopls = {
        analyses = { unusedparams = true, shadow = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
  ts_ls = {},
  bashls = {},
  rust_analyzer = rust_cmd and { cmd = rust_cmd, settings = { ['rust-analyzer'] = { cargo = { allFeatures = true } } } } or {},
  clangd = {},
  jsonls = {},
  yamlls = {},
  html = {},
  cssls = {},
  dockerls = {},
}

mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(mason_servers) })
mason_lspconfig.setup_handlers({
  function(server_name)
    local server_opts = mason_servers[server_name] or {}
    local ok_lspconfig, lspconfig = pcall(require, 'lspconfig')
    if not ok_lspconfig then return end
    pcall(lspconfig[server_name].setup, vim.tbl_deep_extend('force', { capabilities = capabilities }, server_opts))
  end,
})

-- LSP handlers
local function hover_popup(err, result, ctx, config)
  local lsp_hover = vim.lsp.handlers.hover
  local merged = vim.tbl_deep_extend('force', config or {}, {
    border = 'rounded',
    max_width = math.min(88, vim.o.columns - 8),
    max_height = math.min(28, vim.o.lines - 8),
    focusable = true,
    focus = false,
  })
  return lsp_hover(err, result, ctx, merged)
end

vim.lsp.handlers['textDocument/hover'] = hover_popup
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'rounded', max_height = 14,
})

-- LSP keymaps
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspAttach', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then client.handlers['textDocument/hover'] = hover_popup end
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
    end
    map('n', 'gd', vim.lsp.buf.definition, 'LSP definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'LSP declaration')
    map('n', 'gr', vim.lsp.buf.references, 'LSP references')
    map('n', 'gi', vim.lsp.buf.implementation, 'LSP implementation')
    map('n', 'K', vim.lsp.buf.hover, 'LSP hover')
    map('n', '<Space>cr', vim.lsp.buf.rename, 'LSP rename')
    map({ 'n', 'v' }, '<Space>ca', vim.lsp.buf.code_action, 'LSP code action')
    map('n', '<Space>cd', vim.diagnostic.open_float, 'Diagnostic float')
    map('n', '[d', function() vim.diagnostic.goto_prev({ float = false }) end, 'Prev diagnostic')
    map('n', ']d', function() vim.diagnostic.goto_next({ float = false }) end, 'Next diagnostic')
    map('n', '<Space>cf', function() vim.lsp.buf.format({ async = true }) end, 'LSP format')
  end,
})

-- Diagnostics
vim.diagnostic.config({
  virtual_text = { prefix = ' ' },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded' },
})
