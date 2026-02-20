#!/usr/bin/env bash

if label=$("$HOME/.config/zsh/bin/host/iffy/claude-usage" 2>/dev/null); then
  timestamp=$(date +"%H:%M")
  sketchybar \
    --set "$NAME" label="$label" \
    --set claude_usage_timestamp label="($timestamp)" drawing=on
else
  sketchybar \
    --set "$NAME" label="--" \
    --set claude_usage_timestamp drawing=off
fi
