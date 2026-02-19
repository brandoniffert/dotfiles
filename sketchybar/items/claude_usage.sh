#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$CONFIG_DIR/ui.sh"
source "$CONFIG_DIR/icon_map.sh"

claude_usage=(
  update_freq=300
  label.padding_right=0
  script="$PLUGIN_DIR/claude_usage.sh"
)

claude_usage_timestamp=(
  label.color="$(hex_to_argb $OVERLAY0)"
  label.padding_left=$((PADDINGS * -2))
  drawing=off
)

sketchybar \
  --add item claude_usage_timestamp right \
  --set claude_usage_timestamp "${claude_usage_timestamp[@]}" \
  --add item claude_usage right \
  --set claude_usage "${claude_usage[@]}" icon.font="$APP_FONT" icon=":claude:"
