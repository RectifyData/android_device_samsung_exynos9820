#!/sbin/sh
# Pre-flash guard for the LineageOS-layout super. READ-ONLY: never writes to the disk.
# Super is carved from the physical system partition, so only that size is checked.
# Exits 1 on any mismatch so the flash script stops before anything is written.
#
# Usage: sh retrofit_precheck.sh [/dev/block/sda]

DISK="${1:-/dev/block/sda}"
SGDISK=sgdisk

# Stock BEYOND2LTE_EUR_OPEN.pit SYSTEM size (1459200 blocks x 4096 bytes).
# Keep in sync with BOARD_SUPER_PARTITION_SIZE in BoardConfig.mk.
EXPECT_system=5976883200

SECTOR=$(blockdev --getss "$DISK" 2>/dev/null)
[ -z "$SECTOR" ] && SECTOR=512

$SGDISK --print "$DISK" > /tmp/precheck_raw.txt 2>&1 || {
    echo "PRECHECK FAILED: cannot read GPT from $DISK. Nothing was written."; exit 1; }

got=$(awk -v ss="$SECTOR" '
    $1 ~ /^[0-9]+$/ && NF >= 6 && $NF == "system" { print ($3 - $2 + 1) * ss; exit }' /tmp/precheck_raw.txt)

if [ -z "$got" ]; then
    echo "MISSING  system: no partition named system on $DISK"
    echo "PRECHECK FAILED. Nothing was written."; exit 1
fi
if [ "$got" != "$EXPECT_system" ]; then
    echo "MISMATCH system: disk has $got bytes, build expects $EXPECT_system"
    echo "PRECHECK FAILED. Nothing was written."; exit 1
fi
echo "OK       system: $got bytes"
echo "PRECHECK PASSED: system matches the build. Safe to continue."
exit 0
