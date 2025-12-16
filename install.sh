#!/bin/bash

# Exit immediately if a command exits with a non-zero status, and treat unset variables as an error
set -eu

# Function to install packages on Arch Linux
install_arch() {
  sudo pacman -Syu --noconfirm chezmoi git neovim curl bat eza starship zsh helix zellij alacritty python-pynvim nerd-fonts ripgrep fzf zoxide atuin git-delta fuzzel golang
  install_rust
}

# Function to install packages on Ubuntu/Pop!_OS
function install_ubuntu() {

  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo apt-get update 
  sudo apt-get install -y git curl build-essential bat zsh ripgrep fzf git-delta

  # Install starship
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
 
  install_golang
  install_neovim
  install_eza_apt
  install_atuin
  install_nerd_fonts
  install_node
  install_rust
}

function install_debian() {
  sudo apt-get update
  sudo apt-get install -y git curl build-essential bat zsh ripgrep fzf

  # Install starship
  curl -sS https://starship.rs/install.sh | sh -s -- --yes

  install_golang
  install_eza_apt
  install_neovim
  install_nerd_fonts
  install_node
  install_rust
}

function install_golang() {
  if command -v go &> /dev/null; then
    echo "Go is already installed."
    return
  fi

  GO_VERSION="1.25.1"
  ARCH=$(uname -m)

  if [ "$ARCH" = "x86_64" ]; then
    ARCH="amd64"
  elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    ARCH="arm64"
  else
    echo "Unsupported architecture: $ARCH"
    exit 1
  fi

  wget https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz -O /tmp/go${GO_VERSION}.linux-${ARCH}.tar.gz
  sudo tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-${ARCH}.tar.gz
  rm /tmp/go${GO_VERSION}.linux-${ARCH}.tar.gz

  # Add Go to PATH for the current session
  export PATH=$PATH:/usr/local/go/bin

  echo "Go ${GO_VERSION} installed successfully."
}

function install_chezmoi() {

  if ! chezmoi="$(command -v chezmoi)"; then
    bin_dir="${HOME}/.local/bin"
    chezmoi="${bin_dir}/chezmoi"
    echo "Installing chezmoi to '${chezmoi}'" >&2
    if command -v curl >/dev/null; then
      chezmoi_install_script="$(curl -fsSL https://chezmoi.io/get)"
    elif command -v wget >/dev/null; then
      chezmoi_install_script="$(wget -qO- https://chezmoi.io/get)"
    else
      echo "To install chezmoi, you must have curl or wget installed." >&2
      exit 1
    fi
    sh -c "${chezmoi_install_script}" -- -b "${bin_dir}"
    unset chezmoi_install_script bin_dir
  fi

  # POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
  script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

  set -- init --apply --source="${script_dir}"

  echo "Running 'chezmoi $*'" >&2
  # exec: replace current process with chezmoi
  exec "$chezmoi" "$@"
}

function install_node() {
  # Check if Node.js is already installed
  if command -v node &> /dev/null; then
    echo "Node.js is already installed."
    return
  fi

  # Install Node.js from node source  repo
  sudo apt-get install -y curl
  curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
  sudo -E bash nodesource_setup.sh
  sudo apt-get install -y nodejs
}

function install_neovim() {
  # Check if Neovim is already installed
  if command -v nvim &> /dev/null; then
    echo "Neovim is already installed."
    return
  fi
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage \
  && chmod +x nvim-linux-x86_64.appimage && ./nvim-linux-x86_64.appimage --appimage-extract && cp -r squashfs-root/usr ~/.local/ \
  && rm -rf nvim-linux-x86_64.appimage squashfs-root
}

function install_eza_apt() {
  # Check if eza is already installed
  if command -v eza &> /dev/null; then
    echo "eza is already installed."
    return
  fi
  sudo apt-get update
  sudo apt-get install -y gpg
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update
  sudo apt install -y eza
}

install_eza() {
  curl -L https://github.com/eza-community/eza/releases/download/v0.23.4/eza_x86_64-unknown-linux-gnu.tar.gz --output /tmp/eza.tar.gz \
  && tar xvzf /tmp/eza.tar.gz --directory $HOME/.local/bin/
}

