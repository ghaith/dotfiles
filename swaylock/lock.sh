#!/bin/sh
swaylock -i `find ~/wallpapers -type f -name '*.png' -or -name '*.jpg' | shuf -n 1`

