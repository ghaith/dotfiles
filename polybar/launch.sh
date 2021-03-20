#!/usr/bin/env bash

# If all your bars have ipc enabled, you can also use 
polybar-msg cmd quit
# Terminate already running bar instances
killall -q polybar


# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
if [ ! -z "$1" ]  && [ $1 == 'dual' ] 
	then
		polybar secondary >>/tmp/polybar2.log 2>&1 & disown
fi
polybar primary >>/tmp/polybar1.log 2>&1 & disown

echo "Bars launched..."
