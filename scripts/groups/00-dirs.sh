#!/bin/bash

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

# Description: Creates any needed directories in the $HOME folder

group_dirs() {
  local config_path=$XDG_CONFIG_HOME
  local cache_path=$XDG_CACHE_HOME
  local data_path=$XDG_DATA_HOME
  local ssh_path=$HOME/.ssh

  local xdg_dirs=(
    "$config_path"
    "$cache_path"
    "$data_path"
  )

  group_header "${FUNCNAME[0]//group_/}"

  task_start "Create XDG directories"
  for dir in "${xdg_dirs[@]}"; do
    if ! [ -d "$dir" ]; then
      mkdir -p "$dir"
      task_success "created $dir"
    else
      task_skip "$dir exists"
    fi
  done
  task_end

  task_start "Create $ssh_path"
  if ! [ -d "$ssh_path" ]; then
    mkdir -p "$ssh_path"
    chmod 700 "$ssh_path"
    task_success "created $ssh_path"
  else
    task_skip "$ssh_path exists"
  fi
  task_end
}

group_dirs
