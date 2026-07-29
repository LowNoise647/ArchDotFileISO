#!/usr/bin/env bash
set -euo pipefail

# LNOS ISO customization script
echo "Customizing LNOS live image..."

# Create LNOS directories
mkdir -p /etc/lnos/modules
mkdir -p /etc/lnos/state
mkdir -p /usr/share/lnos/modules

# Set up systemd services
systemctl enable NetworkManager.service
systemctl enable systemd-resolved.service
systemctl enable systemd-timesyncd.service

# Default locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname
echo "lnos-live" > /etc/hostname

# Shell
echo "LNOS Live Environment" > /etc/motd

# Sudo config
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel

# Create live user
useradd -m -G wheel,audio,video,storage,power -s /bin/bash live
echo "live:live" | chpasswd

# Install LNOS modules
cp -r /usr/share/lnos/modules/* /etc/lnos/modules/ 2>/dev/null || true

echo "LNOS live image customization complete"
