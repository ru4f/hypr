#!/bin/bash

ICON_DIR="$HOME/.config/eww/icons/battery"

# get % battery
capacity=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null)

# get battery status
status=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null)

# if not get battery data
if [ -z "$capacity" ] && [ -z "$status" ]; then
 echo "$ICON_DIR/battery-n-a.png"
 echo "N/A"
 exit 0
fi

# determine icon with status
if [[ "$status" == "Charging" ]]; then
 icon="$ICON_DIR/battery-charger.png"
elif [ "$capacity" -ge 80 ]; then
 icon="$ICON_DIR/battery-full.png"
elif [ "$capacity" -ge 50 ]; then
 icon="$ICON_DIR/battery-half.png"
else
 icon="$ICON_DIR/battery-low.png"
fi

echo "$icon"
echo "${capacity}%"
echo "$status"
