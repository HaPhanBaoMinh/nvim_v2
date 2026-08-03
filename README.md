# Neovim Slim

A small, practical Neovim configuration for low-spec Linux machines. It targets
Neovim 0.12+ and keeps the core IDE features without a dashboard, animated UI,
tab bar, debugger UI, or duplicate plugins.

## Features

- Fast file search and live grep with fzf-lua
- File explorer with nvim-tree
- Native buffers and splits
- Treesitter highlighting when a C compiler is available
- LSP management with Mason and Neovim's native LSP API
- Lightweight completion with blink.cmp's portable Lua matcher
- Format-on-save with conform.nvim
- Git signs, blame, and diff
- Comments, pairs, surround, and safe buffer deletion via mini.nvim
- Integrated terminal and discoverable keymaps

## Requirements

Required:

```bash
sudo apt install curl git neovim ripgrep
```

Recommended for all features:

```bash
sudo apt install build-essential nodejs npm golang-go
```

Node is needed by the JavaScript/TypeScript, Bash, JSON/YAML, HTML/CSS, Docker,
and Pyright language servers. Go is needed by `gopls` and `goimports`. A C
compiler is needed to build Treesitter parsers. Rust projects should install
`rustfmt` through rustup.

## Install

```bash
git clone -b alf-slim https://github.com/HaPhanBaoMinh/nvim_v2.git ~/.config/nvim
cd ~/.config/nvim
./scripts/install-tools.sh
```

The installer is safe to run again. It installs vim-plug, plugins, portable
tools, available language servers, and Treesitter parsers. Packages whose system
runtime is missing are reported and skipped instead of breaking Neovim.

Run the built-in verification:

```bash
nvim --headless -l ~/.config/nvim/scripts/check.lua
```

Inside Neovim, use `:checkhealth`, `:Mason`, and `:ConformInfo` for details.

## Keymaps

The leader key is `Space`.

| Key | Action |
| --- | --- |
| `<Space>w` | Save |
| `<Space>q` | Quit window |
| `<Space>e` | Toggle file explorer |
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fw` | Find word under cursor |
| `<Space>fr` | Recent files |
| `<Space>bb` | Choose buffer |
| `[b` / `]b` | Previous / next buffer |
| `<Space>bd` | Delete buffer |
| `<C-h/j/k/l>` | Move between splits |
| `<Space>sv` / `<Space>sh` | Vertical / horizontal split |
| `<Space>gs` | Git status |
| `<Space>gb` | Blame current line |
| `<Space>gd` | Diff current file |
| `<Space>xx` | Workspace diagnostics |
| `<C-t>` | Toggle terminal |
| `<Esc><Esc>` | Leave terminal mode |

LSP mappings are enabled only after a server attaches:

| Key | Action |
| --- | --- |
| `gd` / `gD` | Definition / declaration |
| `gr` / `gi` | References / implementations |
| `K` | Hover documentation |
| `<Space>ca` | Code action |
| `<Space>cr` | Rename |
| `<Space>cf` | Format |
| `<Space>cd` | Line diagnostics |
| `[d` / `]d` | Previous / next diagnostic |

Press `Space` and wait briefly to see available groups in WhichKey.

## Languages

The configuration is ready for Lua, Python, JavaScript/TypeScript, Go, Rust,
Shell, C/C++, JSON/YAML, HTML/CSS, Docker, TOML, and Markdown. Mason enables only
servers that are installed, so missing language toolchains do not slow or break
startup.

## Format control

Formatting runs on save when a formatter or LSP formatter is available.

```vim
:FormatDisable      " Disable globally
:FormatDisable!     " Disable for this buffer
:FormatEnable
```

## Update

```vim
:PlugUpdate
:TSUpdate
```

Then run `./scripts/install-tools.sh` and the headless check again.
