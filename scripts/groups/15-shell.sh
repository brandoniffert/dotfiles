#!/bin/bash

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

# Description: Sets the default user shell to zsh

group_shell() {
  local target_shell=/usr/local/bin/zsh
  local current_shell
  current_shell=$(dscl . -read /Users/"$USER" UserShell)

  group_header "${FUNCNAME[0]//group_/}"

  task_start "Set $target_shell as default shell"
  if ! [ -f $target_shell ]; then
    task_error_exit "$target_shell could not be found"
  fi

  if ! grep -q "$target_shell" <<< "$current_shell"; then
    sudo dscl . -create /Users/"$USER" UserShell $target_shell
    task_success "set $target_shell as the default shell"
  else
    task_skip "$target_shell is already the default shell"
  fi
  task_end

  task_start "Setup terminfo"
    local terminfo_dir=~/.terminfo

    if ! [ -d "$terminfo_dir" ]; then
      mkdir -p "$terminfo_dir"
      tic -o "$terminfo_dir" "$REPO_ROOT/scripts/support/tmux-256color.terminfo"
      task_success "setup terminfo"
    else
      task_skip "terminfo is already setup"
    fi
  task_end
}

group_shell
