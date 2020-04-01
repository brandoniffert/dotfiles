#!/bin/bash

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

# Description: Installs homebrew packages

group_homebrew() {
  group_header "${FUNCNAME[0]//group_/}"

  task_start "Ensure brew is installed"
  if ! [ -f /usr/local/bin/brew ]; then
    task_info 'running homebrew install script'

    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"; then
      task_success 'installed homebrew'
    else
      task_error_exit 'homebrew could not be installed'
    fi
  else
    task_skip "homebrew is already installed"
  fi
  task_end

  task_start "Install packages"
  local tmp_brewfile=/tmp/_brewfile

  if ! [ -f $tmp_brewfile ] || ! cmp --silent "$REPO_ROOT/Brewfile" $tmp_brewfile; then
    if ! /usr/local/bin/brew bundle --no-lock --file "$REPO_ROOT/Brewfile"; then
      task_error_exit 'brew bundle failed'
    fi

    cp "$REPO_ROOT"/Brewfile $tmp_brewfile

    # https://github.com/pyenv/pyenv/issues/106#issuecomment-440826532
    echo
    env PATH="${PATH//$(pyenv root)\/shims:/}" /usr/local/bin/brew doctor || true
  else
    task_skip "nothing new to brew"
  fi
  task_end

  task_start 'Install fzf shell scripts'
  if ! [ -d "$XDG_CONFIG_HOME/fzf" ]; then
    if /usr/local/opt/fzf/install --xdg --key-bindings --completion --no-update-rc &>/dev/null; then
      task_success
    else
      task_error 'could not install fzf shell scripts'
    fi
  else
    task_skip "fzf shell scripts are already installed"
  fi
  task_end
}

group_homebrew
