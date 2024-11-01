#!/bin/env bash

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


# If dotter is not yet installed, download dotter
if ! which dotter > /dev/null; then
	VER=$(curl --silent -qI https://github.com/SuperCuber/dotter/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}')
	wget https://github.com/SuperCuber/dotter/releases/download/$VER/dotter-linux-x64-musl -O dotter
	chmod +x ./dotter
fi

# Install zellij plugin for vim / helix integration
if ! [ -f ./zellij/plugins/zellij-autolock.wasm ]; then
	VER=$(curl --silent -qI https://github.com/fresh2dev/zellij-autolock/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}')
	mkdir -p zellij/plugins
	wget https://github.com/fresh2dev/zellij-autolock/releases/download/$VER/zellij-autolock.wasm -O ./zellij/plugins/zellij-autolock.wasm
fi

# Find the default configuration
CONFIG=""
if ! ([[ -f .dotter/local.toml ]] || [[ -f .dotter/$(uname -n).toml ]]); then
	CONFIG="-l .dotter/default.toml"
fi

echo running dotter $CONFIG -v
# run dotter
if ! which dotter > /dev/null; then
	./dotter $CONFIG -v
else
	dotter $CONFIG -v
fi

# Install homebrew
if ! which brew > /dev/null; then
	wget https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -O /tmp/homebrew.sh
	chmod +x /tmp/homebrew.sh
	/tmp/homebrew.sh
	# eval the brew environment
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


install "starship"
install "bat"
install "eza"
install "rg" "ripgrep"
install "nvim" "neovim"
install "zellij"
install "hx" "helix"
install "fzf"
install "zoxide"
install "atuin"
install "gh"
