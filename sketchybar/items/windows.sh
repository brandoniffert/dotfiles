#!/usr/bin/env bash

sketchybar --add event hs_window_change

sketchybar \
  --add item windows left \
  --subscribe windows hs_window_change \
  --set windows \
  icon.drawing=off \
  label.drawing=off \
  script="$PLUGIN_DIR/windows.sh"
