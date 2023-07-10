#!/bin/sh

# Script to enable the use of a dslr camera as webcam using USB.
# Using USB will result in low resolution and a noticeable delay, so a HDMI capture card is preferred over this.

# Install required packages.
echo "[#] Installing packages." 
sudo pacman -S --needed --noconfirm gphoto2 v4l-utils v4l2loopback-dkms ffmpeg linux-headers zvbi >/dev/null 2>&1

echo "[#] Configuring v4l2loopback to load on boot."
# Configure module v4l2loopback to load on boot.
sudo tee /etc/modules-load.d/v4l2loopback.conf >/dev/null 2>&1 << EOF
v4l2loopback
EOF

# Configure module options.
echo "[#] Setting module options."
sudo tee /etc/modprobe.d/v4l2loopback.conf >/dev/null 2>&1 << EOF
options v4l2loopback exclusive_caps=1 max_buffers=2
EOF

# Load module now.
echo "[#] Loading module v4l2loopback."
sudo modprobe v4l2loopback

# Create command to start capturing video.
DSLRDEV=$(v4l2-ctl --list-devices | grep -A1 Dummy | grep "/dev/video" | sed -e 's/^[[:space:]]*//')
echo -e "\n[*] Run the following command to start capturing with the DSLR camera"
echo "gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 $DSLRDEV"
