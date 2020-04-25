#!/bin/bash

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

link_file() {
  local source_file="$1"
  local target_file="$2"

  # If the target file is a symlink or doesn't exist, force a new symlink
  if [ -L "$target_file" ] || ! [ -e "$target_file" ]; then
    if [ "$(readlink "$target_file")" = "$source_file" ]; then
      task_skip "$target_file already linked"
    else
      ln -snf "$source_file" "$target_file"
      task_success "$source_file -> $target_file"
    fi
  else
    task_error "$target_file already exists"
  fi
}

# Description: Symlinks dotfiles from this repo to the $HOME folder

group_dotfiles() {
  # Will be symlinked into $XDG_CONFIG_HOME
  local config_dots=(
    alacritty
    ctags
    dircolors
    kitty
    git
    hammerspoon
    ripgrep
    tmux
    zsh
  )

  # Will be symlinked into $HOME
  local home_dots=(
    .vim
    .zshenv
  )

  group_header "${FUNCNAME[0]//group_/}"

  task_start "Symlink files to $XDG_CONFIG_HOME"
  for file in "${config_dots[@]}"; do
    source_file="$REPO_ROOT/dotfiles/$file"
    target_file="$XDG_CONFIG_HOME/$file"

    link_file "$source_file" "$target_file"
  done
  task_end

  task_start "Symlink files to $HOME"
  for file in "${home_dots[@]}"; do
    source_file="$REPO_ROOT/dotfiles/$file"
    target_file="$HOME/$file"

    link_file "$source_file" "$target_file"
  done
  task_end

  task_start "Symlink nvim to vim"
  source_file="$HOME/.vim"
  target_file="$XDG_CONFIG_HOME/nvim"

  link_file "$source_file" "$target_file"
  task_end
}

group_dotfiles
