#!/bin/sh

[[ $1 = "inc" ]] && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
[[ $1 = "dec" ]] && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-

VOLUME_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk -F ' ' '{print $2}')
VOLUME=$(echo "$VOLUME_RAW * 100" | bc | awk -F '.' '{print $1}')

notify-send -e -h int:value:"$VOLUME" -h string:x-canonical-private-synchronous:volume_notif \
	-u low "Volume: $VOLUME"
