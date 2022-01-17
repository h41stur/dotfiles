#!/usr/bin/env bash
# Add this script to your wm startup file.

DIR="$HOME/.config/polybar/cuts"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
polybar -q top -c "$DIR"/config.ini &
polybar -q bottom -c "$DIR"/config.ini &
if [[ $(xrandr -q | grep 'HDMI' | grep -w 'connected' | wc -l) = 1 ]]
then
		polybar -q external -c "$DIR"/config.ini &
fi
