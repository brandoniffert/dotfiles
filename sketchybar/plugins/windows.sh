#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$CONFIG_DIR/ui.sh"
source "$CONFIG_DIR/icon_map.sh"
window_counts="/tmp/hs-window-counts"

cmd="sketchybar"
cmd+=" --remove '/app_windows\.*/' "

if [ -f "$window_counts" ]; then
  while IFS= read -r line; do
    count=$(echo "$line" | awk '{print $1}')
    bundleID=$(echo "$line" | awk '{print $2}')
    name=$(echo "$line" | cut -d' ' -f3-)

    __icon_map "${name}"
    # shellcheck disable=SC2154
    symbol_ligature="${icon_result}"
    icon="${symbol_ligature} "

    cmd+=" --add item app_windows.\"$bundleID\" left "
    cmd+=" --set app_windows.\"$bundleID\" "
    cmd+=" icon=\"$icon\" "
    cmd+=" icon.font=\"$APP_FONT\" "
    cmd+=" icon.y_offset=-1 "
    cmd+=" label=\"$count\" "
    cmd+=" label.font=\"$TEXT_FONT\" "
    cmd+=" label.padding_right=\"$((PADDINGS * 2))\" "
    cmd+=" icon.padding_left=\"$((PADDINGS * 2))\" "
  done <"$window_counts"
else
  cmd+=" --add item app_windows.empty left "
  cmd+=" --set app_windows.empty "
  cmd+=" icon=\"\" "
  cmd+=" icon.padding_left=\"$((PADDINGS * 2))\" "
  cmd+=" icon.y_offset=1 "
  cmd+=" label.drawing=off "
fi

cmd+=" --add bracket app_windows '/app_windows\.*/' "

eval "$cmd"
