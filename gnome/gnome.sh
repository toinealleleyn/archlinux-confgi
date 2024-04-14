#/bin/sh

# Set clock to 24h format
gsettings set org.gnome.desktop.interface clock-format 24h

# Set keyboard layout
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+intl')]"

# Install flatpak
sudo pacman -S --needed --noconfirm flatpak

# Enable bluetooth and change default behaviour to "off"
sudo sed -i 's/^#AutoEnable=true/AutoEnable=false/g' /etc/bluetooth/main.conf
sudo systemctl enable bluetooth --now

# Set dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# adw-gtk3
mkdir -p ~/.local/share/themes
curl -sLo "adw-gtk3.tar.xz"  $(curl -s https://api.github.com/repos/lassekongo83/adw-gtk3/releases/latest | grep browser_download_url | cut -d\" -f4)
tar -xf adw-gtk3.tar.xz -C ~/.local/share/themes/
rm -rf adw-gtk3.tar.xz
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"

# Thumbnail previews
sudo pacman -S --needed --noconfirm tumbler ffmpegthumbnailer poppler-glib webp-pixbuf-loader
rm -rf ~/.cache/thumbnails
