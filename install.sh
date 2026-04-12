#!/usr/bin/env bash
# Dotfiles bootstrap script — installs packages and runs chezmoi init.
# Supports: Arch, Fedora (native packages), Ubuntu/Debian/others (via nix).
set -eu

DEFAULT_CHEZMOI_SOURCE="https://github.com/ghaith/dotfiles.git"
CHEZMOI_SOURCE_OVERRIDE="${CHEZMOI_SOURCE:-}"
SKIP_CHEZMOI_INIT=0

log() {
  printf '[install.sh] %s\n' "$*"
}

HOSTNAME_VALUE="$(hostname 2>/dev/null || echo unknown-host)"
log "starting install.sh (SHELL=${SHELL:-<unset>} USER=$(whoami) HOST=${HOSTNAME_VALUE})"

# ── Distro installers ────────────────────────────────────────────────

install_arch() {
  sudo pacman -Syu --noconfirm \
    chezmoi git neovim curl bat eza starship zsh helix zellij alacritty \
    python-pynvim nerd-fonts ripgrep fzf zoxide atuin git-delta fuzzel \
    go fd fontconfig fnm wl-clipboard xclip jq uv jdk-openjdk-headless \
    direnv

  # fnm is installed via pacman but Node LTS still needs to be set up
  setup_node_lts
  setup_rust
  install_pi
}

install_fedora() {
  sudo dnf install -y \
    git neovim python3-neovim curl zsh bat ripgrep fzf fd-find \
    git-delta zoxide eza atuin fontconfig xz unzip wl-clipboard xclip jq java-21-openjdk-devel \
    direnv go

  setup_nerd_fonts
  setup_fnm
  setup_rust
  install_pi
}

install_with_nix() {
  log "installing packages via nix"

  # 1. Install nix if not present (Determinate Systems installer)
  if ! command -v nix &>/dev/null; then
    log "installing nix (Determinate Systems installer)"
    # Containers and other non-systemd environments need `install linux --init none`
    local nix_install_args=(install)
    if ! pidof systemd &>/dev/null && ! [ -d /run/systemd/system ]; then
      log "systemd not detected, using --init none"
      nix_install_args+=(linux --init none)
    fi
    nix_install_args+=(--no-confirm)

    curl --proto '=https' --tlsv1.2 -sSf -L \
      https://install.determinate.systems/nix | sh -s -- "${nix_install_args[@]}"

    # Source nix profile so it's available in this shell
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
  fi

  # In environments without systemd the nix daemon won't be running.
  # Start it in the background so nix commands work.
  if ! pidof systemd &>/dev/null && ! [ -d /run/systemd/system ]; then
    if [ ! -S /nix/var/nix/daemon-socket/socket ]; then
      log "starting nix-daemon manually (no systemd)"
      sudo /nix/var/nix/profiles/default/bin/nix-daemon &
      NIX_DAEMON_PID=$!
      # Wait for the socket to appear
      for _ in $(seq 1 30); do
        [ -S /nix/var/nix/daemon-socket/socket ] && break
        sleep 0.2
      done
    fi
  fi

  # 2. Install CLI tools bundle from the dotfiles flake
  log "installing cli-tools bundle via nix profile"
  local flake_ref
  flake_ref="$(resolve_flake_ref)"
  nix profile install "${flake_ref}#cli-tools" --accept-flake-config

  # Stop the temporary daemon if we started one
  if [ -n "${NIX_DAEMON_PID:-}" ]; then
    sudo kill "$NIX_DAEMON_PID" 2>/dev/null || true
  fi

  # 3. Add nix-provided zsh to /etc/shells so chsh works
  local nix_zsh
  nix_zsh="$(command -v zsh 2>/dev/null || true)"
  if [ -n "$nix_zsh" ] && ! grep -qxF "$nix_zsh" /etc/shells 2>/dev/null; then
    log "adding $nix_zsh to /etc/shells"
    echo "$nix_zsh" | sudo tee -a /etc/shells >/dev/null
  fi

  # 4. Imperative post-install steps
  setup_node_lts
  setup_rust
}

# ── Post-install helpers ─────────────────────────────────────────────
# These run imperative setup for tools that manage their own state
# outside of nix (fnm → Node versions, rustup → toolchains).

setup_fnm() {
  if ! command -v fnm &>/dev/null; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell --install-dir "$HOME/.local/share/fnm"
    export PATH="$HOME/.local/share/fnm:$PATH"
  fi
  setup_node_lts
}

setup_node_lts() {
  if ! command -v fnm &>/dev/null; then
    log "fnm not found, skipping Node LTS setup"
    return
  fi
  eval "$(fnm env --shell bash --use-on-cd)"
  fnm install --lts
  fnm default lts-latest
}

