#!/usr/bin/env bash
# LNOS Systemd Timer Setup
# Section 83.6 of LNOS Specification
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
ln -sf "${SCRIPT_DIR}/limpiar-cache.sh" /usr/local/bin/lnos-clean-cache
ln -sf "${SCRIPT_DIR}/verificar-salud.sh" /usr/local/bin/lnos-health-check
ln -sf "${SCRIPT_DIR}/optimizar-repo.sh" /usr/local/bin/lnos-optimize-repo
ln -sf "${SCRIPT_DIR}/generar-reporte.sh" /usr/local/bin/lnos-generate-report

# Create systemd service files
mkdir -p /etc/systemd/system

cat > /etc/systemd/system/lnos-clean-cache.service << 'EOF'
[Unit]
Description=LNOS Cache Cleaner
[Service]
Type=oneshot
ExecStart=/usr/local/bin/lnos-clean-cache
Nice=19
IOSchedulingClass=idle
EOF

cat > /etc/systemd/system/lnos-clean-cache.timer << 'EOF'
[Unit]
Description=LNOS Weekly Cache Cleanup
[Timer]
OnCalendar=weekly
Persistent=true
RandomizedDelaySec=1h
[Install]
WantedBy=timers.target
EOF

cat > /etc/systemd/system/lnos-health-check.service << 'EOF'
[Unit]
Description=LNOS Health Check
[Service]
Type=oneshot
ExecStart=/usr/local/bin/lnos-health-check
EOF

cat > /etc/systemd/system/lnos-health-check.timer << 'EOF'
[Unit]
Description=LNOS Daily Health Check
[Timer]
OnCalendar=daily
Persistent=true
RandomizedDelaySec=1h
[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable lnos-clean-cache.timer
systemctl enable lnos-health-check.timer

echo "Systemd timers installed and enabled"