# Function to install packages on Fedora
install_fedora() {
  sudo dnf install -y git neovim python3-neovim curl alacritty zsh bat zoxide ripgrep fzf
  install_atuin
  install_nerd_fonts
  install_eza
  # Install starship
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
}

# Function to install packages on Windows using winget
install_windows() {
  # Install Chocolatey
  powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

  choco install git neovim starship nerd-fonts-hack nerd-fonts-fira-code nerd-fonts-jetbrains-mono nerd-fonts-iosevka -y

}

# Main function to run the installation and configuration
function run() {
  install_packages
  configure_shell
  configure_npm
  install_chezmoi
}

function configure_npm() {
  mkdir -p $HOME/.local/npm/bin
  npm config set prefix $HOME/.local/npm
}


# Function to check and install necessary packages
function install_packages() {
  # List of packages to check
  packages=("zsh" "git" "nvim" "bat" "eza" "starship" "helix" "rg" "fzf" "zoxide" "atuin")

  # Check each package
  all_installed=true
  for package in "${packages[@]}"; do
    if ! command -v "$package" &> /dev/null; then
      echo "$package is not installed."
      all_installed=false
      break
    fi
  done

  # Exit early if all packages are installed
  if [ "$all_installed" = true ]; then
    echo "All packages are already installed."
    return
  fi

  echo "Installing missing packages..."

  # Detect OS and call the appropriate function
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

  # Checkout additional repositories
  # Clone the fuzzel repository into catppuccin-fuzzel directory in home directory
  if [ -d "$HOME/catppuccin-fuzzel"]; then 
    echo "Catppuccin already installed"
  else 
    git clone https://github.com/catppuccin/fuzzel.git "$HOME/catppuccin-fuzzel"
  fi
}

# Function to configure the shell to use zsh
function configure_shell() {
if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "cygwin" ]]; then
  if [[ "$SHELL" != *"zsh" ]]; then
    sudo chsh -s $(which zsh) $USER # Using sudo to insure it works within containers where the password is not set
  fi
fi
}

function install_nerd_fonts() {
   # Path to check if the font is installed
   font_path="$HOME/.local/share/fonts"

   # Download FiraCode, Iosevka, Hack Nerd, JetBrains Mono if they do no exist
   # FiraCode
    if [ ! -f "${font_path}/FiraCodeNerdFont-Regular.ttf" ]; then
      mkdir -p "${font_path}"
      wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.tar.xz -O /tmp/FiraCode.tar.xz
      tar -xf /tmp/FiraCode.tar.xz -C "${font_path}"
      rm /tmp/FiraCode.tar.xz
    fi
    if [ ! -f "${font_path}/IosevkaNerdFont-Regular.ttf" ]; then
      mkdir -p "${font_path}"
      wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.tar.xz -O /tmp/Iosevka.tar.xz
      tar -xf /tmp/Iosevka.tar.xz -C "${font_path}"
      rm /tmp/Iosevka.tar.xz
    fi
    if [ ! -f "${font_path}/HackNerdFont-Regular.ttf" ]; then
      mkdir -p "${font_path}"
      wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.tar.xz -O /tmp/Hack.tar.xz
      tar -xf /tmp/Hack.tar.xz -C "${font_path}"
      rm /tmp/Hack.tar.xz
    fi
    if [ ! -f "${font_path}/JetBrainsMonoNerdFont-Regular.ttf" ]; then
      mkdir -p "${font_path}"
      wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.tar.xz -O /tmp/JetBrainsMono.tar.xz
      tar -xf /tmp/JetBrainsMono.tar.xz -C "${font_path}"
      rm /tmp/JetBrainsMono.tar.xz
    fi

}

function install_atuin() {
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
}

function install_rust() {
  if command -v rustc &> /dev/null; then
    echo "Rust is already installed."
    return
  fi

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

  # Add Rust to PATH for the current session
  export PATH="$HOME/.cargo/bin:$PATH"

  echo "Rust installed successfully."
}

# Start the installation process
run

