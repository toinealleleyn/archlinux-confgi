#!/bin/sh

# Add color to pacman.
sudo sed -i 's/^#Color/Color/g' /etc/pacman.conf

# Set timezone.
sudo timedatectl set-timezone "Europe/Amsterdam"

# Install required packages.
sudo pacman -S --noconfirm --needed libx11 libxinerama xorg-server xorg-xinit xautolock xorg-xset xorg-xsetroot xorg-xrandr \
	xbindkeys xorg-xbacklight libxkbcommon xf86-input-libinput pipewire pipewire-pulse pulsemixer gnome-themes-extra \
	picom feh ttf-fira-code ttf-fira-sans ttf-joypixels dunst pamixer base-devel git

# Download and install an AUR helper.
# Default: paru. Change variable AURHELPER for a different helper. 
AURHELPER="paru"
AURURL="https://aur.archlinux.org/cgit/aur.git/snapshot/$AURHELPER.tar.gz"

# Configure makepkg to use all cores for compilation.
grep "MAKEFLAGS=\"-j$(nproc)\"" /etc/makepkg.conf >/dev/null 2>&1 || \
	sudo sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

# Download and build the AUR helper.
[ -f "/usr/bin/$AURHELPER" ] || (
	cd /tmp || exit 1
	rm -rf /tmp/"$AURHELPER"*
	curl -sO "$AURURL" &&
	tar -xvf "$AURHELPER".tar.gz >/dev/null 2>&1 &&
	cd "$AURHELPER" &&
	makepkg --noconfirm -si || echo "Failed."
	cd /tmp
	rm -rf /tmp/"$AURHELPER"* )

# Install symbols and patched libxft for color emoji support.
# Needs to be manually accepted because of conflicts.
paru -S --needed libxft-bgra nerd-fonts-fira-code lf-bin

# Set keyboard layout to US Intl with dead keys.
sudo localectl set-x11-keymap us "" intl

# Configure picom
mkdir -p $HOME/.config/picom/
cp /etc/xdg/picom.conf $HOME/.config/picom/picom.conf
sed -i 's/^fading = true/fading = false/g' $HOME/.config/picom/picom.conf
sed -i 's/^shadow = true/shadow = false/g' $HOME/.config/picom/picom.conf
sed -i 's/ opacity = 0.8/ opacity = 1.0/g' $HOME/.config/picom/picom.conf
sed -i 's/ opacity = 0.75/ opacity = 1.0/g' $HOME/.config/picom/picom.conf
sed -i 's/^frame-opacity = 0.7/frame-opacity = 1.0/g' $HOME/.config/picom/picom.conf

# Configure dunst
mkdir -p $HOME/.config/dunst/
cp /etc/dunst/dunstrc $HOME/.config/dunst/dunstrc
sed -i 's/Monospace 8/Fira Code 10/g' $HOME/.config/dunst/dunstrc
sed -i 's/geometry = "300x5-30+20"/geometry = "300x5-5+25"/g' $HOME/.config/dunst/dunstrc
sed -i 's/frame_color = "#aaaaaa"/frame_color = "#83a598"/g' $HOME/.config/dunst/dunstrc
sed -i 's/background = "#285577"/background = "#83a598"/g' $HOME/.config/dunst/dunstrc

# Configure GTK
mkdir -p $HOME/.config/gtk-3.0/
tee $HOME/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-icon-theme-name = Adwaita
gtk-theme-name = Adwaita-dark
gtk-font-name = Fira Sans 10
EOF

mkdir -p $HOME/.config/lf/
tee $HOME/.config/lf/lfrc << EOF
set icons
set drawbox
set ifs "\n"

# bindings
cmd delete %{{
    printf "Remove '\$fx' [y/n]? "
    read ans
    [ \$ans = "y" ] && rm -rf \$fx && printf "Removed '\$fx'."
}}
map x delete
EOF

# Set cursor theme to X11 default (i like it)
sudo sed -i 's/Inherits=Adwaita/Inherits=""/g' /usr/share/icons/default/index.theme

# Create statusbar
mkdir -p $HOME/.scripts/
[ -f /sys/class/power_supply/BAT0/capacity ] || tee $HOME/.scripts/statusbar.sh << EOF
#!/bin/sh

# Date and time
DATE=\$(date +"%d-%m")
TIME=\$(date +"%H:%M")

# Volume
VOLUME=\$(pamixer --get-volume-human)
if [ "\$VOLUME" = "muted" ]; then
        VOLUMEICON="ﱝ"
else
        VOLUMEICON=""
fi

# RSS
pgrep newsboat || RSS=\$(newsboat -x print-unread | awk '{print \$1}')
pgrep newsboat && RSS="@"

