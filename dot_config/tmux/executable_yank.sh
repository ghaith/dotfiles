#!/usr/bin/env bash
# Clipboard for tmux copy-pipe.
#
# `tmux load-buffer -w` fills the tmux paste buffer and forwards the text via
# OSC 52 to the terminal of the client attached *right now* — local terminal
# or Windows Terminal over SSH. Env vars (WAYLAND_DISPLAY, DISPLAY) are
# snapshots from server/pane creation and lie after re-attaching from another
# machine, so they must not pick the backend. Requires tmux >= 3.2 and
# set-clipboard on.
#
# Writing OSC 52 to this script's stdout would not work: copy-pipe jobs are
# not attached to the terminal, tmux discards their output.

buf=$(cat)

printf '%s' "$buf" | tmux load-buffer -w -

# Best effort: mirror to the desktop clipboard when a live display exists, so
# the copy is still there when sitting down at the machine later.
if [[ -n "${WAYLAND_DISPLAY:-}" ]] && command -v wl-copy &>/dev/null; then
    printf '%s' "$buf" | wl-copy 2>/dev/null || true
elif [[ -n "${DISPLAY:-}" ]] && command -v xclip &>/dev/null; then
    printf '%s' "$buf" | xclip -selection clipboard 2>/dev/null || true
fi

exit 0
