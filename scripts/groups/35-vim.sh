#!/bin/bash

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

# Description: Handles the initial setup of vim/neovim and installs plugins

group_vim() {
  local vim_plug_url="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  local vim_plug_path="$REPO_ROOT/dotfiles/nvim/autoload/plug.vim"

  group_header "${FUNCNAME[0]//group_/}"

  if ! command -v nvim &>/dev/null; then
    task_error_exit 'neovim is not installed'
  fi

  task_start "Install vim-plug plugins"
  if ! [ -f "$vim_plug_path" ]; then
    wget --hsts-file="${XDG_CACHE_HOME-$HOME/.cache}/wget-hsts" -q -O "$vim_plug_path" "$vim_plug_url"
    command nvim --headless +UpdateRemotePlugins +'PlugInstall --sync' +qa &>/dev/null
    task_success 'setup vim-plug and plugins'
  else
    task_skip 'vim-plug already setup'
  fi
  task_end
}

group_vim
