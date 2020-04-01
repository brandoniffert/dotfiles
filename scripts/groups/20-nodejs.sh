#!/bin/bash

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

# Description: Installs the latest LTS node and installs global packages

group_nodejs() {
  local nvm_dir=$XDG_CONFIG_HOME/nvm

  group_header "${FUNCNAME[0]//group_/}"

  if ! [ -f /usr/local/bin/yarn ]; then
    task_error_exit 'yarn is not installed'
  fi

  task_start "Install the latest LTS node"
  if ! [ -d "$nvm_dir/versions/node" ]; then
    mkdir -p "$nvm_dir"
    (
      # Assumes that nvm was installed with homebrew, sources nvm.sh at the location homebrew installs it
      NVM_DIR=$nvm_dir
      source /usr/local/opt/nvm/nvm.sh
      nvm install --lts
      nvm alias default lts/*
    )

    if [ -d "$nvm_dir/versions/node" ]; then
      task_success 'installed node'
    else
      task_error 'could not install node'
    fi
  else
    task_skip "node is already installed"
  fi
  task_end

  local yarn_pkgs=(
    diff-so-fancy
    neovim
    eslint
  )

  task_start "Install global yarn packages"
  if [ -f /usr/local/bin/yarn ]; then
    for pkg in "${yarn_pkgs[@]}"; do
      if ! yarn global list | grep -q "^info \"$pkg@"; then
        if yarn global add --prod --no-progress --silent "$pkg"; then
          task_success "installed $pkg"
        else
          task_error "could not install $pkg"
        fi
      else
        task_skip "$pkg is already installed"
      fi
    done
  else
    task_error 'yarn is not installed'
  fi
  task_end
}

group_nodejs
