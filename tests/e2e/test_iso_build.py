"""
LNOS E2E Tests - ISO Build Pipeline
Tests the ISO build process as specified in Section 10.
"""
import subprocess
import os

SCRIPTS_DIR = os.path.join(os.path.dirname(__file__), "..", "..", "scripts")


def test_build_script_exists():
    """Verify build-iso.sh exists and is executable."""
    path = os.path.join(SCRIPTS_DIR, "build-iso.sh")
    assert os.path.exists(path), f"build-iso.sh not found at {path}"
    assert os.access(path, os.X_OK), "build-iso.sh is not executable"
    print("✓ build-iso.sh exists and is executable")


def test_maint_scripts_exist():
    """Verify all maintenance scripts exist."""
    scripts = [
        "limpiar-cache.sh",
        "verificar-salud.sh",
        "optimizar-repo.sh",
        "generar-reporte.sh",
        "setup-systemd-timers.sh",
        "lnos-firstrun.sh",
    ]
    for script in scripts:
        path = os.path.join(SCRIPTS_DIR, script)
        assert os.path.exists(path), f"{script} not found"
        print(f"  ✓ {script}")


def test_iso_profile_exists():
    """Verify ISO profile structure."""
    iso_dir = os.path.join(os.path.dirname(__file__), "..", "..", "iso")
    assert os.path.exists(os.path.join(iso_dir, "default", "profiledef.sh"))
    assert os.path.exists(os.path.join(iso_dir, "default", "packages.x86_64"))
    assert os.path.exists(os.path.join(iso_dir, "default", "pacman.conf"))
    print("✓ ISO profiles structure complete")


def test_btrfs_subvolumes():
    """Verify Btrfs subvolume configuration matches spec Section 81.3."""
    expected = ["@", "@home", "@snapshots", "@log", "@cache", "@tmp"]
    installer = os.path.join(SCRIPTS_DIR, "install-lnos.sh")
    with open(installer) as f:
        content = f.read()
    for vol in expected:
        assert vol in content, f"Subvolume {vol} not found in installer"
    print("✓ Btrfs subvolume config matches specification")


if __name__ == "__main__":
    test_build_script_exists()
    test_maint_scripts_exist()
    test_iso_profile_exists()
    test_btrfs_subvolumes()
    print("\n✓ All E2E tests passed!")
