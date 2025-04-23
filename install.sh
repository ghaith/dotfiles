#!/bin/bash

# Function to install packages on Arch Linux
install_arch() {
  sudo pacman -Syu --noconfirm git neovim curl bat eza starship zsh helix zellij alacritty python-pynvim nerd-fonts ripgrep fzf zoxide atuin
}

# Function to install packages on Ubuntu/Pop!_OS
function install_ubuntu() {

  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository ppa:neovim-ppa/stable
  sudo apt-get update 
  sudo apt-get install neovim
  sudo apt-get install -y git curl build-essential bat zsh ripgrep fzf

  # Install helix
  sudo add-apt-repository ppa:maveonair/helix-editor
  sudo apt update
  sudo apt install helix
  
  # Install starship
  curl -sS https://starship.rs/install.sh | sh
 
  install_eza_apt
  install_atuin
  install_nerd_fonts
  install_node
}

function install_debian() {
  sudo apt-get update
  sudo apt-get install -y git curl build-essential bat zsh ripgrep fzf

  # Install starship
  curl -sS https://starship.rs/install.sh | sh

  install_eza_apt
  install_neovim
  install_nerd_fonts
  install_node
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

# Function to install packages on Fedora
install_fedora() {
  sudo dnf install -y git neovim python3-neovim curl alacritty zsh bat eza helix zoxide ripgrep fzf
  install_atuin
  install_nerd_fonts
}

# Function to install packages on Windows using winget
install_windows() {
  # Install Chocolatey
  powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

  choco install git neovim starship nerd-fonts-hack nerd-fonts-fira-code nerd-fonts-jetbrains-mono nerd-fonts-iosevka -y

}

# Main function to run the installation and configuration
function run() {
  install
  configure_shell
}


# Function to check and install necessary packages
function install() {
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

  # Ask the user for confirmation and exit if they decline
  read -p "Do you want to install the packages? (Y/n): " confirm
  if [[ "$confirm" =~ ^[Nn]$ ]]; then
    echo "Installation aborted."
    exit 1
  fi

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

}

# Function to configure the shell to use zsh
function configure_shell() {
if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "cygwin" ]]; then
  if [[ "$SHELL" != *"zsh" ]]; then
    chsh -s $(which zsh)
  fi
fi
}

function install_nerd_fonts() {
   # Path to check if the font is installed
   font_path="$HOME/.local/share/fonts/NerdFonts"

  # Check if the font is already installed
  if [ -d "$font_path" ]; then
    echo "Nerd fonts are already installed."
    return
  fi

  # Install nerd-fonts manually
  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
  cd nerd-fonts
  ./install.sh
  cd ..
  rm -rf nerd-fonts
}

function install_atuin() {
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
}

# Start the installation process
run
