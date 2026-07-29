# LNOS — Linux, Now. Optimized. Secured.

**LNOS** is a professional Arch Linux-based distribution combining the flexibility of rolling releases with the stability, security, and polished user experience required in professional environments.

## Vision

| Aspect | Description |
|--------|------------|
| **Base** | Arch Linux (rolling release) |
| **Desktop** | Hyprland + Wayland |
| **Security** | AppArmor, nftables, Secure Boot |
| **Storage** | Btrfs + Timeshift snapshots |
| **Audio** | PipeWire + WirePlumber |
| **Modules** | Declarative, dependency-resolved |

## Quick Start

```bash
# Clone and build
git clone https://github.com/lnos/lnos
cd lnos
cargo build --release

# View available modules
./target/release/lnos-mod list

# Build ISO
./scripts/build-iso.sh desktop
```

## Project Structure

```
lnos/
├── src/          # Rust tools (lnos-mod, lnos-config, etc.)
├── modules/      # Module definitions (module.toml + hooks)
├── iso/          # ISO build profiles
├── scripts/      # Maintenance and automation scripts
├── docs/         # Full specification (120 chapters)
└── tests/        # Integration and E2E tests
```

## License

MIT
