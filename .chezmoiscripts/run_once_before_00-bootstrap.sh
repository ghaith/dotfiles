#!/bin/bash
set -eu

log() {
  printf '[chezmoi bootstrap] %s\n' "$*"
}

log "starting .chezmoiscripts/run_once_before_00-bootstrap.sh"
log "DOTFILES_BOOTSTRAPPED=${DOTFILES_BOOTSTRAPPED:-<unset>}"
HOSTNAME_VALUE="$(hostname 2>/dev/null || echo unknown-host)"
log "SHELL=${SHELL:-<unset>} USER=$(whoami) HOST=${HOSTNAME_VALUE}"

# If bootstrap was started via install.sh already, skip to avoid recursion.
if [ -n "${DOTFILES_BOOTSTRAPPED:-}" ]; then
  log "DOTFILES_BOOTSTRAPPED is set; skipping bootstrap"
  exit 0
fi

INSTALL_SCRIPT="$HOME/.local/share/chezmoi/install.sh"
log "looking for install script at $INSTALL_SCRIPT"
if [ -x "$INSTALL_SCRIPT" ]; then
  log "running install.sh directly (executable)"
  "$INSTALL_SCRIPT" --from-chezmoi || {
    status=$?
    log "install.sh exited with status $status"
    exit $status
  }
elif [ -f "$INSTALL_SCRIPT" ]; then
  log "install.sh not executable; invoking via bash"
  bash "$INSTALL_SCRIPT" --from-chezmoi || {
    status=$?
    log "install.sh (bash) exited with status $status"
    exit $status
  }
else
  log "bootstrap script not found at $INSTALL_SCRIPT; skipping package bootstrap"
fi

log "bootstrap script completed"
