#!/bin/sh

# If dotter is not yet installed, download dotter
if ! which dotter > /dev/null; then
	VER=$(curl --silent -qI https://github.com/SuperCuber/dotter/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}')
	wget https://github.com/SuperCuber/dotter/releases/download/$VER/dotter-linux-x64-musl -O dotter
	chmod +x ./dotter
fi

# run dotter
if ! which dotter > /dev/null; then
	./dotter -l .dotter/devcontainer.toml
else
	dotter
fi