setup_rust() {
  local cargo_bin="$HOME/.cargo/bin"
  export PATH="$cargo_bin:$PATH"

  if command -v rustup &>/dev/null; then
    rustup toolchain install stable
    rustup default stable
    rustup component add rust-analyzer --toolchain stable
  fi
}

install_pi() {
  command -v pi &>/dev/null && return
  if command -v fnm &>/dev/null; then
    eval "$(fnm env --shell bash --use-on-cd)"
  fi
  npm install -g @mariozechner/pi-coding-agent
}

setup_nerd_fonts() {
  local font_dir="$HOME/.local/share/fonts"
  local nerd_fonts=(FiraCode Iosevka Hack JetBrainsMono)
  local nerd_fonts_version="3.4.0"
  local installed=false

  for font in "${nerd_fonts[@]}"; do
    local check_name
    case "$font" in
      FiraCode)       check_name="FiraCodeNerdFont-Regular.ttf" ;;
      Iosevka)        check_name="IosevkaNerdFont-Regular.ttf" ;;
      Hack)           check_name="HackNerdFont-Regular.ttf" ;;
      JetBrainsMono)  check_name="JetBrainsMonoNerdFont-Regular.ttf" ;;
      *)              check_name="${font}NerdFont-Regular.ttf" ;;
    esac

    if [ ! -f "${font_dir}/${check_name}" ]; then
      mkdir -p "$font_dir"
      echo "Installing Nerd Font: $font"
      curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/v${nerd_fonts_version}/${font}.tar.xz" \
        -o "/tmp/${font}.tar.xz"
      tar -xf "/tmp/${font}.tar.xz" -C "$font_dir"
      rm "/tmp/${font}.tar.xz"
      installed=true
    fi
  done

  if [ "$installed" = true ] && command -v fc-cache &>/dev/null; then
    echo "Rebuilding font cache..."
    fc-cache -fv "$font_dir"
  fi
}

# ── Shell & npm config ───────────────────────────────────────────────

configure_shell() {
  [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]] && return

  log "configure_shell: current SHELL=${SHELL:-<unset>}"

  if [[ "${SHELL:-}" == *"zsh" ]]; then
    log "configure_shell: already using zsh; skipping"
    return
  fi

  local desired_shell
  desired_shell="$(command -v zsh 2>/dev/null || true)"
  if [ -z "$desired_shell" ]; then
    log "configure_shell: zsh not found on PATH; skipping"
    return
  fi

  local have_tty=0
  if [ -t 0 ] && [ -t 1 ]; then
    have_tty=1
  fi
  log "configure_shell: have_tty=$have_tty"

  if command -v sudo >/dev/null 2>&1; then
    if [ "$have_tty" -eq 1 ]; then
      if sudo chsh -s "$desired_shell" "$(whoami)"; then
        log "configure_shell: changed shell via sudo chsh"
      else
        log "configure_shell: failed to change shell via sudo (interactive); skipping"
      fi
    elif sudo -n true 2>/dev/null; then
      if sudo chsh -s "$desired_shell" "$(whoami)"; then
        log "configure_shell: changed shell via sudo (non-interactive)"
      else
        log "configure_shell: failed to change shell via sudo (non-interactive); skipping"
      fi
    else
      log "configure_shell: skipping shell change (sudo requires interactive password)"
    fi
  else
    if [ "$have_tty" -eq 1 ]; then
      if chsh -s "$desired_shell" "$(whoami)"; then
        log "configure_shell: changed shell via chsh"
      else
        log "configure_shell: failed to change shell via chsh; skipping"
      fi
    else
      log "configure_shell: skipping shell change (no sudo and not running in a TTY)"
    fi
  fi
}

configure_npm() {
  log "configure_npm: start"
  if ! command -v npm >/dev/null 2>&1; then
    log "configure_npm: npm not found; skipping"
    return 0
  fi

  mkdir -p "$HOME/.local/npm/bin"
  log "configure_npm: setting npm prefix to $HOME/.local/npm"
  if npm config set prefix "$HOME/.local/npm"; then
    log "configure_npm: npm prefix configured"
  else
    local status=$?
    log "configure_npm: npm config set failed with status $status"
    return $status
  fi
}

# ── Chezmoi bootstrap ────────────────────────────────────────────────

