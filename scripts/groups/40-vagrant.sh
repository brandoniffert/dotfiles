#!/bin/bash

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

# Description: Installs vagrant plugins

group_vagrant() {
  local vagrant_plugins=(
    vagrant-bindfs
    vagrant-hostmanager
    vagrant-vbguest
  )

  group_header "${FUNCNAME[0]//group_/}"

  if ! [ -f /usr/local/bin/vagrant ]; then
    task_error_exit 'vagrant is not installed'
  fi

  local installed_plugins
  installed_plugins=$(/usr/local/bin/vagrant plugin list | cut -d ' ' -f 1 | grep -v ^$)

  task_start 'Install plugins'
  for plugin in "${vagrant_plugins[@]}"; do
    if ! grep -q "$installed_plugins" <<< "$plugin"; then
      if /usr/local/bin/vagrant plugin install "$plugin"; then
        task_success "installed $plugin"
      else
        task_error "could not install $plugin"
      fi
    else
      task_skip "$plugin is already installed"
    fi
  done
  task_end
}

group_vagrant
