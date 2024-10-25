#!/bin/env bash

# If dotter is not yet installed, download dotter
if ! which dotter > /dev/null; then
	VER=$(curl --silent -qI https://github.com/SuperCuber/dotter/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}')
	wget https://github.com/SuperCuber/dotter/releases/download/$VER/dotter-linux-x64-musl -O dotter
	chmod +x ./dotter
fi

# Install homebrew
if ! which brew > /dev/null; then
	wget https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -O /tmp/homebrew.sh
	chmod +x /tmp/homebrew.sh
	/tmp/homebrew.sh
fi

#Installs an application using brew if it does not already exist
function install() {
	local command="$1"
	local name=$2
	if [ -z "$name" ]; then
		name="$command"
	fi
	if ! which $command > /dev/null; then
		brew install $name
	fi
}


install "starship"
install "bat"
install "eza"
install "rg" "ripgrep"
install "nvim" "neovim"
install "zellij"
install "hx" "helix"

# run dotter
if ! which dotter > /dev/null; then
	./dotter -l .dotter/devcontainer.toml
else
	dotter
fi
