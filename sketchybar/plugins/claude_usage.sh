#!/usr/bin/env bash

label=$("$HOME/.config/zsh/bin/common/claude-usage" 2>/dev/null) || label="--"
timestamp=$(date +"%H:%M")

sketchybar --set "$NAME" label="$label ($timestamp)"
