#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$CONFIG_DIR/ui.sh"

# sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_focus_change
sketchybar --add event aerospace_mode_change

sketchybar \
  --add item aerospace_mode left \
  --subscribe aerospace_mode aerospace_mode_change \
  --set aerospace_mode \
  updates=on \
  icon="" \
  icon.color="$ACCENT_COLOR" \
  label.drawing=off \
  script="$PLUGIN_DIR/aerospace_mode.sh"

for sid in $(aerospace list-workspaces --all); do
  sketchybar \
    --add item space."$sid" left \
    \
    --subscribe space."$sid" aerospace_focus_change \
    --set space."$sid" \
    background.corner_radius=5 \
    background.height=25 \
    background.padding_left=0 \
    background.padding_right=0 \
    icon="$sid" \
    icon.font="$TEXT_FONT" \
    label.font="$APP_FONT" \
    label.y_offset=-1 \
    label.padding_right="$((PADDINGS * 3))" \
    icon.padding_left="$((PADDINGS * 3))" \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/aerospace.sh $sid" # --subscribe space."$sid" aerospace_workspace_change \
done
