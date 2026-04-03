#!/usr/bin/env bash
# Dotfiles bootstrap script — installs packages and runs chezmoi init.
# Supports: Arch, Ubuntu/Pop!_OS, Debian, Fedora, Windows (MSYS/Git Bash).
set -eu

NERD_FONTS_VERSION="3.4.0"
GO_VERSION="1.25.1"
NERD_FONTS=(FiraCode Iosevka Hack JetBrainsMono)

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
    go fd fontconfig fnm wl-clipboard xclip jq uv jdk-openjdk-headless

  # fnm is installed via pacman but Node LTS still needs to be set up
  install_node_lts
  install_pi
}

install_ubuntu() {
  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo apt-get update
  sudo apt-get install -y \
    git curl build-essential zsh ripgrep fzf fd-find fontconfig \
    bat git-delta xz-utils unzip wl-clipboard xclip jq default-jdk-headless

  # bat installs as batcat on Ubuntu — symlink to expected name
  symlink_batcat

  install_starship
  install_golang
  install_neovim
  install_eza_apt
  install_atuin
  install_nerd_fonts
  install_fnm
  install_pi
  install_rust
}

install_debian() {
  sudo apt-get update
  sudo apt-get install -y \
    git curl build-essential zsh ripgrep fzf fd-find fontconfig \
    bat xz-utils unzip wl-clipboard xclip jq default-jdk-headless

  # bat installs as batcat on Debian — symlink to expected name
  symlink_batcat

  # git-delta is not in Debian repos — install from GitHub
  install_delta_deb

  install_starship
  install_golang
  install_neovim
  install_eza_apt
  install_atuin
  install_nerd_fonts
  install_fnm
  install_pi
  install_rust
}

install_fedora() {
  sudo dnf install -y \
    git neovim python3-neovim curl zsh bat ripgrep fzf fd-find \
    git-delta zoxide eza atuin fontconfig xz unzip wl-clipboard xclip jq java-21-openjdk-devel

  install_starship
  install_golang
  install_nerd_fonts
  install_fnm
  install_pi
  install_rust
}

install_windows() {
  powershell -NoProfile -ExecutionPolicy Bypass \
    -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
  choco install git neovim starship \
    nerd-fonts-hack nerd-fonts-fira-code nerd-fonts-jetbrains-mono nerd-fonts-iosevka -y
}

# ── Helper installers ────────────────────────────────────────────────

symlink_batcat() {
  # On Ubuntu/Debian, bat installs as batcat. Create a symlink so
  # configs and aliases that expect `bat` work out of the box.
  if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  fi
}

install_starship() {
  command -v starship &>/dev/null && return
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
}

install_golang() {
  command -v go &>/dev/null && return

  local arch
  arch=$(uname -m)
  case "$arch" in
    x86_64)       arch="amd64" ;;
    aarch64|arm64) arch="arm64" ;;
    *) echo "Unsupported architecture for Go: $arch"; return 1 ;;
  esac

  curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${arch}.tar.gz" -o /tmp/go.tar.gz
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz
  rm /tmp/go.tar.gz
  export PATH="$PATH:/usr/local/go/bin"
}

install_neovim() {
  command -v nvim &>/dev/null && return

  local arch
  arch=$(uname -m)
  local nvim_url
  case "$arch" in
    x86_64)        nvim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage" ;;
    aarch64|arm64) nvim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.appimage" ;;
    *) echo "Unsupported architecture for Neovim AppImage: $arch"; return 1 ;;
  esac

  curl -fsSL "$nvim_url" -o /tmp/nvim.appimage
  chmod +x /tmp/nvim.appimage
  cd /tmp && ./nvim.appimage --appimage-extract >/dev/null
  cp -r /tmp/squashfs-root/usr/* "$HOME/.local/"
  rm -rf /tmp/nvim.appimage /tmp/squashfs-root
}

install_eza_apt() {
  command -v eza &>/dev/null && return
  sudo apt-get install -y gpg
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt-get update
  sudo apt-get install -y eza
}

install_delta_deb() {
  command -v delta &>/dev/null && return

  local deb_arch
  case "$(uname -m)" in
    x86_64)        deb_arch="amd64" ;;
    aarch64|arm64) deb_arch="arm64" ;;
    *) echo "Unsupported architecture for git-delta"; return 1 ;;
  esac

  local version
  version=$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest \
    | grep '"tag_name"' | head -1 | sed 's/.*"\(.*\)".*/\1/')
  curl -fsSL "https://github.com/dandavison/delta/releases/download/${version}/git-delta_${version}_${deb_arch}.deb" \
    -o /tmp/git-delta.deb
  sudo dpkg -i /tmp/git-delta.deb
  rm /tmp/git-delta.deb
}

install_fnm() {
  if ! command -v fnm &>/dev/null; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell --install-dir "$HOME/.local/share/fnm"
    export PATH="$HOME/.local/share/fnm:$PATH"
  fi
  install_node_lts
}

