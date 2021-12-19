#!/bin/sh

OUTPUT=DisplayPort-1
WIDTH=$1
HEIGHT=$2
ACTION=$3

#WIDTH=5120
#HEIGHT=1440
#WIDTH=3840
#HEIGHT=1080

RESOLUTION=$(printf '%dx%d' $WIDTH $HEIGHT)


function setResolution() {
	echo $RESOLUTION
	xrandr --output $OUTPUT --mode $RESOLUTION
}

function split() {
	SPLIT_WIDTH=$((WIDTH / 2))
	#Define monitors
	xrandr --setmonitor $OUTPUT-1 $SPLIT_WIDTH/$((WIDTH))x$((HEIGHT))/$((HEIGHT))+0+0 $OUTPUT 
	xrandr --setmonitor $OUTPUT-2 $SPLIT_WIDTH/$((WIDTH))x$((HEIGHT))/$((HEIGHT))+$((SPLIT_WIDTH))+0 none 

}

function refreshFb() {
	#Refresh frame buffer
	xrandr --fb $((WIDTH + 1))x$((HEIGHT))
	xrandr --fb $((WIDTH))x$((HEIGHT))
}

function reset() {
	xrandr --output $OUTPUT-2 --off
	xrandr --delmonitor $OUTPUT-1
	xrandr --delmonitor $OUTPUT-2
}

function tablet() {
	xrandr --addmode HDMI-A-1 1920x1080
	xrandr --output DisplayPort-1 --mode 5120x1440 --output HDMI-A-1 --mode 1920x1080 --pos 1540x1440 
}

setResolution

if [[ $ACTION == "split" ]]; then
	split
	#Restart bar
	$XDG_CONFIG_HOME/polybar/launch.sh dual
elif [[ $ACTION == "reset" ]]; then
	reset
	#Restart bar
	$XDG_CONFIG_HOME/polybar/launch.sh
elif [[ $ACTION == "tablet" ]]; then
	reset
	tablet
	#Restart bar
	$XDG_CONFIG_HOME/polybar/launch.sh
fi      
refreshFb
