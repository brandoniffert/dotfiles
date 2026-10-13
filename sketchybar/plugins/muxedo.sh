#!/usr/bin/env bash

drawing=off
[[ "$ATTENTION" == "1" ]] && drawing=on

sketchybar --set "$NAME" drawing="$drawing"
