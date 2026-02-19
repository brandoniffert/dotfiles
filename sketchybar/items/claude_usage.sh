#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$CONFIG_DIR/ui.sh"
source "$CONFIG_DIR/icon_map.sh"

claude_usage=(
  update_freq=300
  script="$PLUGIN_DIR/claude_usage.sh"
)

sketchybar \
  --add item claude_usage right \
  --set claude_usage "${claude_usage[@]}" icon.font="$APP_FONT" icon=":claude:"