install_chezmoi() {
  [ "$SKIP_CHEZMOI_INIT" -eq 1 ] && return

  local chezmoi
  if ! chezmoi="$(command -v chezmoi)"; then
    local bin_dir="$HOME/.local/bin"
    chezmoi="$bin_dir/chezmoi"
    mkdir -p "$bin_dir"
    echo "Installing chezmoi to '$chezmoi'"
    curl -fsSL https://chezmoi.io/get | sh -s -- -b "$bin_dir"
  fi

  local script_path script_dir chezmoi_source
  script_path="${BASH_SOURCE[0]:-$0}"
  script_dir="$(cd -P -- "$(dirname -- "$script_path")" && pwd -P)"

  if [ -n "$CHEZMOI_SOURCE_OVERRIDE" ]; then
    chezmoi_source="$CHEZMOI_SOURCE_OVERRIDE"
  elif [ -f "$script_dir/.chezmoi.toml.tmpl" ]; then
    chezmoi_source="$script_dir"
  else
    chezmoi_source="$DEFAULT_CHEZMOI_SOURCE"
  fi

  export DOTFILES_BOOTSTRAPPED=1

  if [ -d "$chezmoi_source" ]; then
    echo "Running 'chezmoi init --apply --source=$chezmoi_source'"
    exec "$chezmoi" init --apply --source="$chezmoi_source"
  else
    echo "Running 'chezmoi init --apply $chezmoi_source'"
    exec "$chezmoi" init --apply "$chezmoi_source"
  fi
}

# ── Helpers ──────────────────────────────────────────────────────────

resolve_flake_ref() {
  # If install.sh lives inside the dotfiles repo, use the local nixos/ dir.
  # Otherwise, fetch from GitHub.
  local script_path script_dir
  script_path="${BASH_SOURCE[0]:-$0}"
  script_dir="$(cd -P -- "$(dirname -- "$script_path")" && pwd -P)"

  if [ -d "$script_dir/nixos" ] && [ -f "$script_dir/nixos/flake.nix" ]; then
    echo "path:${script_dir}/nixos"
  else
    echo "github:ghaith/dotfiles?dir=nixos"
  fi
}

# ── Package detection ────────────────────────────────────────────────

install_packages() {
  local packages=(zsh git nvim bat eza starship rg fzf zoxide atuin jq direnv)
  local all_installed=true

  for pkg in "${packages[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
      echo "$pkg is not installed."
      all_installed=false
      break
    fi
  done

  if [ "$all_installed" = true ]; then
    echo "All packages are already installed."
    return
  fi

  echo "Installing missing packages..."

  if [[ -f /etc/arch-release ]]; then
    install_arch
  elif [[ -f /etc/fedora-release ]]; then
    install_fedora
  else
    # Ubuntu, Debian, and anything else — use nix
    install_with_nix
  fi

  # Clone catppuccin-fuzzel theme if not present
  if [ ! -d "$HOME/catppuccin-fuzzel" ]; then
    git clone https://github.com/catppuccin/fuzzel.git "$HOME/catppuccin-fuzzel" 2>/dev/null || true
  fi
}

# ── Main ─────────────────────────────────────────────────────────────

parse_args() {
  log "parse_args called with: $*"
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --from-chezmoi|--skip-chezmoi-init)
        SKIP_CHEZMOI_INIT=1
        log "flag set: SKIP_CHEZMOI_INIT=1"
        ;;
      --source=*)
        CHEZMOI_SOURCE_OVERRIDE="${1#*=}"
        log "flag set: CHEZMOI_SOURCE_OVERRIDE=$CHEZMOI_SOURCE_OVERRIDE"
        ;;
      --source)
        shift
        CHEZMOI_SOURCE_OVERRIDE="${1:-}"
        log "flag set: CHEZMOI_SOURCE_OVERRIDE=$CHEZMOI_SOURCE_OVERRIDE"
        ;;
      --help|-h)
        cat <<'EOF'
Usage: install.sh [options]
  --from-chezmoi        Run bootstrap tasks without calling `chezmoi init`
  --source <path|repo>  Override chezmoi source (local path or remote repo URL)
EOF
        exit 0
        ;;
      *)
        echo "Unknown option: $1" >&2
        exit 1
        ;;
    esac
    shift
  done
}

run() {
  log "run(): starting bootstrap sequence"

  # NixOS manages packages declaratively — skip all package/tool installs
  if [ -f /etc/NIXOS ]; then
    log "NixOS detected — skipping package bootstrap, running chezmoi only"
    install_chezmoi
    return
  fi

  install_packages
  log "run(): finished install_packages"
  configure_shell
  log "run(): finished configure_shell"
  configure_npm
  log "run(): finished configure_npm"
  install_chezmoi
  log "run(): finished install_chezmoi"
}

parse_args "$@"
run
