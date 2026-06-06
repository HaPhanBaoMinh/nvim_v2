#!/bin/bash
# ~/.config/nvim/scripts/install-tools.sh
# Installs all formatters and tools via Mason.

SOCKET="/tmp/nvim-mason.sock"
TOOLS="stylua shfmt ruff black rustfmt goimports clang_format prettier taplo tree-sitter-cli"

# Kill any old socket
rm -f "$SOCKET"

echo "Starting headless nvim RPC server..."
nvim --headless --listen "$SOCKET" +qa 2>/dev/null &
NVIM_PID=$!

# Wait for socket
for i in $(seq 1 20); do
  if [ -S "$SOCKET" ]; then
    echo "Socket ready after ${i}s"
    break
  fi
  sleep 1
done

if [ ! -S "$SOCKET" ]; then
  echo "ERROR: nvim socket not found after 20s"
  kill $NVIM_PID 2>/dev/null
  exit 1
fi

# Give plugins extra time to load
sleep 5

echo "Installing tools via Mason..."
for TOOL in $TOOLS; do
  echo "  Installing $TOOL..."
  timeout 120 nvim --server "$SOCKET" --remote-expr "lua vim.cmd('MasonInstall $TOOL')" 2>/dev/null
  sleep 2
done

# Wait for all installs
sleep 10

echo "Done. Restart nvim and run :Mason to verify."
kill $NVIM_PID 2>/dev/null
