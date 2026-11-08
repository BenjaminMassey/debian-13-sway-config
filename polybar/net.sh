#!/bin/sh
# Prints one network status: an up wired link wins, then an up wireless link,
# otherwise whichever kind of hardware exists is shown as disconnected.
# Only physical interfaces (with a device link) count, so lo/docker/veth are skipped.
wired=; wireless=
for i in /sys/class/net/*; do
    [ -e "$i/device" ] || continue
    state=$(cat "$i/operstate")
    if [ -d "$i/wireless" ]; then
        [ "$wireless" = up ] || wireless=$state
    else
        [ "$wired" = up ] || wired=$state
    fi
done

on='%{F#F0C674}'; off='%{F#707880}'
if   [ "$wired" = up ];    then echo "${on}Wired%{F-} connected"
elif [ "$wireless" = up ]; then echo "${on}Wireless%{F-} connected"
elif [ -n "$wired" ];      then echo "${on}Wired${off} disconnected"
elif [ -n "$wireless" ];   then echo "${on}Wireless${off} disconnected"
else                            echo "${off}no network"
fi
