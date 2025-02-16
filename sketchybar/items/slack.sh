#!/usr/bin/env bash

slack=(
  update_freq=30
  updates=on
  click_script="open -a Slack.app"
  script="$PLUGIN_DIR/badge_count.sh Slack"
)

sketchybar \
  --add item slack right \
  --set slack "${slack[@]}" icon=""
