#!/usr/bin/env bash

mail=(
  update_freq=30
  updates=on
  click_script="open -a Mail.app"
  script="$PLUGIN_DIR/badge_count.sh Mail"
)

sketchybar \
  --add item mail right \
  --set mail "${mail[@]}" icon=""
