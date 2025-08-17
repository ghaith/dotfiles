#!/bin/bash

# Default wallpaper directory (change this to your wallpaper folder)
WALLPAPER_DIR="${1:-$HOME/Pictures/wallpapers}"

# Check if directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Directory '$WALLPAPER_DIR' does not exist" >&2
    exit 1
fi

# Find all image files recursively
# Supports common image formats: jpg, jpeg, png, gif, bmp, tiff, webp
mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( \
    -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.gif" -o \
    -iname "*.bmp" -o \
    -iname "*.tiff" -o \
    -iname "*.tif" -o \
    -iname "*.webp" \
\) 2>/dev/null)

# Check if any wallpapers were found
if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "Error: No image files found in '$WALLPAPER_DIR'" >&2
    exit 1
fi

# Get random wallpaper
random_index=$((RANDOM % ${#wallpapers[@]}))
selected_wallpaper="${wallpapers[$random_index]}"

# Output the full path
echo "$selected_wallpaper"
