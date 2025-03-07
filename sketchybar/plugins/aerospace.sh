#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$CONFIG_DIR/ui.sh"
source "$CONFIG_DIR/icon_map.sh"

workspace_cache="$(cat /tmp/aerospace_cache_workspace)"
window_cache=/tmp/aerospace_cache_windows.json
apps=$(jq -r --arg ws "$1" '.[] | select(.workspace == $ws) | ."app-name"' "$window_cache")
icons=""
width="dynamic"

IFS=$'\n'
for app_name in $apps; do
  __icon_map "${app_name}"
  # shellcheck disable=SC2154
  symbol_ligature="${icon_result}"
  icons+="${symbol_ligature} "
done

[[ -z "$icons" ]] && width=24

if [ "$1" = "$workspace_cache" ]; then
  sketchybar --set "$NAME" background.color="$SPACE_BG_COLOR" background.drawing=on label="$icons" width="$width"
else
  sketchybar --set "$NAME" background.drawing=off label="$icons" width="$width"
fi
