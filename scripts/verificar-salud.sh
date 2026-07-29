#!/usr/bin/env bash
# LNOS Health Check
# Section 83.3 of LNOS Specification
set -euo pipefail

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }
REPORT_DIR="/var/log/lnos/health"
mkdir -p "$REPORT_DIR"

REPORT_FILE="${REPORT_DIR}/health-$(date +%Y%m%d-%H%M%S).json"

log "=== LNOS Health Check ==="

# 1. Btrfs scrub status
BTRFS_STATUS="ok"
if command -v btrfs &>/dev/null; then
    SCRUB_OUTPUT=$(btrfs scrub status / 2>/dev/null || echo "no btrfs")
    if echo "$SCRUB_OUTPUT" | grep -q "error"; then
        BTRFS_STATUS="errors_found"
    fi
fi

# 2. SMART check
SMART_STATUS=()
for dev in /dev/sd? /dev/nvme?n?; do
    [ -e "$dev" ] || continue
    SMART_RESULT=$(smartctl -H "$dev" 2>/dev/null | grep "SMART overall-health" || echo "not_available")
    SMART_STATUS+=("$(echo $SMART_RESULT | awk '{print $NF}')")
done

# 3. Journal errors
ERR_COUNT=$(journalctl -p 3 -b --no-pager 2>/dev/null | wc -l || echo 0)
ERR_RECENT=$(journalctl -p 3 -b --no-pager -n 5 2>/dev/null || true)

# 4. Temperature
CPU_TEMP=""
GPU_TEMP=""
if command -v sensors &>/dev/null; then
    CPU_TEMP=$(sensors -j 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print([v for k,v in d.items() if 'coretemp' in k.lower() or 'k10temp' in k.lower()][0].get('temp1',{}).get('temp1_input',0))" 2>/dev/null || echo "N/A")
    GPU_TEMP=$(sensors -j 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print([v for k,v in d.items() if 'amdgpu' in k.lower() or 'i915' in k.lower()][0].get('temp1',{}).get('temp1_input',0))" 2>/dev/null || echo "N/A")
fi

# 5. Memory
MEM_TOTAL=$(free -b | awk '/^Mem:/ {print $2}')
MEM_USED=$(free -b | awk '/^Mem:/ {print $3}')
MEM_FREE=$(free -b | awk '/^Mem:/ {print $4}')

# 6. Uptime
UPTIME=$(uptime -p)
KERNEL=$(uname -r)

# Generate JSON report
python3 -c "
import json
report = {
    'date': '$(date -Iseconds)',
    'hostname': '$(hostname)',
    'kernel': '$KERNEL',
    'uptime': '$UPTIME',
    'storage': {
        'btrfs_scrub': '$BTRFS_STATUS',
    },
    'memory': {
        'total': $MEM_TOTAL,
        'used': $MEM_USED,
        'free': $MEM_FREE,
    },
    'health': {
        'btrfs_scrub_status': '$BTRFS_STATUS',
        'smart_status': $(python3 -c "print($(echo ${SMART_STATUS[@]} | sed 's/ /,/g'))" 2>/dev/null || echo '[]'),
        'journal_errors_count': $ERR_COUNT,
        'temperature_cpu': '$CPU_TEMP',
        'temperature_gpu': '$GPU_TEMP',
    },
}
with open('$REPORT_FILE', 'w') as f:
    json.dump(report, f, indent=2)
print('Report saved to $REPORT_FILE')
"

log "Health check complete"
