#!/bin/bash

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

# Description: Generates and installs a karabiner.json config

group_karabiner() {
  local karabiner_dir=$XDG_CONFIG_HOME/karabiner

  mkdir -p "$karabiner_dir"

  group_header "${FUNCNAME[0]//group_/}"

  if ! [ -f /usr/local/bin/node ]; then
    task_error_exit 'node is not installed'
  fi

  task_start 'Generate and install karabiner config'
  # Generate the config into a temp file
  local tmp_conf=/tmp/_karabiner.json
  "$REPO_ROOT/scripts/support/karabiner.js" > $tmp_conf

  # Check if the config file doesn't exist or if it doesn't match the newly generated one
  if ! [ -f "$karabiner_dir/karabiner.json" ] || ! cmp --silent "$karabiner_dir/karabiner.json" "$tmp_conf"; then
    mv $tmp_conf "$karabiner_dir/karabiner.json"
    task_success 'generated and installed karabiner config'
  else
    rm $tmp_conf
    task_skip 'karabiner config already exists'
  fi
  task_end
}

group_karabiner
