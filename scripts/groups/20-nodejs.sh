#!/bin/bash

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

# Description: Installs the latest LTS node and installs global packages

group_nodejs() {
  group_header "${FUNCNAME[0]//group_/}"

  local n_dir=$XDG_DATA_HOME/n

  if ! command -v n &>/dev/null; then
    task_error_exit 'n is not installed'
  fi

  if ! command -v yarn &>/dev/null; then
    task_error_exit 'yarn is not installed'
  fi

  task_start "Install the latest LTS node"
  if ! [ -d "$n_dir/n/versions" ]; then
    PREFIX=$n_dir command n lts

    if [ -d "$n_dir/n/versions" ]; then
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
  task_end
}

group_nodejs
