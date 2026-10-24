#!/bin/sh

export PATH="$HOME/.local/bin:$PATH"

nitrogen --restore &
dunst &
~/.local/bin/remaps &
picom &
setsid -f eww daemon >/dev/null 2>&1 &	# eww control-center daemon
~/.local/bin/pillontop-loop &	# keep Wispr Flow's override-redirect dictation pill above other windows
( sleep 15 && setsid ~/.local/bin/cliplog ) >/dev/null 2>&1 &	# clipboard → cliphist history
systemctl --user import-environment DISPLAY XAUTHORITY &
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY &
setsid -f dwmblocks &
exec dwm
