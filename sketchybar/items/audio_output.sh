#!/usr/bin/env bash

audio_output=(
  update_freq=5
  script="$PLUGIN_DIR/audio_output.sh"
)

sketchybar \
  --add item audio_output right \
  --set audio_output "${audio_output[@]}" icon=""
