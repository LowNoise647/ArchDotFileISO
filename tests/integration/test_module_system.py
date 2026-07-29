"""
LNOS Module System Integration Tests
Tests the module system functionality as specified in Section 7.
"""
import subprocess
import json
import os
import tempfile
import shutil

LNOS_MOD_BIN = os.environ.get("LNOS_MOD_BIN", "./target/debug/lnos-mod")
TEST_DIR = tempfile.mkdtemp(prefix="lnos-test-")


def _setup_once():
    modules_src = os.path.join(os.path.dirname(__file__), "..", "..", "modules")
    modules_dst = os.path.join(TEST_DIR, "modules")
    state_dst = os.path.join(TEST_DIR, "state")
    if not os.path.exists(modules_dst):
        shutil.copytree(modules_src, modules_dst)
    os.makedirs(state_dst, exist_ok=True)
    return modules_dst, state_dst

MODULES_DIR, STATE_DIR = _setup_once()


def run_lnos_mod(*args):
    """Run lnos-mod with test directories."""
    cmd = [LNOS_MOD_BIN]
    cmd.extend(args)
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result


def test_list_modules():
    """Test that all 21 modules are listed."""
    result = run_lnos_mod("--modules-dir", MODULES_DIR, "--state-dir", STATE_DIR, "list")
    assert result.returncode == 0, f"Failed: {result.stderr}"
    lines = [l for l in result.stdout.split("\n") if l.strip()]
    assert len(lines) == 21, f"Expected 21 modules, got {len(lines)}"
    print(f"✓ All {len(lines)} modules detected")


def test_list_installed():
    """Test listing installed modules (should be empty initially)."""
    result = run_lnos_mod("--modules-dir", MODULES_DIR, "--state-dir", STATE_DIR, "list", "--installed")
    assert result.returncode == 0
    assert result.stdout.strip() == "", "Expected no installed modules"
    print("✓ No installed modules (correct)")


def test_module_info():
    """Test module info shows correct metadata."""
    result = run_lnos_mod("--modules-dir", MODULES_DIR, "--state-dir", STATE_DIR, "info", "lnos-base")
    assert result.returncode == 0
    assert "LNOS Base System" in result.stdout
    assert "1.0.0" in result.stdout
    print("✓ Module info shows correct metadata")


def test_module_dependencies():
    """Test dependency resolution."""
    result = run_lnos_mod("--modules-dir", MODULES_DIR, "--state-dir", STATE_DIR, "info", "lnos-hyprland")
    assert result.returncode == 0
    assert "lnos-base" in result.stdout
    print("✓ Module dependencies correct")


def test_gaming_module():
    """Test gaming module has all required packages."""
    result = run_lnos_mod("--modules-dir", MODULES_DIR, "--state-dir", STATE_DIR, "info", "lnos-gaming")
    assert result.returncode == 0
    assert "steam" in result.stdout
    assert "gamemode" in result.stdout
    assert "mangohud" in result.stdout
    assert "lutris" in result.stdout
    assert "wine" in result.stdout
    print("✓ Gaming module has all dependencies")


def test_module_status():
    """Test module status shows available."""
    result = run_lnos_mod("--modules-dir", MODULES_DIR, "--state-dir", STATE_DIR, "status", "lnos-base")
    assert result.returncode == 0
    assert "Available" in result.stdout
    print("✓ Module status is Available")


if __name__ == "__main__":
    test_list_modules()
    test_list_installed()
    test_module_info()
    test_module_dependencies()
    test_gaming_module()
    test_module_status()
    print(f"\n✓ All tests passed! (TEST_DIR={TEST_DIR})")
