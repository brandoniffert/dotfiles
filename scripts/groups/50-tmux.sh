#!/bin/bash

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

# Description: Installs tmux plugin manager and plugins

group_tmux() {
  local tmux_plugins_dir="$XDG_DATA_HOME/tmux/plugins"
  local tpm_repo="https://github.com/tmux-plugins/tpm.git"

  mkdir -p "$tmux_plugins_dir"

  group_header "${FUNCNAME[0]//group_/}"

  task_start 'Install tmux plugin manager and plugins'
  if ! [ -d "$tmux_plugins_dir/tpm" ]; then
    if git clone -q "$tpm_repo" "$tmux_plugins_dir/tpm"; then
      tmux start-server
      tmux new-session -d
      "$tmux_plugins_dir"/tpm/scripts/install_plugins.sh &>/dev/null
      tmux kill-server
      task_success 'installed tpm and plugins'
    else
      task_error 'could not clone tpm repo'
    fi
  else
    task_skip 'tpm is already installed'
  fi
  task_end
}

group_tmux
