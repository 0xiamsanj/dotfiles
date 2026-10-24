#!/bin/bash
# eww volume listener — PulseAudio/PipeWire via pactl (no pamixer needed).

get_vol() {
    pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null \
        | awk 'NR==1 { gsub("%",""); print $5; exit }'
}

get_vol
pactl subscribe | grep --line-buffered "sink" | while read -r _; do
    get_vol
done
