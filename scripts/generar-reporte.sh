#!/usr/bin/env bash
# LNOS System Report Generator
# Section 83.5 of LNOS Specification
set -euo pipefail

REPORT_DIR="/var/log/lnos/reports"
mkdir -p "$REPORT_DIR"
REPORT_FILE="${REPORT_DIR}/report-$(date +%Y%m%d-%H%M%S).json"

python3 -c "
import json, subprocess, os
from datetime import datetime

def run(cmd):
    try:
        return subprocess.check_output(cmd, shell=True, text=True).strip()
    except:
        return 'N/A'

report = {
    'fecha': datetime.now().isoformat(),
    'hostname': run('hostname'),
    'kernel': run('uname -r'),
    'uptime': run('uptime -p'),
    'almacenamiento': {
        'total': int(run(\"stat -f --format='%a' /\")) * int(run(\"stat -f --format='%s' /\")),
    },
    'memoria': {
        'total': int(run(\"free -b | awk '/^Mem:/ {print \$2}'\")),
        'usado': int(run(\"free -b | awk '/^Mem:/ {print \$3}'\")),
        'libre': int(run(\"free -b | awk '/^Mem:/ {print \$4}'\")),
    },
    'modulos': {
        'instalados': 0,
        'actualizables': 0,
        'rotos': 0,
    },
    'paquetes': {
        'total': int(run('pacman -Q | wc -l')),
        'explicitos': int(run('pacman -Qe | wc -l')),
        'actualizaciones_disponibles': int(run('pacman -Qu | wc -l')),
    },
}

with open('$REPORT_FILE', 'w') as f:
    json.dump(report, f, indent=2)
print(f'Report generated: $REPORT_FILE')
"
