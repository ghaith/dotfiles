#!/usr/bin/env bash
# Smart clipboard for tmux copy-pipe.
# - Local Wayland/X11/macOS: uses native clipboard tool → instant, reliable
# - SSH or no native tool: falls back to OSC 52 (works if terminal supports it)
#   Works with: kitty, alacritty, wezterm, foot, iTerm2, etc.
#   Requires: tmux allow-passthrough on + set-clipboard on

buf=$(cat)

# ── Native clipboard (local session) ──────────────────────────────────────────
if [[ -n "${WAYLAND_DISPLAY:-}" ]] && command -v wl-copy &>/dev/null; then
    printf '%s' "$buf" | wl-copy && exit 0
fi
if [[ -n "${DISPLAY:-}" ]] && command -v xclip &>/dev/null; then
    printf '%s' "$buf" | xclip -selection clipboard && exit 0
fi
if [[ -n "${DISPLAY:-}" ]] && command -v xsel &>/dev/null; then
    printf '%s' "$buf" | xsel --clipboard --input && exit 0
fi
if command -v pbcopy &>/dev/null; then
    printf '%s' "$buf" | pbcopy && exit 0
fi

# ── OSC 52 fallback (SSH / no native clipboard) ────────────────────────────── 
# Sends the clipboard data to the outer terminal via escape sequence.
# tmux's set-clipboard also does this automatically, but being explicit here
# ensures it works even without terminal-features being configured.
encoded=$(printf '%s' "$buf" | base64 | tr -d '\n')
# Write through tmux DCS passthrough so the outer terminal receives it
printf '\033Ptmux;\033\033]52;c;%s\a\033\\' "$encoded"
