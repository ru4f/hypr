#!/bin/bash

API_KEY="f3810c3273b9a32d602646871a659e45"
CITY="Turan"
UNITS="metric"  # hoặc "imperial" cho °F
LANG="vi"

# Lấy dữ liệu JSON từ OpenWeatherMap
data=$(curl -sf "https://api.openweathermap.org/data/2.5/weather?q=$CITY&appid=$API_KEY&units=$UNITS&lang=$LANG")

if [ -n "$data" ]; then
  temp=$(echo "$data" | jq ".main.temp" | cut -d'.' -f1)
  desc=$(echo "$data" | jq -r ".weather[0].description")
  icon=$(echo "$data" | jq -r ".weather[0].icon")

  # Chuyển icon sang emoji đơn giản
  case $icon in
    01d) emoji="☀️" ;; 01n) emoji="🌙" ;;
    02d) emoji="🌤️" ;; 02n) emoji="☁️" ;;
    03d|03n) emoji="🌥️" ;;
    04d|04n) emoji="☁️" ;;
    09d|09n) emoji="🌧️" ;;
    10d|10n) emoji="🌦️" ;;
    11d|11n) emoji="⛈️" ;;
    13d|13n) emoji="❄️" ;;
    50d|50n) emoji="🌫️" ;;
    *) emoji="❔" ;;
  esac

  echo "$emoji  $temp°C  $desc"
else
  echo "󰖙  Không có mạng"
fi
