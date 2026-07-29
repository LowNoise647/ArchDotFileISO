#!/usr/bin/env bash
# LNOS Cache Cleaner
# Section 83.2 of LNOS Specification
set -euo pipefail

echo "[LNOS Maintenance] Cleaning system caches..."

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }
SPACE_BEFORE=$(df / | awk 'NR==2 {print $4}')

# 1. Clean pacman cache (keep last 3 versions)
log "Cleaning pacman cache (keeping last 3 versions)..."
paccache -r -k 3 2>/dev/null || true

# 2. Remove orphaned packages
log "Removing orphaned packages..."
ORPHANS=$(pacman -Qtdq 2>/dev/null || true)
if [ -n "$ORPHANS" ]; then
    echo "  Orphans found: $ORPHANS"
    pacman -Rns --noconfirm $ORPHANS 2>/dev/null || true
else
    echo "  No orphan packages found."
fi

# 3. Clean Flatpak unused
if command -v flatpak &>/dev/null; then
    log "Cleaning Flatpak unused runtimes..."
    flatpak uninstall --unused -y 2>/dev/null || true
fi

# 4. Vacuum journal logs (keep last 30 days)
log "Vacuuming journal logs (30 day retention)..."
journalctl --vacuum-time=30d 2>/dev/null || true

# 5. Report
SPACE_AFTER=$(df / | awk 'NR==2 {print $4}')
SAVED=$(( (SPACE_BEFORE - SPACE_AFTER) / 1024 ))
log "Space recovered: ~${SAVED} MB"
