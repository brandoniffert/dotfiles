#!/usr/bin/env bash

local_time=$(date '+%H:%M %a %b %d')
utc_time=$(date -u '+%H:%M %a')

sketchybar --set "$NAME" label="[$utc_time] $local_time"
