#!/usr/bin/env bash

if [ "$MODE" = "service" ]; then
  sketchybar \
    --set "$NAME" \
    drawing=on
else
  sketchybar \
    --set "$NAME" \
    drawing=off
fi