install_node_lts() {
  # Install Node LTS and set as default (requires fnm to be on PATH)
  eval "$(fnm env --shell bash --use-on-cd)"
  fnm install --lts
  fnm default lts-latest
}

install_pi() {
  command -v pi &>/dev/null && return
  # Ensure fnm/node is available in this shell
  if command -v fnm &>/dev/null; then
    eval "$(fnm env --shell bash --use-on-cd)"
  fi
  npm install -g @mariozechner/pi-coding-agent
}

install_atuin() {
  command -v atuin &>/dev/null && return
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
}

install_rust() {
  local cargo_bin="$HOME/.cargo/bin"
  export PATH="$cargo_bin:$PATH"

  if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
    export PATH="$cargo_bin:$PATH"
  fi

  if command -v rustup &>/dev/null; then
    rustup toolchain install stable
    rustup default stable
    rustup component add rust-analyzer --toolchain stable
  fi
}

install_uv_from_package_manager() {
  if command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm uv
    return 0
  fi

  if command -v dnf &>/dev/null; then
    sudo dnf install -y uv
    return 0
  fi

  return 1
}

install_uv() {
  local local_bin="$HOME/.local/bin"
  export PATH="$local_bin:$PATH"

  if command -v uv &>/dev/null; then
    return
  fi

  if install_uv_from_package_manager; then
    return
  fi

  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$local_bin:$PATH"
}

install_nerd_fonts() {
  local font_dir="$HOME/.local/share/fonts"
  local installed=false

  for font in "${NERD_FONTS[@]}"; do
    # Check for the Regular variant to decide if already installed
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
      curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERD_FONTS_VERSION}/${font}.tar.xz" \
        -o "/tmp/${font}.tar.xz"
      tar -xf "/tmp/${font}.tar.xz" -C "$font_dir"
      rm "/tmp/${font}.tar.xz"
      installed=true
    fi
  done

  # Rebuild font cache if any fonts were installed
  if [ "$installed" = true ] && command -v fc-cache &>/dev/null; then
    echo "Rebuilding font cache..."
    fc-cache -fv "$font_dir"
  fi
}

# ── Shell & npm config ───────────────────────────────────────────────

configure_shell() {
  [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]] && return

  log "configure_shell: current SHELL=${SHELL:-<unset>}"

  # Already using zsh? Nothing to do.
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

  # Resolve this script's real directory reliably (works with `bash install.sh` too)
  local script_path script_dir chezmoi_source
  script_path="${BASH_SOURCE[0]:-$0}"
  script_dir="$(cd -P -- "$(dirname -- "$script_path")" && pwd -P)"

  # Source selection:
  # 1) explicit --source / $CHEZMOI_SOURCE override
  # 2) local dotfiles dir if this script lives inside it
  # 3) default remote repository (for curl bootstrap)
  if [ -n "$CHEZMOI_SOURCE_OVERRIDE" ]; then
    chezmoi_source="$CHEZMOI_SOURCE_OVERRIDE"
  elif [ -f "$script_dir/.chezmoi.toml.tmpl" ]; then
    chezmoi_source="$script_dir"
  else
    chezmoi_source="$DEFAULT_CHEZMOI_SOURCE"
  fi

  # Prevent the run_once bootstrap script from re-running setup in this same flow.
  export DOTFILES_BOOTSTRAPPED=1

  if [ -d "$chezmoi_source" ]; then
    echo "Running 'chezmoi init --apply --source=$chezmoi_source'"
    exec "$chezmoi" init --apply --source="$chezmoi_source"
  else
    echo "Running 'chezmoi init --apply $chezmoi_source'"
    exec "$chezmoi" init --apply "$chezmoi_source"
  fi
}

# ── Package detection ────────────────────────────────────────────────

install_packages() {
  local packages=(zsh git nvim bat eza starship rg fzf zoxide atuin jq)
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
  elif [[ -f /etc/lsb-release ]]; then
    install_ubuntu
  elif [[ -f /etc/debian_version ]]; then
    install_debian
  elif [[ -f /etc/fedora-release ]]; then
    install_fedora
  elif [[ "$OSTYPE" == "msys" ]]; then
    install_windows
  else
    echo "Unsupported OS"
    exit 1
  fi

  # Clone catppuccin-fuzzel theme if not present
  if [ ! -d "$HOME/catppuccin-fuzzel" ]; then
    git clone https://github.com/catppuccin/fuzzel.git "$HOME/catppuccin-fuzzel"
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
  install_rust
  log "run(): finished install_rust"
  install_uv
  log "run(): finished install_uv"
  configure_shell
  log "run(): finished configure_shell"
  configure_npm
  log "run(): finished configure_npm"
  install_chezmoi
  log "run(): finished install_chezmoi"
}

parse_args "$@"
run
