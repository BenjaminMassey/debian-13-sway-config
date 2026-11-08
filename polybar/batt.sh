#!/bin/sh
# Prints combined battery percentage, or nothing at all on machines without a
# system battery (polybar hides a custom/script module whose output is empty).
# Peripheral batteries (mice, headsets) report scope=Device and are skipped.
# Multiple batteries (e.g. ThinkPad BAT0+BAT1) are weighted by their capacity.
now=0; full=0; status=
for b in /sys/class/power_supply/*; do
    [ "$(cat "$b/type" 2>/dev/null)" = Battery ] || continue
    [ "$(cat "$b/scope" 2>/dev/null)" = Device ] && continue
    [ "$(cat "$b/present" 2>/dev/null || echo 1)" = 1 ] || continue
    if   [ -r "$b/energy_full" ]; then n=$(cat "$b/energy_now"); f=$(cat "$b/energy_full")
    elif [ -r "$b/charge_full" ]; then n=$(cat "$b/charge_now"); f=$(cat "$b/charge_full")
    elif [ -r "$b/capacity" ];    then n=$(cat "$b/capacity");   f=100
    else continue
    fi
    now=$((now + n)); full=$((full + f))
    # any battery charging/discharging is more interesting than Full/Not charging
    s=$(cat "$b/status" 2>/dev/null)
    case "$s" in Charging|Discharging) status=$s ;; *) [ -n "$status" ] || status=$s ;; esac
done

[ "$full" -gt 0 ] || exit 0
pct=$((now * 100 / full)); [ "$pct" -gt 100 ] && pct=100

# Plugged in if any mains/USB supply is online; if the machine exposes none,
# fall back to the battery status (anything but Discharging means on power).
plugged=
for a in /sys/class/power_supply/*; do
    case "$(cat "$a/type" 2>/dev/null)" in Mains|USB|USB_C|USB_PD) ;; *) continue ;; esac
    [ -r "$a/online" ] || continue
    plugged=${plugged:-0}
    [ "$(cat "$a/online")" = 1 ] && plugged=1
done
[ -n "$plugged" ] || { [ "$status" = Discharging ] && plugged=0 || plugged=1; }
[ "$plugged" = 1 ] && label=Plugged || label=Unplugged

on='%{F#F0C674}'; alert='%{F#A54242}'
if [ "$plugged" = 0 ] && [ "$pct" -le 15 ]; then
    echo "${alert}${label} ${pct}%%{F-}"
elif [ "$status" = Charging ]; then
    echo "${on}${label}%{F-} ${pct}%+"
else
    echo "${on}${label}%{F-} ${pct}%"
fi