xsetroot -name "  \$RSS | \$VOLUMEICON \$VOLUME |  \$DATE |  \$TIME"
EOF
[ -f /sys/class/power_supply/BAT0/capacity ] && tee $HOME/.scripts/statusbar.sh << EOF
#!/bin/sh

# Date and time
DATE=\$(date +"%d-%m")
TIME=\$(date +"%H:%M")

# Volume
VOLUME=\$(pamixer --get-volume-human)
if [ "\$VOLUME" = "muted" ]; then
        VOLUMEICON="ﱝ"
else
        VOLUMEICON=""
fi

# Battery
BATTERY=\$(cat /sys/class/power_supply/BAT0/capacity)
if [ \$(cat /sys/class/power_supply/BAT0/status) = "Charging" ]; then
	BATTERYICON=""
elif [ "\$BATTERY" -gt 75 ] && [ "\$BATTERY" -le 100 ]; then
        BATTERYICON=""
elif [ "\$BATTERY" -gt 50 ] && [ "\$BATTERY" -le 75 ]; then
        BATTERYICON=""
elif [ "\$BATTERY" -gt 25 ] && [ "\$BATTERY" -le 50 ]; then
        BATTERYICON=""
elif [ "\$BATTERY" -ge 0 ] && [ "\$BATTERY" -le 25 ]; then
        BATTERYICON=""
fi

# RSS
pgrep newsboat || RSS=\$(newsboat -x print-unread | awk '{print \$1}')
pgrep newsboat && RSS="@"

# Set statusbar
xsetroot -name "  \$RSS | \$BATTERYICON \$BATTERY% | \$VOLUMEICON \$VOLUME |  \$DATE |  \$TIME"
EOF
chmod +x $HOME/.scripts/statusbar.sh

# Configure audio and backlight keybinds
tee $HOME/.xbindkeysrc << EOF
## Audio

# Increase volume
"pactl set-sink-volume @DEFAULT_SINK@ +1000 && \$HOME/.scripts/statusbar.sh"
   XF86AudioRaiseVolume

# Decrease volume
"pactl set-sink-volume @DEFAULT_SINK@ -1000 && \$HOME/.scripts/statusbar.sh"
   XF86AudioLowerVolume

# Mute volume
"pactl set-sink-mute @DEFAULT_SINK@ toggle && \$HOME/.scripts/statusbar.sh"
   XF86AudioMute


## Backlight

# Increase backlight
"xbacklight -inc 5"
   XF86MonBrightnessUp

# Decrease backlight
"xbacklight -dec 5"
   XF86MonBrightnessDown
EOF

# Touchpad settings
sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf << EOF
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
	Option "Tapping" "on"
	Option "ClickMethod" "clickfinger"
	Option "NaturalScrolling" "true"
	Option "ScrollMethod" "twofinger"
	Option "ScrollPixelDistance" "30"
EndSection
EOF

# Mouse settings
sudo tee /etc/X11/xorg.conf.d/20-mouse.conf << EOF
Section "InputClass"
        Identifier "My Mouse"
        Driver "libinput"
        MatchIsPointer "yes"
        Option "AccelProfile" "flat"
        Option "TransformationMatrix" "1 0 0 0 1 0 0 0 1"
EndSection
EOF

# Configure .xinitrc
tee $HOME/.xinitrc << EOF
# Compositor
picom &

# Restore background
\$HOME/.fehbg &

# Notifications
dunst &

# Screen power management
xset s 300 &

# Screen locking
xautolock -corners -+00 -cornerdelay 1 -time 5 -locker "slock" -detectsleep -killtime 10 -killer "systemctl suspend" &

# Load keybindings
xbindkeys &

# Set statusbar
while true; do
        \$HOME/.scripts/statusbar.sh
        sleep 1m
done &

# Launch dwm
exec dwm

EOF

# Configure wallpaper
mkdir -p $HOME/.local/share/backgrounds/
cp wallpapers/mountains-draw.jpg $HOME/.local/share/backgrounds/
tee $HOME/.fehbg << EOF
#!/bin/sh
feh --no-fehbg --bg-scale "\$HOME/.local/share/backgrounds/mountains-draw.jpg"
EOF
chmod +x $HOME/.fehbg

# Get dwm, st, dmenu and slock
mkdir $HOME/.src/
cd $HOME/.src/
git clone https://github.com/toinealleleyn/dmenu &&
	cd $HOME/.src/dmenu &&
	make &&
	sudo make install
cd $HOME/.src/
git clone https://github.com/toinealleleyn/slock &&
	cd $HOME/.src/slock &&
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
