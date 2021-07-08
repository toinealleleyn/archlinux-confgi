#!/bin/bash

# Input YouTube API Key.
echo -n "Enter your YouTube API key and press [ENTER]: " 
read APIKEY

# Install dependencies.
sudo pacman -S --needed --noconfirm jq >/dev/null 2>&1

# Copy to /usr/local/bin.
sudo cp ytp /usr/local/bin/ytp

# Put the entered API key in the script.
sudo sed -i "s/API_KEY_HERE/$APIKEY/g" /usr/local/bin/ytp
