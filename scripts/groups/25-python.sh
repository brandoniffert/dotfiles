#!/bin/bash

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

# Description: Installs a default python using pyenv

group_python() {
  local PYTHON2_VERSION=2.7.17
  local PYTHON3_VERSION=3.8.2
  local pyenv_dir=$XDG_DATA_HOME/pyenv

  mkdir -p "$pyenv_dir"

  group_header "${FUNCNAME[0]//group_/}"

  if ! command -v pyenv &>/dev/null; then
    task_error_exit 'pyenv is not installed'
  fi

  task_start "Install python $PYTHON2_VERSION with pyenv"
  if ! [ -d "$pyenv_dir/versions/$PYTHON2_VERSION" ]; then
    PYENV_ROOT=$pyenv_dir command pyenv install $PYTHON2_VERSION
    task_success "installed python $PYTHON2_VERSION"
  else
    task_skip "python $PYTHON2_VERSION is already installed"
  fi
  task_end

  task_start "Install python $PYTHON3_VERSION with pyenv"
  if ! [ -d "$pyenv_dir/versions/$PYTHON3_VERSION" ]; then
    PYENV_ROOT=$pyenv_dir command pyenv install $PYTHON3_VERSION
    task_success "installed python $PYTHON3_VERSION"
  else
    task_skip "python $PYTHON3_VERSION is already installed"
  fi
  task_end

  task_start "Set global python version to $PYTHON3_VERSION"
  if ! PYENV_ROOT=$pyenv_dir command pyenv version | cut -d ' ' -f 1 | grep -Fxq $PYTHON3_VERSION; then
    PYENV_ROOT=$pyenv_dir command pyenv global $PYTHON3_VERSION
    PYENV_ROOT=$pyenv_dir command pyenv rehash
    task_success "set python $PYTHON3_VERSION as the global version"
  else
    task_skip "python $PYTHON3_VERSION is already the global version"
  fi
  task_end

  task_start 'Setup virtualenv for neovim and install pynvim (python3)'
  if ! [ -d "$pyenv_dir/versions/py3nvim" ]; then
    PYENV_ROOT=$pyenv_dir command pyenv virtualenv $PYTHON3_VERSION py3nvim
    "$pyenv_dir/versions/py3nvim/bin/pip" install pynvim
    task_success 'setup py3nvim virtualenv'
  else
    task_skip 'py3nvim virtualenv is already setup'
  fi
  task_end
}

group_python
