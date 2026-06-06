#!/bin/bash
# ~/.config/nvim/scripts/mason-install.sh
# Installs all formatters/tools via Mason in a running headless nvim session.
#
# Usage: bash ~/.config/nvim/scripts/mason-install.sh
#
# Requirements: nvim, curl, a running nvim RPC socket

SOCKET="/tmp/nvim-mason.sock"
TOOLS="stylua shfmt ruff black rustfmt goimports clang_format prettier taplo tree-sitter-cli"

cleanup() {
  rm -f "$SOCKET"
}
trap cleanup EXIT

echo "Starting headless nvim with full config..."
nvim --headless --listen "$SOCKET" +qa 2>/dev/null &
NVIM_PID=$!

# Wait for socket
for i in $(seq 1 30); do
  if [ -S "$SOCKET" ]; then
    echo "Socket ready (${i}s)"
    break
  fi
  sleep 1
done

if [ ! -S "$SOCKET" ]; then
  echo "ERROR: nvim socket not created"
  kill $NVIM_PID 2>/dev/null
  exit 1
fi

# Extra time for vim-plug to load all plugins (including Mason)
sleep 8

# Verify Mason is loaded
echo "Checking Mason..."
RESULT=$(nvim --server "$SOCKET" --remote-expr "pcall(require,'mason')" 2>/dev/null)
if [ "$RESULT" = "false" ] || [ -z "$RESULT" ]; then
  echo "WARNING: Mason may not be loaded yet. Giving more time..."
  sleep 10
fi

# Install tools one by one via RPC
for TOOL in $TOOLS; do
  echo "Installing $TOOL..."
  nvim --server "$SOCKET" --remote-expr "lua vim.cmd('MasonInstall $TOOL')" 2>/dev/null
  sleep 3
done

# Give installs time to finish (some are large downloads)
echo "Waiting for installs to complete (60s)..."
sleep 60

echo "Done. Check with :Mason in your Neovim."
kill $NVIM_PID 2>/dev/null
