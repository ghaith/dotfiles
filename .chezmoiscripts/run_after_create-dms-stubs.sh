#!/bin/bash
# Create empty DMS niri config stubs if they don't exist.
# DMS overwrites these on first run, but niri needs them to start.
mkdir -p "$HOME/.config/niri/dms"
for f in colors.kdl layout.kdl alttab.kdl binds.kdl; do
    [ -f "$HOME/.config/niri/dms/$f" ] || touch "$HOME/.config/niri/dms/$f"
done
