#!/usr/bin/env bash

mtplx=(
  update_freq=10
  updates=on
  drawing=off
  script="$PLUGIN_DIR/mtplx.sh"
)

sketchybar \
  --add item mtplx right \
  --set mtplx "${mtplx[@]}" icon="󰚩" label="MTPLX"
