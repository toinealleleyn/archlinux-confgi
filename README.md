# archlinux-config
Post-installation configuration scripts for Arch Linux to make my life easier.

## Scripts

The scripts assume my personal clean install of Arch Linux, so use at your own risk.

- `aurhelper.sh`: install an AUR helper (default: paru)
- `dash.sh`: install dash and configure as /bin/sh, including pacman hook
- `dwm.sh`: dirty script to install and configure my build of dwm, st, dmenu and slock
- `hibernation.sh`: configures system hibernation
- `newsboat.sh`: install newsboat with my custom macros
- `nvidiaprime.sh`: enables NVIDIA PRIME including RTD3 Power Management
- `powersaving.sh`: installs and configures tlp, tlp-rdw (defaults) and powertop (--auto-tune)
- `systemd-boot.sh`: creates pacman hook to update systemd-boot after the systemd package upgrades
- `zsh.sh`: installs zsh and deploys my zsh dotfiles
