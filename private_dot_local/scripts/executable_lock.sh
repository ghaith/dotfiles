#!/bin/bash
# File: ~/.local/scripts/lock.sh

WALLPAPER_SCRIPT="$HOME/.local/scripts/random_wallpaper.sh"

# Get random wallpaper
WALLPAPER=$("$WALLPAPER_SCRIPT")

if [ $? -eq 0 ] && [ -n "$WALLPAPER" ]; then
    exec swaylock -f \
        -i "$WALLPAPER" \
        --scaling fill \
        --text-color ffffff \
        --ring-color 808080 \
        --inside-color 00000088 \
        --line-color 404040 \
        --separator-color 00000000 \
        --key-hl-color ffffff \
        --bs-hl-color ff0000 \
        "$@"
else
    # Fallback without wallpaper if script fails
    exec swaylock -f \
        --color 000000 \
        --text-color ffffff \
        --ring-color 808080 \
        --inside-color 404040 \
        "$@"
fi
