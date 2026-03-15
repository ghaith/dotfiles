#!/bin/bash
# Clone catppuccin/tmux plugin if not already present.
CATPPUCCIN_DIR="$HOME/.config/tmux/plugins/catppuccin"
CATPPUCCIN_TAG="v2.1.3"

if [ ! -d "$CATPPUCCIN_DIR" ]; then
    echo "Installing catppuccin/tmux plugin (${CATPPUCCIN_TAG})..."
    git clone --depth 1 --branch "$CATPPUCCIN_TAG" \
        https://github.com/catppuccin/tmux.git "$CATPPUCCIN_DIR"
fi
