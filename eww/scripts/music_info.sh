#!/usr/bin/env bash
# ~/.config/eww/scripts/media_info.sh
set -euo pipefail

CACHE_DIR="$HOME/.cache/media_art"
ICON_DIR="$HOME/.config/eww/icons/music"
DEFAULT_IMG="$ICON_DIR/dvd.png"

mkdir -p "$CACHE_DIR"

PLAYER=$(playerctl -l 2>/dev/null | head -n 1 || true)

if [ -z "$PLAYER" ]; then
  echo "N/A|N/A|$DEFAULT_IMG|none|$DEFAULT_IMG|Stopped"
  exit 0
fi

TITLE=$(playerctl -p "$PLAYER" metadata xesam:title 2>/dev/null || true)
ARTIST=$(playerctl -p "$PLAYER" metadata xesam:artist 2>/dev/null || true)
URL=$(playerctl -p "$PLAYER" metadata xesam:url 2>/dev/null || true)
ART_URL=$(playerctl -p "$PLAYER" metadata mpris:artUrl 2>/dev/null || true)
STATUS=$(playerctl -p "$PLAYER" status 2>/dev/null || echo "Stopped")

SOURCE="none"
SOURCE_ICON="$DEFAULT_IMG"
IMAGE="$DEFAULT_IMG"

# Detect platform (only 3 allowed sources)
if [[ "$URL" == *"youtube.com"* || "$URL" == *"youtu.be"* || "$TITLE" == *"YouTube"* ]]; then
    SOURCE="youtube"
    SOURCE_ICON="$ICON_DIR/youtube.png"
elif [[ "$URL" == *"open.spotify.com"* ]]; then
    SOURCE="spotify"
    SOURCE_ICON="$ICON_DIR/spotify.png"
elif [[ "$URL" == *"soundcloud.com"* ]]; then
    SOURCE="soundcloud"
    SOURCE_ICON="$ICON_DIR/soundcloud.png"
else
    # not one of the 3 → return none
    echo "N/A|N/A|$DEFAULT_IMG|none|$DEFAULT_IMG|Stopped"
    exit 0
fi

# If local file path
if [[ "$ART_URL" == file://* ]]; then
    ART_URL="${ART_URL#file://}"
    if [ -f "$ART_URL" ]; then
        IMAGE="$ART_URL"
fi

# If it's an online image (SoundCloud, Spotify, etc.)
elif [[ -n "$ART_URL" && "$ART_URL" == http* ]]; then
    HASH=$(echo -n "$ART_URL" | sha256sum | awk '{print $1}')
    FILEPATH="$CACHE_DIR/$HASH"
    if [[ "$ART_URL" =~ \.jpe?g$|\.png$ ]]; then
        ext="${ART_URL##*.}"
        FILEPATH="$FILEPATH.$ext"
    else
        FILEPATH="$FILEPATH.png"
    fi
    if [ ! -f "$FILEPATH" ]; then
        curl -sL "$ART_URL" -o "$FILEPATH" || rm -f "$FILEPATH"
    fi
    if [ -f "$FILEPATH" ]; then
        IMAGE="$FILEPATH"
    fi
fi


# Defaults
TITLE=${TITLE:-"Unknown"}
ARTIST=${ARTIST:-"Unknown"}

# Shorten long strings (keep UI tidy)
if (( ${#TITLE} > 28 )); then
  TITLE="${TITLE:0:25}..."
fi
if (( ${#ARTIST} > 22 )); then
  ARTIST="${ARTIST:0:19}..."
fi

# Output: TITLE|ARTIST|IMAGE|SOURCE|SOURCE_ICON|STATUS
echo "${TITLE}|${ARTIST}|${IMAGE}|${SOURCE}|${SOURCE_ICON}|${STATUS}"
