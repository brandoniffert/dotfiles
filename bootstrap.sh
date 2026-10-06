#!/bin/bash

set -euo pipefail

quiet=false
while getopts "q" opt; do
  case $opt in
  q) quiet=true ;;
  *) exit 1 ;;
  esac
done

config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
step_marker=•

ESeq="\x1b["
RCol="$ESeq"'0m'
Red="$ESeq"'0;31m'
Gre="$ESeq"'0;32m'
Yel="$ESeq"'0;33m'

echo_header() {
  [ "$quiet" = true ] && return
  local cols
  cols=$(tput cols)
  local line
  line=$(printf '%*s' "$cols" '' | sed 's/ /─/g')
  echo "$line"
  echo -e "$1"
  echo "$line"
}

echo_success() {
  [ "$quiet" = true ] && return
  echo -e "${Gre}$step_marker $1${RCol}"
}

echo_skip() {
  [ "$quiet" = true ] && return
  echo -e "${Yel}$step_marker $1${RCol}"
}

echo_error() {
  [ "$quiet" = true ] && return
  echo -e "${Red}$step_marker $1${RCol}"
}

echo_error_exit() {
  [ "$quiet" = true ] || echo -e "${Red}$step_marker $1${RCol}\n"
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

if ! [ -d "$config_home" ]; then
  mkdir -p "$config_home"
  echo_success "created $config_home"
else
  echo_skip "$config_home already exists"
fi

echo_header "Symlink files to $config_home"

# Common
config_dots=(
  bat
  btop
  dircolors
  just
  git
  herdr
  hunk
  lazygit
  mise
  nvim
  ripgrep
  tmux
  yazi
  zsh
)

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
  config_dots+=(
    aerospace
    k9s
    kitty
    ghostty
    hammerspoon
    nvim-ephemeral
    sketchybar
    wezterm
  )
fi

for file in "${config_dots[@]}"; do
  source_file="$repo_root/$file"
  target_file="$config_home/$file"

  link_file "$source_file" "$target_file"
done

echo_header "Symlink files to $HOME"

home_dots=(
  .zshenv
)

for file in "${home_dots[@]}"; do
  source_file="$repo_root/$file"
  target_file="$HOME/$file"

  link_file "$source_file" "$target_file"
done

echo_header "Herdr plugins"

if ! command -v herdr >/dev/null 2>&1; then
  echo_skip "herdr not installed"
elif [[ "$(herdr plugin list --json)" == *'"plugin_id":"smart-splits.nvim"'* ]]; then
  echo_skip "smart-splits.nvim already installed"
else
  herdr plugin install -y mrjones2014/smart-splits.nvim >/dev/null 2>&1 || echo_error_exit "failed to install smart-splits.nvim"
  echo_success "installed smart-splits.nvim"
fi

if ! command -v herdr >/dev/null 2>&1; then
  echo_skip "herdr not installed"
else
  herdr_plugins="$(herdr plugin list --json)"
  for plugin in last-tab clean-copy last-workspace popups; do
    if [[ "$herdr_plugins" == *"\"plugin_id\":\"$plugin\""* ]]; then
      echo_skip "$plugin already linked"
    else
      herdr plugin link "$repo_root/herdr/plugins/$plugin" >/dev/null 2>&1 || echo_error_exit "failed to link $plugin"
      echo_success "linked $plugin"
    fi
  done
fi

[ "$quiet" = true ] || echo -e "\nDone.\n"
