#!/sbin/sh
# Pre-flash guard for the retrofit build. READ-ONLY: it never writes to the disk.
# It reads the device's GPT, compares the sizes with the values the build expects,
# and exits 1 on any mismatch so the flash script stops before anything is written.
#
# Usage: sh retrofit_precheck.sh [/dev/block/sda]

DISK="${1:-/dev/block/sda}"
SGDISK=sgdisk

# Expected sizes in bytes, from the stock BEYOND2LTE_EUR_OPEN.pit (4096-byte blocks).
# Keep these in sync with BoardConfig.mk.
EXPECT_system=5976883200
EXPECT_vendor=1153433600
EXPECT_product=650117120

SECTOR=$(blockdev --getss "$DISK" 2>/dev/null)
[ -z "$SECTOR" ] && SECTOR=512

$SGDISK --print "$DISK" > /tmp/precheck_raw.txt 2>&1 || {
    echo "PRECHECK FAILED: cannot read GPT from $DISK. Nothing was written."; exit 1; }

FAIL=0
for p in system vendor product; do
    eval expect=\$EXPECT_$p
    got=$(awk -v n="$p" -v ss="$SECTOR" '
        $1 ~ /^[0-9]+$/ && NF >= 6 && $NF == n { print ($3 - $2 + 1) * ss; exit }' /tmp/precheck_raw.txt)
    if [ -z "$got" ]; then
        echo "MISSING  $p: no partition with that name on $DISK"; FAIL=1
    elif [ "$got" != "$expect" ]; then
        echo "MISMATCH $p: disk has $got bytes, build expects $expect"; FAIL=1
    else
        echo "OK       $p: $got bytes"
    fi
done

if [ "$FAIL" -ne 0 ]; then
    echo "PRECHECK FAILED: partition layout differs from the build. Nothing was written."
    exit 1
fi
echo "PRECHECK PASSED: layout matches the build. Safe to continue."
exit 0
