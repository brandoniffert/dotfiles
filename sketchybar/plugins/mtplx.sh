#!/usr/bin/env bash

drawing="off"
curl -fsS --max-time 1 http://127.0.0.1:8686/v1/models >/dev/null 2>&1 && drawing="on"

sketchybar --set "$NAME" drawing="$drawing"
