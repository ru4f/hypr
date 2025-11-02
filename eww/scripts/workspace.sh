#!/usr/bin/env bash

active=$(hyprctl -j monitors | jq '.[] | select(.focused==true).activeWorkspace.id')
ICON_DIR="/home/ru4f/.config/eww/icons/workspace"

workspaces=()
for i in {1..5}; do
  if [ "$i" -eq "$active" ]; then
    workspaces+=("{\"id\": $i, \"active\": true, \"img\": \"$ICON_DIR/workspace-$i.png\"}")
  else
    workspaces+=("{\"id\": $i, \"active\": false, \"img\": \"$ICON_DIR/workspace-$i.png\"}")
  fi
done

printf "[%s]\n" "$(IFS=,; echo "${workspaces[*]}")"
