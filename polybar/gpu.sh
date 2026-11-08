#!/bin/sh
# Usage: gpu.sh busy|vram  — reads AMD GPU stats from sysfs
# card index can change between boots, so glob for it
dev=$(dirname "$(ls /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | head -n1)")
[ -r "$dev/gpu_busy_percent" ] || { echo "n/a"; exit 0; }

case "$1" in
    busy) printf '%2d%%\n' "$(cat "$dev/gpu_busy_percent")" ;;
    vram) awk -v u="$(cat "$dev/mem_info_vram_used")" -v t="$(cat "$dev/mem_info_vram_total")" \
              'BEGIN { printf "%2d%%\n", u * 100 / t }' ;;
esac
