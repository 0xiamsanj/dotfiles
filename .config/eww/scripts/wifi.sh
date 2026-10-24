#!/bin/bash
# eww wifi listener — NetworkManager via nmcli (prints only on SSID change).

get_wifi() {
    ssid=$(nmcli -t -f NAME,TYPE connection show --active 2>/dev/null \
        | awk -F: '$2=="802-11-wireless" {print $1; exit}')
    [ -n "$ssid" ] && echo "$ssid" || echo "Off"
}

prev=""
cur=""
while :; do
    cur=$(get_wifi)
    [ "$cur" = "$prev" ] || { echo "$cur"; prev=$cur; }
    sleep 3
done
