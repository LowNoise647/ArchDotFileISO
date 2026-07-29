#!/usr/bin/env bash
# LNOS Automated Installer
# Based on Arch Linux installation, following LNOS Specification
set -euo pipefail

# Configuration
LNOS_HOSTNAME="${LNOS_HOSTNAME:-lnos}"
LNOS_USER="${LNOS_USER:-user}"
LNOS_PASSWORD="${LNOS_PASSWORD:-lnos}"
LNOS_DISK="${LNOS_DISK:-/dev/vda}"
LNOS_PARTITION="${LNOS_PARTITION:-}"       # Ej: /dev/vda2 (si ya existe, se salta particionado)
LNOS_ESP_PARTITION="${LNOS_ESP_PARTITION:-}" # Ej: /dev/vda1 (ESP existente)
LNOS_TIMEZONE="${LNOS_TIMEZONE:-Europe/Madrid}"
LNOS_LOCALE="${LNOS_LOCALE:-en_US.UTF-8}"
LNOS_KEYMAP="${LNOS_KEYMAP:-us}"

log() { echo "[LNOS-INSTALL] $*"; }

log "=== LNOS Automated Installation ==="

if [ -n "${LNOS_PARTITION}" ]; then
    log "Using existing partition: ${LNOS_PARTITION}"
    ROOT_PART="${LNOS_PARTITION}"
    [ -n "${LNOS_ESP_PARTITION}" ] && ESP_PART="${LNOS_ESP_PARTITION}"
    # Solo formatear la partición root
    log "Formatting ${ROOT_PART} as Btrfs..."
    mkfs.btrfs -f "${ROOT_PART}"
else
    log "Target disk: ${LNOS_DISK}"
    # 1. Partition disk (UEFI + Btrfs)
    log "Partitioning disk..."
    parted -s "${LNOS_DISK}" mklabel gpt
    parted -s "${LNOS_DISK}" mkpart primary fat32 1MiB 512MiB
    parted -s "${LNOS_DISK}" set 1 esp on
    parted -s "${LNOS_DISK}" mkpart primary 512MiB 100%

    # 2. Format partitions
    log "Formatting partitions..."
    mkfs.fat -F32 "${LNOS_DISK}1"
    mkfs.btrfs -f "${LNOS_DISK}2"
    ESP_PART="${LNOS_DISK}1"
    ROOT_PART="${LNOS_DISK}2"
fi

# 3. Create Btrfs subvolumes (Section 81.3)
log "Creating Btrfs subvolumes..."
mount "${ROOT_PART}" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@tmp
umount /mnt

# 4. Mount subvolumes
log "Mounting subvolumes..."
mount -o subvol=@,compress=zstd:1 "${ROOT_PART}" /mnt
mkdir -p /mnt/{home,.snapshots,var/log,var/cache,tmp,boot}
mount -o subvol=@home,compress=zstd:1 "${ROOT_PART}" /mnt/home
mount -o subvol=@snapshots,compress=zstd:3 "${ROOT_PART}" /mnt/.snapshots
mount -o subvol=@log,nodatacow "${ROOT_PART}" /mnt/var/log
mount -o subvol=@cache,nodatacow "${ROOT_PART}" /mnt/var/cache
mount -o subvol=@tmp,nodatacow "${ROOT_PART}" /mnt/tmp
mount "${ESP_PART}" /mnt/boot

# 5. Install base system
log "Installing base system..."
pacstrap -K /mnt base base-devel linux linux-firmware linux-headers \
    systemd systemd-libs btrfs-progs \
    networkmanager sudo vim git man-db \
    amd-ucode intel-ucode

# 6. Generate fstab
log "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# 7. Chroot configuration
log "Configuring system..."
export LNOS_TIMEZONE LNOS_LOCALE LNOS_KEYMAP LNOS_HOSTNAME LNOS_PASSWORD LNOS_USER ROOT_PART ESP_PART
arch-chroot /mnt /bin/bash <<'CHROOT'
set -euo pipefail

# Timezone
ln -sf "/usr/share/zoneinfo/${LNOS_TIMEZONE}" /etc/localtime
hwclock --systohc

# Locale
echo "${LNOS_LOCALE} UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=${LNOS_LOCALE}" > /etc/locale.conf
echo "KEYMAP=${LNOS_KEYMAP}" > /etc/vconsole.conf

# Hostname
echo "${LNOS_HOSTNAME}" > /etc/hostname
cat >> /etc/hosts << HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${LNOS_HOSTNAME}.local ${LNOS_HOSTNAME}
HOSTS

# Root password
echo "root:${LNOS_PASSWORD}" | chpasswd

# Create user
useradd -m -G wheel,audio,video,storage,power -s /bin/bash "${LNOS_USER}"
echo "${LNOS_USER}:${LNOS_PASSWORD}" | chpasswd

# Sudo config
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel

# Bootloader (systemd-boot)
bootctl install
cat > /boot/loader/loader.conf << LOADER
default lnos
timeout 5
console-mode max
editor no
LOADER

ROOT_UUID=$(blkid -s UUID -o value ${ROOT_PART})
cat > /boot/loader/entries/lnos.conf << ENTRY
title   LNOS
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /amd-ucode.img
initrd  /initramfs-linux.img
options root=UUID=${ROOT_UUID} rootflags=subvol=@ rw quiet splash
ENTRY

# Enable services
systemctl enable NetworkManager.service
systemctl enable systemd-resolved.service
systemctl enable systemd-timesyncd.service
systemctl enable fstrim.timer

# Configure pacman
sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

# Initramfs
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Create LNOS directories
mkdir -p /etc/lnos/modules
mkdir -p /etc/lnos/state
mkdir -p /usr/share/lnos/modules
mkdir -p /usr/share/lnos/scripts

echo "System configured"
CHROOT

# 8. Install LNOS modules
log "Copying LNOS modules..."
cp -r /run/media/shadowos/DATOS/Programacion/Mix_Lenguajes/LNOS/modules/* /mnt/usr/share/lnos/modules/

# 9. Copy LNOS scripts
log "Copying LNOS scripts..."
cp -r /run/media/shadowos/DATOS/Programacion/Mix_Lenguajes/LNOS/scripts/* /mnt/usr/share/lnos/scripts/

# 10. Unmount and finish
log "Unmounting..."
umount -R /mnt

log "=== LNOS Installation Complete! ==="
log "User: ${LNOS_USER} / Password: ${LNOS_PASSWORD}"
log "Reboot to start LNOS"
