-- ~/.config/nvim/lua/plugins/formatter.lua
-- Formatter / linter configuration using conform.nvim (from reference repo)

local ok_conform, conform = pcall(require, 'conform')
if not ok_conform then return end

conform.setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff_format', 'black', stop_after_first = true },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    json = { 'prettierd', 'prettier', stop_after_first = true },
    jsonc = { 'prettierd', 'prettier', stop_after_first = true },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    go = { 'goimports', 'gofmt', stop_after_first = true },
    rust = { 'rustfmt' },
    c = { 'clang_format' },
    cpp = { 'clang_format' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    html = { 'prettier' },
    css = { 'prettier' },
    toml = { 'taplo' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
})
