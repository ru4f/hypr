#!/bin/bash

case "$1" in
  shutdown) systemctl poweroff ;;
  restart) systemctl reboot ;;
  lock) hyprlock ;;
  sleep) systemctl suspend ;;
  logout) hyprctl dispatch exit ;;
esac
