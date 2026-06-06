# Neovim + tmux Configuration

## Machine Info

- **OS**: Ubuntu 24.04.4 LTS
- **Neovim**: v0.12.2 (at `~/.local/bin/nvim`)
- **Config**: `~/.config/nvim/`
- **tmux Config**: `~/.tmux.conf`

## Directory Structure

```
~/.config/nvim/
├── init.lua              # Entry point, plugin bootstrap
├── lua/
│   ├── plugins.lua      # Plugin config loader
│   ├── config/
│   │   ├── options.lua  # Editor options
│   │   ├── mappings.lua  # Key mappings
│   │   └── autocmd.lua  # Autocommands
│   └── plugins/
│       ├── ui.lua       # Theme, statusline, explorer, finder
│       ├── lsp.lua      # LSP, Mason, completion (nvim-cmp)
│       ├── treesitter.lua
│       └── formatter.lua
└── README.md            # This file
```

## Update Plugins

```bash
nvim --headless +PlugUpdate +q
```

## Add / Remove Plugins

1. Edit `init.lua`, add/remove `Plug(...)` lines
2. Run `:PlugInstall` or `:PlugUpdate`

## Add New LSP

1. Install: `:MasonInstall <lsp-name>`
2. Edit `lua/plugins/lsp.lua` → add entry in `mason_servers` table
3. Restart Neovim

## Language Stack

| Language | LSP | Formatter | Notes |
|----------|-----|-----------|-------|
| Python | pyright | ruff / black | |
| JS/TS | vtsls, tsserver | prettier | |
| JSON/YAML | jsonls, yamlls | prettier | |
| Go | gopls | gofmt | |
| Rust | rust_analyzer | rustfmt, clippy | |
| Shell | bashls | shfmt | |
| Lua | lua_ls | stylua | |

## Key Mappings

### General

| Mapping | Action |
|---------|--------|
| `<Space>w` | Save |
| `<Space>q` | Quit |
| `<Space>Q` | Force quit |
| `<C-h/j/k/l>` | Navigate windows |
| `<C-Arrow>` | Resize windows |
| `[b` / `]b` | Previous / next buffer |
| `<Space>bd` | Delete buffer |

### File & Search

| Mapping | Action |
|---------|--------|
| `<Space>ff` | Find files (Telescope) |
| `<Space>fg` | Live grep (Telescope) |
| `<Space>fb` | Find buffers |
| `<Space>fh` | Help tags |
| `<Space>fr` | Recent files |
| `<Space>fc` | Find word under cursor |

### File Explorer

| Mapping | Action |
|---------|--------|
| `<Space>e` | Toggle NvimTree |
| `<Space>er` | Refresh NvimTree |

### Terminal

| Mapping | Action |
|---------|--------|
| `<C-t>` | Toggle floating terminal |
| `<Space>th` | Horizontal terminal |
| `<Space>tv` | Vertical terminal |

### LSP

| Mapping | Action |
|---------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Show references |
| `K` | Hover docs |
| `<Space>la` | Code action |
| `<Space>lr` | Rename |
| `<Space>lf` | Format buffer |
| `gl` | Diagnostic float |
| `[d` / `]d` | Prev / next diagnostic |

### Treesitter Objects

| Mapping | Action |
|---------|--------|
| `if` / `af` | Inside / around function |
| `ic` / `ac` | Inside / around class |
| `ia` / `aa` | Inside / around parameter |

## tmux Key Mappings

| Mapping | Action |
|---------|--------|
| `C-b` | Prefix |
| `h/j/k/l` | Navigate panes (vim-style) |
| `|` | Split horizontal |
| `-` | Split vertical |
| `c` | New window |
| `r` | Reload config |
| `v` (copy mode) | Start selection |
| `y` (copy mode) | Copy selection |
| `[` | Enter copy mode |
| `E` | Toggle sync panes |
| `x` | Kill pane |
| `d` | Detach session |

## Troubleshooting

### Editor

- **LSP not working**: Run `:LspInfo`, check `:LspLog`
- **Plugins broken**: Run `:PlugClean` then `:PlugInstall`
- **Treesitter broken**: Run `:TSUpdate` to rebuild parsers
- **Slow startup**: Run `nvim --startuptime /tmp/startup.log` and check the log
- **Checkhealth**: Run `:checkhealth` for full diagnostics

### tmux

- **Config reload failed**: Check syntax with `tmux -f ~/.tmux.conf start-server`
- **Mouse not working**: Press `C-b m` to toggle mouse mode
- **Copy mode issues**: Ensure `xsel` is installed for clipboard integration

## Next Steps After This Install

### 1. Install System Tooling

Run this in your terminal (requires sudo password):

```bash
sudo apt update && sudo apt install -y \
  tmux nodejs npm golang-go rustc cargo fd-find fzf \
  shellcheck yamllint jq unzip xsel
```

### 2. Install Neovim Plugins

```bash
nvim --headless +PlugInstall +q
```

### 3. Install Mason LSP Packages

Open nvim and run:

```vim
:MasonInstall pyright vtsls jsonls yamlls gopls rust_analyzer bashls lua_ls html cssls dockerls
:MasonInstall ruff prettier shfmt stylua taplo
```

Or from shell:

```bash
nvim --headless \
  +'MasonInstall pyright vtsls jsonls yamlls gopls rust_analyzer bashls lua_ls html cssls dockerls' \
  +'MasonInstall ruff prettier shfmt stylua taplo' \
  +q
```

### 4. Build Treesitter Parsers

```bash
nvim --headless +TSUpdateSync +q
```

### 5. Verify Everything Works

```bash
# Test nvim loads
nvim --headless +q && echo "Neovim: OK"

# Test tmux config
tmux -f ~/.tmux.conf start-server && echo "tmux: OK"

# Test formatters available
for fmt in shfmt prettier ruff rustfmt gofmt; do
  which $fmt && echo "$fmt: OK" || echo "$fmt: MISSING"
done
```

## Config Philosophy

- **Minimal but complete**: Only essential plugins, no bloat
- **Modular**: Each plugin/feature has its own file
- **Stable**: Pinned plugin versions via vim-plug, avoids Neovim 0.11-only features
- **Synced with tmux**: Same vim-style keybindings across editor and terminal
- **DevOps-ready**: LSP/formatter/linter coverage for Python, JS/TS, Go, Rust, YAML/JSON, Shell
