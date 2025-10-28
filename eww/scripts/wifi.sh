#!/bin/bash

ICON_DIR="$HOME/.config/eww/icons/network"

# kiểm tra wifi có bật không
wifi_status=$(nmcli -t -f WIFI g)
if [ "$wifi_status" != "enabled" ]; then
    echo "$ICON_DIR/no-wifi.png"
    echo "Disabled"
    exit 0
fi

# kkiểm tra ethernet đang kết nối
if nmcli device status | grep -qE '^eth.*connected'; then
    echo "$ICON_DIR/ethernet.png"
    echo "Ethernet"
    exit 0
fi

# kiểm tra wifi đang kết nối
ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)

if [ -z "$ssid" ]; then
    echo "$ICON_DIR/no-wifi.png"
    echo "Disconnected"
    exit 0
fi

# kiểm tra security
security=$(nmcli -t -f 802-11-wireless-security.key-mgmt connection show "$ssid" 2>/dev/null)

if [ -z "$security" ]; then
    echo "$ICON_DIR/free-wifi.png"
else
    echo "$ICON_DIR/wifi.png"
fi

# xuất SSID (dòng thứ 2)
echo "$ssid"
