#!/usr/bin/env bash
# shellcheck disable=SC2155

# Catppuccin Mocha
export ROSEWATER='#f5e0dc'
export FLAMINGO='#f2cdcd'
export PINK='#f5c2e7'
export MAUVE='#cba6f7'
export RED='#f38ba8'
export MAROON='#eba0ac'
export PEACH='#fab387'
export YELLOW='#f9e2af'
export GREEN='#a6e3a1'
export TEAL='#94e2d5'
export SKY='#89dceb'
export SAPPHIRE='#74c7ec'
export BLUE='#89b4fa'
export LAVENDER='#b4befe'
export TEXT='#cdd6f4'
export SUBTEXT1='#bac2de'
export SUBTEXT0='#a6adc8'
export OVERLAY2='#9399b2'
export OVERLAY1='#7f849c'
export OVERLAY0='#6c7086'
export SURFACE2='#585b70'
export SURFACE1='#45475a'
export SURFACE0='#313244'
export BASE='#1e1e2e'
export MANTLE='#181825'
export CRUST='#11111b'
export TRANSPARENT='#11111b'

hex_to_argb() {
  local hex=$1
  local opacity=${2:-"ff"}
  hex=${hex#"#"}
  echo "0x${opacity}${hex}"
}

export BAR_COLOR=$(hex_to_argb $BASE "B3")
export LABEL_COLOR=$(hex_to_argb $TEXT)
export ACCENT_COLOR=$(hex_to_argb $YELLOW)
export SPACE_BG_COLOR=$(hex_to_argb $SURFACE0)
