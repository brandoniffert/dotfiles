#!/usr/bin/env bash

sketchybar --add event muxedo_attention

muxedo=(
  drawing=off
  updates=on
  icon="󰂚"
  icon.color="$(hex_to_argb "$RED")"
  label=MUXEDO
  label.color="$(hex_to_argb "$RED")"
  script="$PLUGIN_DIR/muxedo.sh"
  click_script="open -b com.brandoniffert.muxedo"
)

sketchybar \
  --add item muxedo center \
  --set muxedo "${muxedo[@]}" \
  --subscribe muxedo muxedo_attention
