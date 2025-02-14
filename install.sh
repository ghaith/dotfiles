#!/bin/bash

# Function to install packages on Arch Linux
install_arch() {
  sudo pacman -Syu --noconfirm git neovim curl bat eza starship zsh helix zellij alacritty python-pynvim nerd-fonts ripgrep fzf zoxide atuin
}

# Function to install packages on Ubuntu/Pop!_OS
install_ubuntu() {

  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository ppa:neovim-ppa/stable
  sudo apt-get update 
  sudo apt-get install neovim
  sudo apt-get install python-dev python-pip python3-dev python3-pip
  sudo apt-get install -y git curl build-essential eza bat zsh

  # Install helix
  sudo add-apt-repository ppa:maveonair/helix-editor
  sudo apt update
  sudo apt install helix
 
  # Install atuin
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  
  # Install nerd-fonts manually
  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
  cd nerd-fonts
  ./install.sh
  cd ..
  rm -rf nerd-fonts
}

# Function to install packages on Fedora
install_fedora() {
  sudo dnf install -y git neovim python3-neovim curl alacritty zsh bat eza helix zoxide
  # Install atuin
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  # Install nerd-fonts manually
  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
  cd nerd-fonts
  ./install.sh
  cd ..
  rm -rf nerd-fonts
}

# Function to install packages on Windows using winget
install_windows() {
  # Install Chocolatey
  powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

  choco install git neovim starship nerd-fonts-hack nerd-fonts-fira-code nerd-fonts-jetbrains-mono nerd-fonts-iosevka -y

}

# Detect OS and call the appropriate function
if [[ -f /etc/arch-release ]]; then
  install_arch
elif [[ -f /etc/lsb-release ]]; then
  install_ubuntu
elif [[ -f /etc/fedora-release ]]; then
  install_fedora
elif [[ "$OSTYPE" == "msys" ]]; then
  install_windows
else
  echo "Unsupported OS"
  exit 1
fi

echo "Installation complete!"

