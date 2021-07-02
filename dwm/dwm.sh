#!/bin/sh

# Add color to pacman.
sudo sed -i 's/^#Color/Color/g' /etc/pacman.conf

# Install required packages.
sudo pacman -S --needed libx11 libxft libxinerama xorg-server xorg-xinit xautolock xorg-xset xorg-xsetroot xorg-xrandr xbindkeys xorg-xbacklight \
	pipewire pipewire-pulse pulsemixer gnome-themes-extra picom nitrogen adobe-source-code-pro-fonts dunst \
	base-devel git

# Configure picom
mkdir -p $HOME/.config/picom/
cp /etc/xdg/picom.conf $HOME/.config/picom/picom.conf
sed -i 's/^fading = true/fading = false/g' $HOME/.config/picom/picom.conf
sed -i 's/^shadow = true/shadow = false/g' $HOME/.config/picom/picom.conf

# Configure GTK
mkdir -p $HOME/.config/gtk-3.0/
tee $HOME/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-icon-theme-name = Adwaita
gtk-theme-name = Adwaita-dark
EOF

# Create statusbar
mkdir -p $HOME/.scripts/
[ -f /sys/class/power_supply/BAT0/capacity ] || tee $HOME/.scripts/statusbar.sh << EOF
while true; do
	TIMEDATE=\$(date +"%d-%m | %H:%M")
	xsetroot -name "\$TIMEDATE"
	sleep 1m
done
EOF
[ -f /sys/class/power_supply/BAT0/capacity ] && tee $HOME/.scripts/statusbar.sh << EOF
while true; do
	TIMEDATE=\$(date +"%d-%m | %H:%M")
	BATTERY=\$(cat /sys/class/power_supply/BAT0/capacity)
	xsetroot -name "\$BATTERY% | \$TIMEDATE"
	sleep 1m
done
EOF

# Configure audio and backlight keybinds
tee $HOME/.xbindkeysrc << EOF
## Audio

# Increase volume
"pactl set-sink-volume @DEFAULT_SINK@ +1000"
   XF86AudioRaiseVolume

# Decrease volume
"pactl set-sink-volume @DEFAULT_SINK@ -1000"
   XF86AudioLowerVolume

# Mute volume
"pactl set-sink-mute @DEFAULT_SINK@ toggle"
   XF86AudioMute


## Backlight

# Increase backlight
"xbacklight -inc 10"
   XF86MonBrightnessUp

# Decrease backlight
"xbacklight -dec 10"
   XF86MonBrightnessDown
EOF
 
# Configure .xinitrc
tee $HOME/.xinitrc << EOF
picom &
nitrogen --restore &
dunst &
xset s 300 &
xautolock -time 5 -locker "slock" -detectsleep -killtime 10 -killer "systemctl suspend" &
xbindkeys &
$HOME/.scripts/statusbar.sh &
exec dwm
EOF

# Get dwm, st, dmenu and slock
mkdir $HOME/.src/
cd $HOME/.src/
git clone https://git.suckless.org/dmenu &&
	cd $HOME/.src/dmenu &&
	make &&
	sudo make install
cd $HOME/.src/
git clone https://git.suckless.org/slock &&
	cd $HOME/.src/slock &&
	sed -i 's/nogroup/nobody/g' config.def.h
	make &&
	sudo make install
cd $HOME/.src/
git clone https://github.com/toinealleleyn/dwm &&
	cd $HOME/.src/dwm &&
	make &&
	sudo make install
cd $HOME/.src/
git clone https://github.com/toinealleleyn/st &&
	cd $HOME/.src/st &&
	make &&
	sudo make install
