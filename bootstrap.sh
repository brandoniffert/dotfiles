#!/bin/bash

set -euo pipefail

CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
REPO_ROOT=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
STEP_MARKER=•

ESeq="\x1b["
RCol="$ESeq"'0m'
Red="$ESeq"'0;31m';
Gre="$ESeq"'0;32m';
Yel="$ESeq"'0;33m';

echo_header() {
  printf "%$(tput cols)s" | tr ' ' '─'
  echo -e "$1"
  printf "%$(tput cols)s" | tr ' ' '─'
  echo
}

echo_success() {
  echo -e "${Gre}$STEP_MARKER $1${RCol}"
}

echo_skip() {
  echo -e "${Yel}$STEP_MARKER $1${RCol}"
}

echo_error() {
  echo -e "${Red}$STEP_MARKER $1${RCol}"
}

echo_error_exit() {
  echo_error "$@"
  echo
  exit 1
}

link_file() {
  local source_file="$1"
  local target_file="$2"

  if ! [ -e "$source_file" ]; then
    echo_error_exit "Source: $source_file does not exist"
  fi

  # If the target file is a symlink or doesn't exist, force a new symlink
  if [ -L "$target_file" ] || ! [ -e "$target_file" ]; then
    if [ "$(readlink "$target_file")" = "$source_file" ]; then
      echo_skip "$target_file already linked"
    else
      ln -snf "$source_file" "$target_file"
      echo_success "$source_file -> $target_file"
    fi
  else
    echo_error "$target_file already exists as a non-symlink"
  fi
}

echo_header "Creating config directory"

if ! [ -d "$CONFIG_HOME" ]; then
  mkdir -p "$CONFIG_HOME"
  echo_success "created $CONFIG_HOME"
else
  echo_skip "$CONFIG_HOME already exists"
fi

echo_header "Symlink files to $CONFIG_HOME"

# Common
CONFIG_DOTS=(
  ctags
  dircolors
  git
  nvim
  ripgrep
  tmux
  zsh
)

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
  CONFIG_DOTS+=(kitty hammerspoon)
fi

for file in "${CONFIG_DOTS[@]}"; do
  source_file="$REPO_ROOT/$file"
  target_file="$CONFIG_HOME/$file"

  link_file "$source_file" "$target_file"
done

echo_header "Symlink files to $HOME"

HOME_DOTS=(
  .zshenv
)

for file in "${HOME_DOTS[@]}"; do
  source_file="$REPO_ROOT/$file"
  target_file="$HOME/$file"

  link_file "$source_file" "$target_file"
done

echo
echo "Done."
echo
