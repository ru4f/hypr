#!/bin/bash

player=$(playerctl -l | head -n 1)

case "$1" in
  play) playerctl -p "$player" play ;;
  pause) playerctl -p "$player" pause ;;
  play-pause) playerctl -p "$player" play-pause ;;
  next) playerctl -p "$player" next ;;
  prev) playerctl -p "$player" previous ;;
  *) echo "Usage: $0 {play|pause|play-pause|next|prev}" ;;
esac


if [[ "$1" == "status" ]]; then
  STATUS=$(playerctl status 2>/dev/null)
  echo "$STATUS"
  exit 0
fi
