#!/usr/bin/env bash
set -eu

config_dir=$(cd "$(dirname "$0")/.." && pwd)
plug_path=$(nvim --headless -u NONE +'lua io.write(vim.fn.stdpath("data"))' +qa)/site/autoload/plug.vim

if [ ! -f "$plug_path" ]; then
  mkdir -p "$(dirname "$plug_path")"
  curl -fLo "$plug_path" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

nvim --headless --cmd "set runtimepath^=$config_dir" -u "$config_dir/init.lua" \
  '+PlugInstall --sync' +qa

nvim --headless --cmd "set runtimepath^=$config_dir" -u "$config_dir/init.lua" \
  -l "$config_dir/scripts/install-tools.lua"

echo 'Neovim plugins, language tools, and parsers are ready.'
