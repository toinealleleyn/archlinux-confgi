#!/bin/sh

[[ $1 = "inc" ]] && brightnessctl -q s 5%+
[[ $1 = "dec" ]] && brightnessctl -q s 5%-

BRIGHTNESS=$(brightnessctl -m | cut -d, -f4 | sed 's/%//')

notify-send -e -h string:x-canonical-private-synchronous:brightness_notif \
	-h int:value:$BRIGHTNESS -u low "Brightness : $BRIGHTNESS%"
