#!/bin/bash

source /home/ru4f/.config/.env

CITY="Turan"
UNITS="metric"  # hoặc "imperial" cho °F
LANG="vi"
ICON_DIR="/home/ru4f/.config/eww/icons/weather"

data=$(curl -sf "https://api.openweathermap.org/data/2.5/weather?q=$CITY&appid=$API_KEY&units=$UNITS&lang=$LANG")

if [ -n "$data" ]; then
  temp=$(echo "$data" | jq ".main.temp" | cut -d'.' -f1)
  desc=$(echo "$data" | jq -r ".weather[0].description")
  icon=$(echo "$data" | jq -r ".weather[0].icon")

  if (( ${#desc} > 7 )); then
    desc="${desc:0:7}..."
  fi
  # Map icon API → file png
  case $icon in
    01d) emoji="${ICON_DIR}/sun.png" ;;
    01n) emoji="${ICON_DIR}/moon.png" ;;
    02d) emoji="${ICON_DIR}/sun-cloud-1.png" ;;
    02n) emoji="${ICON_DIR}/cloud-cloud.png" ;;
    03d|03n) emoji="${ICON_DIR}/sun-cloud-2.png" ;;
    04d|04n) emoji="${ICON_DIR}/cloud-cloud.png" ;;
    09d|09n) emoji="${ICON_DIR}/rain.png" ;;
    10d|10n) emoji="${ICON_DIR}/sun-cloud-rain.png" ;;
    11d|11n) emoji="${ICON_DIR}/storm.png" ;;
    13d|13n) emoji="${ICON_DIR}/snowy.png" ;;
    50d|50n) emoji="${ICON_DIR}/dark-cloud.png" ;;
    *) emoji="${ICON_DIR}/unknown.png" ;;
  esac

  echo "$emoji|${temp}°C|$desc"
else
  echo "none|N/A|Không có mạng"
fi
