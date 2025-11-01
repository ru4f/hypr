#!/usr/bin/env bash

# Lấy thiết bị backlight đầu tiên
BACKLIGHT_DIR="/sys/class/backlight"
DEVICE=$(ls $BACKLIGHT_DIR | head -n 1)
CURRENT=$(cat "$BACKLIGHT_DIR/$DEVICE/brightness")
MAX=$(cat "$BACKLIGHT_DIR/$DEVICE/max_brightness")
ICON_DIR="/home/ru4f/.config/eww/icons/brightness"

if (((100 * CURRENT / MAX) < 50)); then
 icon="$ICON_DIR/moon.png"
else
 icon="$ICON_DIR/sun.png"
fi

case "$1" in
  up)
    NEW=$((CURRENT + MAX/10))
    ;;
  down)
    NEW=$((CURRENT - MAX/10))
    ;;
  get)
    echo "$((100 * CURRENT / MAX))%"
    echo $icon
    exit 0
    ;;
  *)
    echo "Usage: $0 {up|down|get}"
    exit 1
    ;;
esac

# Giới hạn 0–MAX
if [ $NEW -lt 1 ]; then NEW=1; fi
if [ $NEW -gt $MAX ]; then NEW=$MAX; fi

echo $NEW | sudo tee "$BACKLIGHT_DIR/$DEVICE/brightness" >/dev/null
