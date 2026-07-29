#!/usr/bin/env bash
# LNOS First Run - Automatic Hardware Detection and Optimization
# Section 93 of LNOS Specification
set -euo pipefail

log() { echo "[lnos-firstrun] $*"; }
FLAG_FILE="/var/lib/lnos/firstrun-done"

log "=== LNOS First Run Configuration ==="

# 1. Detect GPU
log "Detecting GPU..."
if lspci | grep -qi "VGA.*Intel"; then
    log "  Intel GPU detected"
    lnos-mod install lnos-gpu-intel 2>/dev/null || true
elif lspci | grep -qi "VGA.*AMD\|Radeon"; then
    log "  AMD GPU detected"
    lnos-mod install lnos-gpu-amd 2>/dev/null || true
elif lspci | grep -qi "VGA.*NVIDIA"; then
    log "  NVIDIA GPU detected (will prompt user)"
fi

# 2. Detect CPU and apply microcode
log "Detecting CPU..."
CPU_VENDOR=$(grep -m1 "vendor_id" /proc/cpuinfo | awk '{print $3}')
if [ "$CPU_VENDOR" = "GenuineIntel" ]; then
    log "  Intel CPU - applying intel-ucode"
    pacman -S --noconfirm intel-ucode 2>/dev/null || true
elif [ "$CPU_VENDOR" = "AuthenticAMD" ]; then
    log "  AMD CPU - applying amd-ucode"
    pacman -S --noconfirm amd-ucode 2>/dev/null || true
fi

# 3. Configure CPU governor
log "Configuring CPU governor..."
if [ -d /sys/devices/system/cpu/cpu0/cpufreq ]; then
    if lspci | grep -qi "VGA"; then
        echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || true
    else
        echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || true
    fi
fi

# 4. Detect battery
log "Detecting power source..."
if [ -d /sys/class/power_supply/BAT0 ]; then
    log "  Battery detected - enabling power saving profiles"
    systemctl enable power-profiles-daemon.service 2>/dev/null || true
fi

# 5. Detect storage and enable TRIM
log "Optimizing storage..."
if lsblk -dno rota 2>/dev/null | grep -q "^0"; then
    log "  SSD/NVMe detected - enabling periodic TRIM"
    systemctl enable fstrim.timer 2>/dev/null || true
fi

# 6. Detect Bluetooth
if lsusb | grep -qi "bluetooth\|bt"; then
    log "  Bluetooth hardware detected"
    systemctl enable bluetooth.service 2>/dev/null || true
fi

# 7. Mark first run complete
mkdir -p "$(dirname "$FLAG_FILE")"
date > "$FLAG_FILE"
log "First run configuration complete"
