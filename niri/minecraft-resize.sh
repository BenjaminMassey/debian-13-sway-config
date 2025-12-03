#!/bin/bash
FLOAT_RAW=$(niri msg focused-window | grep "Is floating")
if [[ $FLOAT_RAW =~ (yes|no) ]]; then
  FLOATING=${BASH_REMATCH[1]}
  if [ "$FLOATING" = "no" ]; then
    NIRI_DISPLAY=$(niri msg outputs | grep current)
    DISPLAY_WIDTH=$(echo "$NIRI_DISPLAY" | awk -F'[x@]' '{print $1}' | grep -o '[0-9]*' | tail -1)
    DISPLAY_HEIGHT=$(echo "$NIRI_DISPLAY" | awk -F'[x@]' '{print $2}')

    TARGET_WIDTH=300
    TARGET_HEIGHT=12000
    TARGET_X=$((($DISPLAY_WIDTH / 2) - $TARGET_WIDTH))
    TARGET_Y=$((($DISPLAY_HEIGHT - $TARGET_HEIGHT) / 2))

    niri msg action move-window-to-floating
    niri msg action move-floating-window --x $TARGET_X --y $TARGET_Y
    niri msg action set-window-width $TARGET_WIDTH
    niri msg action set-window-height $TARGET_HEIGHT
  else
    # needs a bit of a reset
    niri msg action set-window-width 5
    niri msg action set-window-height 5
    niri msg action move-floating-window --x 0 --y 0

    niri msg action move-window-to-tiling
    niri msg action expand-column-to-available-width
  fi
fi
