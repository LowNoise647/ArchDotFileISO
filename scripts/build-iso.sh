#!/usr/bin/env bash
set -euo pipefail

LNOS_VERSION="${1:-0.1.0}"
PROFILE="${2:-desktop}"
ISO_DIR="$(dirname "$0")/../iso"
OUT_DIR="$(dirname "$0")/../out"

echo "=== LNOS ISO Builder v${LNOS_VERSION} ==="
echo "Profile: ${PROFILE}"

if ! command -v mkarchiso &>/dev/null; then
    echo "ERROR: mkarchiso not found. Install archiso package."
    exit 1
fi

mkdir -p "${OUT_DIR}"

echo "[1/6] Verifying tools..."
for cmd in mkarchiso pacman gpg sha256sum; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "Missing: $cmd"; exit 1; }
done

echo "[2/6] Building Rust tools..."
cd "$(dirname "$0")/.."
cargo build --release 2>&1 | tail -5

echo "[3/6] Preparing ISO profile..."
PROFILE_DIR="${ISO_DIR}/${PROFILE}"
if [ ! -d "${PROFILE_DIR}" ]; then
    echo "Using default profile"
    PROFILE_DIR="${ISO_DIR}/default"
fi

echo "[4/6] Building packages..."
PKG_DIR="$(dirname "$0")/../pkg"
for pkg in "${PKG_DIR}"/*/; do
    if [ -f "${pkg}PKGBUILD" ]; then
        echo "  Building: $(basename "$pkg")"
        (cd "$pkg" && makepkg -s --noconfirm 2>&1 | tail -3)
    fi
done

echo "[5/6] Generating ISO..."
mkarchiso -v -w /tmp/archiso-tmp -o "${OUT_DIR}" "${PROFILE_DIR}"

echo "[6/6] Signing and checksums..."
ISO_FILE=$(ls -t "${OUT_DIR}"/LNOS-*.iso 2>/dev/null | head -1)
if [ -n "$ISO_FILE" ]; then
    gpg --detach-sign --armor "${ISO_FILE}" 2>/dev/null || true
    sha256sum "${ISO_FILE}" > "${ISO_FILE}.sha256"
    echo "ISO: ${ISO_FILE}"
    echo "SHA256: $(cat "${ISO_FILE}.sha256")"
fi

echo "=== ISO build complete ==="
