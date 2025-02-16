#!/usr/bin/env bash

count=$(lsappinfo -all info -only StatusLabel "$1" | sed -n 's/.*"label"="\([^"]*\)".*/\1/p')

if [ "$count" = "•" ]; then
  count="1"
fi

drawing="off"
[[ -n "$count" ]] && drawing="on"

sketchybar \
  --set "$NAME" label="$count" drawing="$drawing"
