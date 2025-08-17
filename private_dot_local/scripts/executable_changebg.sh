#!/bin/bash
# Path to your random wallpaper script
WALLPAPER_SCRIPT="$HOME/.local/scripts/random_wallpaper.sh"

# Kill existing swaybg processes
pkill swaybg

# Get random wallpaper
WALLPAPER=$("$WALLPAPER_SCRIPT")

if [ $? -eq 0 ] && [ -n "$WALLPAPER" ]; then
    # Start swaybg with new wallpaper
    swaybg -i "$WALLPAPER" -m fill 
    
    # Optional: log the change
    echo "$(date): Changed wallpaper to $WALLPAPER" >> "$HOME/.local/share/wallpaper-changes.log"
else
    echo "$(date): Failed to get random wallpaper" >> "$HOME/.local/share/wallpaper-changes.log"
fi
