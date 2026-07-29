#!/usr/bin/env bash
# LNOS Repository Optimizer
# Section 83.4 of LNOS Specification
set -euo pipefail

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

log "=== LNOS Repository Optimization ==="

# 1. Update mirrorlist
if command -v reflector &>/dev/null; then
    log "Updating mirrorlist with fastest mirrors..."
    reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
fi

# 2. Refresh pacman keys
log "Refreshing pacman keys..."
pacman-key --refresh-keys 2>/dev/null || true

# 3. Verify package database
log "Verifying package database integrity..."
pacman -Dk 2>/dev/null || true

# 4. Update database
log "Syncing package databases..."
pacman -Syy --noconfirm

# 5. Check for corrupt packages
log "Checking for corrupt packages..."
pacman -Qkk 2>/dev/null | grep -v "OK" || echo "All packages OK"

log "Repository optimization complete"
