#!/bin/bash

ICON_DIR="$HOME/.config/eww/icons/volume"

# check current volume and mute state

volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

# ghi state volume vao /tmp
STATE_FILE="/tmp/eww_last_volume"

# doc last state

if [ -f "$STATE_FILE" ]; then
 last_volume=$(cat "$STATE_FILE")
else
 last_volume=$volume
fi

# luu trang thai vao tmp

echo "$volume" > "$STATE_FILE"

# hien thi icon

if [ "$muted" = true ] || ((volume == 0)); then
 icon="$ICON_DIR/volume-mute.png"
elif ((volume < 30)); then
 icon="$ICON_DIR/volume-low.png"
elif ((volume < 70)); then
 icon="$ICON_DIR/volume-high.png"
else
 icon="$ICON_DIR/volume-high.png"
fi

echo "$icon"
echo "${volume}%"
