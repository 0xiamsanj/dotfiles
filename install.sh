#!/bin/sh

mkdir $HOME/.local/source
cp -r .local/dwm/ .local/dmenu/ .local/slstatus/ $HOME/.local/source/
cp -r .config/ $HOME/.config
cp -r .local/bin $HOME/.local/bin
cp -r .xinitrc .zshrc $HOME/
pacman -S --noconfirm curl wget mpc mpv mpd ncmpcpp pulseaudio make clang go thunar thunar-volman gvfs gvfs-mtp nvidia nvidia-settings \
    xorg-xinit xorg-server xorg-xrandr xorg-xbacklight xorg-xinput xorg-xsetroot xorg-x11perf xorg-font-util zsh zsh-autosuggestions\
    zsh-syntax-highlighting zathura telegram-desktop tmux sxiv feh nitrogen neofetch xclip pass bluez bluez-utils base-devel \
    blueberry wireless_tools picom ttf-jetbrains-mono-nerd ttf-segoe-ui-variable \

make clean install $HOME/.local/source/dwm
make clean install $HOME/.local/source/slstatus
make clean install $HOME/.local/source/dmenu
