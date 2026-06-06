#!/usr/bin/env python3
"""Install Mason tools by connecting to headless nvim via RPC socket."""
import subprocess
import os
import sys
import time

SOCKET = '/tmp/nvim-mason.sock'
NVIM = '/home/bauminh/.local/bin/nvim'

# Find nvim
r = subprocess.run(['which', 'nvim'], capture_output=True, text=True)
if r.stdout.strip():
    NVIM = r.stdout.strip()

TOOLS = [
    'stylua', 'shfmt', 'ruff', 'black', 'rustfmt',
    'goimports', 'clang_format', 'prettier', 'taplo',
    'tree-sitter-cli',
]

def run():
    # Remove stale socket
    if os.path.exists(SOCKET):
        os.unlink(SOCKET)

    print("Starting headless nvim (stays alive)...")
    proc = subprocess.Popen(
        [NVIM, '--headless', '--listen', SOCKET],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    try:
        # Wait for socket
        for i in range(30):
            if os.path.exists(SOCKET):
                break
            time.sleep(1)
        else:
            print("ERROR: socket not created")
            return

        print(f"Socket ready: {SOCKET}")

        # Extra time for plugins
        time.sleep(8)

        # Try to connect via Python neovim module
        try:
            import neovim
        except ImportError:
            sys.path.insert(0, '/usr/lib/python3/dist-packages')
            import neovim

        print("Connecting via Python RPC...")
        nvim = neovim.attach('socket', path=SOCKET)

        # Check if Mason is available
        try:
            nvim.command('lua require("mason")')
            print("Mason OK")
        except Exception as e:
            print(f"Mason check failed: {e}")

        # Send install commands one by one
        for tool in TOOLS:
            print(f"Installing {tool}...")
            try:
                nvim.command(f'MasonInstall {tool}')
                print(f"  ✓ queued {tool}")
            except Exception as e:
                print(f"  ✗ {tool}: {e}")

        # Keep connection alive for installs
        print("Keeping connection alive for installs (120s)...")
        time.sleep(120)

        nvim.quit()

    finally:
        proc.terminate()
        proc.wait(timeout=5)
        if os.path.exists(SOCKET):
            os.unlink(SOCKET)

    print("Done. Restart nvim and run :Mason to verify.")

if __name__ == '__main__':
    run()
