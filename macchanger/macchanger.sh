#!/bin/sh

# Install macchanger.
sudo pacman -S --needed --noconfirm macchanger

# Configure systemd service.
sudo tee /etc/systemd/system/macspoof@.service << EOF
[Unit]
Description=macchanger on %I
Wants=network-pre.target
Before=network-pre.target
BindsTo=sys-subsystem-net-devices-%i.device
After=sys-subsystem-net-devices-%i.device

[Service]
ExecStart=/usr/bin/macchanger -r %I
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF

# Enable random MAC address for wlan0.
sudo systemctl enable macspoof@wlan0.service
