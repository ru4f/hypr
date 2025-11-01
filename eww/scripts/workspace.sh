#!/bin/bash

active=$(hyprctl activeworkspace -j | jq -r '.id')
workspaces=$(hyprctl workspaces -j | jq -r '.[].id' | sort -n | paste -sd "," -)

echo "$active|$workspaces"
