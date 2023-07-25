#!/bin/sh

# Set up libinput
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
sudo tee /etc/X11/xorg.conf.d/30-mouse.conf << EOF
Section "InputClass"
        Identifier "My Mouse"
        Driver "libinput"
        MatchIsPointer "yes"
        Option "AccelProfile" "flat"
        Option "TransformationMatrix" "1 0 0 0 1 0 0 0 1"
EndSection
EOF
