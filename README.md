# dotFiles

dwm + X11 dotfiles and a fresh-Arch bootstrap.

## Fresh Arch install

Use `arch-setup.sh` from a normal user account on a working Arch install:

```sh
cd ~/Public/dots/dotFiles
./arch-setup.sh --dry-run     # inspect first
./arch-setup.sh               # core daily-driver profile
```

Optional additive profiles:

```sh
./arch-setup.sh --profile dev
./arch-setup.sh --profile selfhost
./arch-setup.sh --profile media
./arch-setup.sh --profile apps
./arch-setup.sh --profile full
```

The installer uses `sudo` for pacman/systemd, bootstraps `yay-bin`, builds
`dwm`, `dwmblocks`, and `pillontop` into `~/.local/bin`, deploys the configs,
and enables the desktop services. It does not remove packages.

## Deploy configs only

`install.sh` only copies configuration and scripts. It does not install
packages or build binaries.

```sh
./install.sh --dry-run
./install.sh
```

It preserves an existing `~/.config/zsh/envs` because that file can contain
secrets. A fresh machine gets the sanitized repo copy.

## Package audit

See [`PACKAGE-AUDIT.md`](PACKAGE-AUDIT.md) for the 225-package audit, the
core/optional split, the 50 removal candidates, and known broken references.

Curated lists live in `packages/`. `pacman.csv` is an old 2024 snapshot and is
not used by the installer.

## Manual steps after setup

1. Log out and back in, then run `startx` from tty1.
2. Set a wallpaper with `nitrogen --set-zoom-fill --save /path/to/image`.
3. Build the lockscreen cache with `betterlockscreen -u /path/to/image`.
4. Import the Telegram theme once from
   `~/.local/share/telegram-themes/nordic.tdesktop-theme`.
5. If eww brightness does not work, make sure `/usr/bin/light` is setuid:
   `sudo chmod u+s /usr/bin/light` (or change the script to `brightnessctl`).
6. Edit `~/.config/mpd/mpd.conf` if `music_directory` is not
   `/mnt/Games/Songs`, then start `mpd`/`mpc`.
7. Authenticate Bitwarden manually. Never commit `BW_SESSION`.
