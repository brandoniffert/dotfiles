#!/bin/bash

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

# Description: Installs a default ruby using rbenv

group_ruby() {
  local RUBY_VERSION=2.6.5
  local rbenv_dir=$XDG_DATA_HOME/rbenv
  local default_gems=(
    bundler
    neovim
  )

  mkdir -p "$rbenv_dir"

  group_header "${FUNCNAME[0]//group_/}"

  if ! command -v rbenv &>/dev/null; then
    task_error_exit 'rbenv is not installed'
  fi

  task_start 'Setup default gems'
  if ! [ -f "$rbenv_dir/default-gems" ]; then
    printf "%s\n" "${default_gems[@]}" > "$rbenv_dir/default-gems"
    task_success 'created default-gems file'
  else
    task_skip 'default-gems are already setup'
  fi
  task_end

  task_start "Install ruby $RUBY_VERSION with rbenv"
  if ! [ -d "$rbenv_dir/versions/$RUBY_VERSION" ]; then
    RBENV_ROOT=$rbenv_dir command rbenv install --skip-existing $RUBY_VERSION
    task_success "installed ruby $RUBY_VERSION"
  else
    task_skip "ruby $RUBY_VERSION is already installed"
  fi
  task_end

  task_start "Set global ruby version to $RUBY_VERSION"
  if ! RBENV_ROOT=$rbenv_dir command rbenv version | cut -d ' ' -f 1 | grep -Fxq $RUBY_VERSION; then
    RBENV_ROOT=$rbenv_dir command rbenv global $RUBY_VERSION
    RBENV_ROOT=$rbenv_dir command rbenv rehash
    task_success "set ruby $RUBY_VERSION as the global version"
  else
    task_skip "ruby $RUBY_VERSION is already the global version"
  fi
  task_end
}

group_ruby
