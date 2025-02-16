#!/usr/bin/env bash

AEROSPACE="$(which aerospace)"
SKETCHYBAR="$(which sketchybar)"

touch /tmp/aerospace_cache_workspace
touch /tmp/aerospace_cache_windows.json

$AEROSPACE list-workspaces --focused >/tmp/aerospace_cache_workspace
$AEROSPACE list-windows --all --json --format "%{window-id} %{window-title} %{app-bundle-id} %{app-bundle-path} %{app-name} %{app-pid} %{workspace} %{monitor-id} %{monitor-name}" >/tmp/aerospace_cache_windows.json

$SKETCHYBAR --trigger aerospace_focus_change
