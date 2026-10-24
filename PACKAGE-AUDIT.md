# Package audit and fresh-Arch setup

Audit date: 2026-10-24  
Host: current Arch install, dwm session  
Source of truth: `pacman -Qqe` / `pacman -Qqm`, plus dotfiles, dwm keybinds, helper scripts, and shell history.

## Summary

| Bucket | Count | Notes |
|---|---:|---|
| Explicit packages | 225 | `pacman -Qqe` |
| Foreign/AUR packages | 42 | `pacman -Qqm`; mostly intentional |
| Orphans | 0 | `pacman -Qtdq` returned nothing |
| Keep: core daily workflow | 90 | default `core` profile |
| Keep: dev profile | 32 | compilers, IDEs, databases |
| Keep: self-host profile | 16 | Docker/libvirt/Jellyfin/etc. |
| Keep: media profile | 11 | VLC/qBittorrent/CAVA/GStreamer |
| Keep: apps profile | 21 | browsers, office, chat, notes |
| Conditional: boot/disk | 5 | install only with `--with-boot` |
| Removal candidates | 50 | review only; nothing is removed automatically |

The current 225 explicit packages are not a good fresh-install target. Several are
one-off experiments, duplicates, debug symbols, old themes/fonts, or incomplete
toolchains. The new installer installs a curated core plus optional profiles.

Foreign/AUR inventory (42): `ani-cli`, `antigravity`, `antigravity-ide`,
`anydesk-bin`, `betterlockscreen`, `blueberry`, `brave-bin`, `cloudflared-bin`,
`debtap`, `figma-linux`, `fladder-bin`, `gnome-bluetooth`,
`gnome-bluetooth-debug`, `gtk2`, `gtkmm`, `helium-browser-bin`, `htop-vim`,
`i3lock-color`, `ibus-m17n`, `localsend-bin`, `material-black-colors-theme`,
`microsoft-openjdk-17-bin`, `miraclecast-git`, `moonfin-bin`, `neofetch`,
`nitrogen`, `ntfsfixboot`, `opencode-desktop-bin`, `pi-agent-rust`,
`postman-bin`, `redisinsight`, `rose-pine-gtk-theme`, `sonarqube-bin`,
`telegram-desktop-bin`, `thorium-browser-bin`, `tokyonight-gtk-theme-git`,
`ttf-segoe-ui-variable`, `visual-studio-code-bin`, `wispr-flow-appimage`,
`yay`, `zen-browser-bin`, `zennotes-bin`.

`gnome-bluetooth`, `gtk2`, and `gtkmm` are dependency-layer packages, not
day-to-day apps. `nitrogen` is now correctly in `core-aur.txt`; `yay` is
bootstrapped by the installer rather than installed from a static list.

## How this was classified

Evidence used:

- `dwm` keybinds in `.local/dwm/config.h`
- `dwmblocks` block list and scripts in `~/.local/bin`
- `.xinitrc`, `.zshrc`, aliases, and `~/.local/bin` helpers
- app configs in `~/.config` (Alacritty, tmux, rofi, dunst, eww, nvim, lf, mpd,
  ncmpcpp, cava, mpv, zathura, btop, superfile, Zed, ZenNotes, Telegram)
- `~/.cache/zsh/history` for actual command usage
- current package set, package ownership, and `command -v` checks

This is a workflow audit, not a claim that every optional package is unused.
Anything marked "remove candidate" should be checked against your own use first.

## Keep: core daily workflow (90 explicit)

This is the default profile in `packages/core.txt` plus `packages/core-aur.txt`.
It covers the dwm session, terminal, launcher, notifications, clipboard, audio,
music/video/documents, file management, fonts, themes, and the daily apps.

`alacritty`, `base`, `base-devel`, `betterlockscreen`, `blueberry`, `bluez`,
`bluez-utils`, `btop`, `cliphist`, `dunst`, `electron`, `flameshot`, `fzf`,
`git`, `gitui`, `gnome-disk-utility`, `gvfs`, `gvfs-mtp`, `inetutils`,
`inotify-tools`, `lf`, `linux`, `linux-firmware`, `lxappearance`, `make`,
`man-db`, `man-pages`, `mpc`, `mpd`, `mpv`, `ncmpcpp`, `neovim`,
`networkmanager`, `nitrogen`, `noto-fonts`, `noto-fonts-emoji`, `npm`, `nsxiv`,
`nvidia-open`, `nvidia-settings`, `opencode-desktop-bin`, `pass`, `picom`,
`pipewire-alsa`, `pipewire-pulse`, `pnpm`, `pulsemixer`, `rofi`, `rsync`,
`sudo`, `telegram-desktop-bin`, `thorium-browser-bin`, `thunar`,
`thunar-volman`, `tmux`, `tokyonight-gtk-theme-git`, `ttf-dejavu`,
`ttf-ibm-plex`, `ttf-jetbrains-mono-nerd`, `ttf-segoe-ui-variable`, `tumbler`,
`ueberzug`, `unrar`, `unzip`, `upower`, `usbutils`, `wget`, `wireless_tools`,
`wispr-flow-appimage`, `xcape`, `xclip`, `xdg-desktop-portal`,
`xdg-desktop-portal-gtk`, `xdotool`, `xorg-server`, `xorg-server-common`,
`xorg-xbacklight`, `xorg-xinit`, `xorg-xinput`, `xorg-xrandr`, `xorg-xset`,
`xwallpaper`, `yay`, `zathura`, `zathura-pdf-poppler`, `zathura-ps`, `zip`,
`zsh`, `zsh-autosuggestions`, `zsh-syntax-highlighting`.

Required additions that were not explicit packages (now in the core package
lists, `packages/core.txt` and `packages/core-aur.txt`):

- `bc`, `jq` - eww scripts and shell helpers
- `eww` (`eww-git` from AUR) - control center
- `python` - eww Python scripts
- `ripgrep`, `fd` - Neovim/Telescope
- `ffmpeg`, `imagemagick`, `xorg-xdpyinfo` - recording, cover art, lockscreen
- `psmisc` - `pstree` in `sysact`
- `xorg-setxkbmap`, `xorg-xrdb` - `remaps` and `Mod+F5`
- `alsa-utils`, `arandr`, `slop`, `light` - `headset`, `displayselect`,
  `dmenurecord`, eww brightness
- `pipewire`, `wireplumber`, `libnotify`, `udisks2`, `xdg-user-dirs`,
  `xdg-utils`, `gnome-themes-extra`, `adwaita-icon-theme`
- `libx11`, `libxft`, `libxinerama`, `freetype2`, `fontconfig`, `libxcb` -
  building dwm/dmenu/dwmblocks

## Keep: optional profiles

### Dev (32)

`android-tools`, `antigravity`, `antigravity-ide`, `bun`, `chrpath`, `clang`,
`cmake`, `dbeaver`, `docbook-xsl`, `doxygen`, `gdb`, `go`,
`gobject-introspection`, `gtk-doc`, `kotlin`, `meson`,
`microsoft-openjdk-17-bin`, `pi-agent-rust`, `postman-bin`, `protobuf`,
`python-dbusmock`, `python-pip`, `python-pytest`, `rainfrog`, `redisinsight`,
`rustup`, `sonarqube-bin`, `uv`, `valgrind`, `visual-studio-code-bin`, `yasm`,
`zig`.

Use `--profile dev`. The profile is intentionally broad because the current
workflow includes Rust, Go, Zig, Java/Android, Python, Node/Bun, database tools,
and several AI/dev IDEs.

### Self-host (16)

`cloudflared-bin`, `copyparty`, `croc`, `dnsmasq`, `docker`, `docker-compose`,
`jellyfin-server`, `jellyfin-web`, `kafka`, `libvirt`, `postgresql`, `rclone`,
`syncthing`, `tailscale`, `ufw`, `virt-manager`.

Use `--profile selfhost`. `dnsmasq` is kept here because libvirt's default
network uses it. The installer also adds `qemu-full`, `edk2-ovmf`, `swtpm`, and
`openssh`; the currently installed `qemu-*` set is incomplete for normal x86
virtualization.

### Media (11)

`cava`, `fladder-bin`, `gst-libav`, `gst-plugins-bad`, `gst-plugins-good`,
`gst-plugins-ugly`, `moonfin-bin`, `qbittorrent`, `vlc`, `vlc-plugins-all`,
`yazi`.

Use `--profile media`. `mpv`, `ncmpcpp`, `mpd`, `zathura`, and `nsxiv` are
already in core.

### Apps (21)

`ani-cli`, `anydesk-bin`, `bitwarden`, `brave-bin`, `discord`, `figma-linux`,
`glow`, `helium-browser-bin`, `htop-vim`, `inkscape`, `keepassxc`,
`libreoffice-fresh`, `localsend-bin`, `ncdu`, `neofetch`, `obsidian`,
`playerctl`, `speedtest-cli`, `thunderbird`, `zen-browser-bin`, `zennotes-bin`.

Use `--profile apps`. The installer also adds `zed` and `superfile` (official
packages) because their configs are in the repo. `brave-bin` is kept because
`Mod+Shift+d` is bound to Brave; if you drop that keybind, drop Brave.

## Conditional: boot/disk (5)

`dosfstools`, `efibootmgr`, `grub`, `ntfs-3g`, `os-prober`.

These depend on the machine layout and bootloader. Use `--with-boot` only if
GRUB/EFI/NTFS is appropriate. A fresh Arch install already has a working
bootloader before this script is run; the script does not configure one.

## Removal candidates (50)

These are not installed by `arch-setup.sh`. Review before removing. The most
defensible removals are duplicates, debug symbols, and legacy Xorg/test packages.

### Duplicate or unused desktop tools

- `bemenu`, `bemenu-x11` - `rofi` plus the `dmenu` bridge is the active launcher.
- `copyq`, `gpaste` - `cliphist` + `xclip` are the active clipboard path.
- `sxiv` - `nsxiv` is used by `rotdir`.
- `maim`, `scrot` - `flameshot` is the bound screenshot tool; `slop` is for
  recording.
- `eza` - not referenced; aliases use `ls`.
- `vim` - `vi` is aliased to Neovim.
- `ibus-m17n` - no input-method configuration or usage evidence.

### Redundant torrent clients

- `transmission-qt`, `deluge`, `rtorrent` - `qbittorrent` is the used client.
- `qbittorrent-nox` - GUI qBittorrent is the used client.

### Old themes and fonts

- `material-black-colors-theme`, `rose-pine-gtk-theme` - replaced by Nordic /
  Tokyonight.
- `ttf-cascadia-code`, `ttf-cascadia-code-nerd` - current fonts are JetBrains
  Mono Nerd, IBM Plex, DejaVu, and Segoe UI.
- `woff2-font-awesome` - not referenced by the current eww/UI configs.

### Legacy Xorg, test, and font utilities

- `xf86-video-vesa` - fallback driver; current session uses NVIDIA.
- `xorg-server-xephyr`, `xorg-x11perf` - test/benchmark tools.
- `xorg-font-util`, `xorg-fonts-100dpi` - not used by the current font stack.
- `xorg-xsetroot`, `xorg-xwininfo` - not referenced; `nitrogen`/`xwallpaper`
  handle the desktop.

### Debug/build leftovers

- `gnome-bluetooth-debug` - detached debug symbols; `blueberry` needs
  `gnome-bluetooth`, not the debug package.
- `dejagnu`, `expect`, `tcl` - build/test dependencies, not workflow tools.
- `eclipse-ecj`, `gcc-ada`, `gcc-d` - no Ada/D/ECJ workflow evidence.
- `chrpath` is kept in dev because it is a normal packaging helper.

### Incomplete or unused virtualization/experiments

- `qemu-system-riscv`, `qemu-tests`, `qemu-tools`, `qemu-user` - no normal
  x86 QEMU stack; use `qemu-full` in the selfhost profile instead.
- `virtualbox-host-dkms` - libvirt/QEMU is the current virtualization path.
- `debtap` - no `.deb` conversion workflow.
- `bleachbit` - not referenced.
- `cyme`, `ddcutil` - no USB-C/DDC hardware workflow evidence.
- `miraclecast-git`, `netstat-nat` - no active use.
- `mtools`, `ntfsprogs`, `ntfsfixboot` - legacy/duplicative disk tools;
  `ntfs-3g` is the conditional package that is actually useful.
- `vlc-plugin-mad`, `vlc-plugin-x264`, `vlc-plugin-x265` - already covered by
  `vlc-plugins-all`.

## Broken or missing references found during the audit

These are separate from the package audit: the configs reference commands that
are not installed or scripts that do not exist in the repo.

| Reference | Used by | Status / recommendation |
|---|---|---|
| `arandr` | `~/.local/bin/displayselect` | missing; now in core |
| `amixer` | `~/.local/bin/headset` | `alsa-utils` missing; now in core |
| `slop` | `dmenurecord`, eww record | missing; now in core |
| `ffmpeg` | ncmpcpp cover, eww record | present as dependency; now explicit |
| `jq`, `bc` | eww scripts | present as dependencies; now explicit |
| `light` | eww brightness | missing; AUR `light` added to core |
| `imagemagick`, `xorg-xdpyinfo` | `betterlockscreen` | dependencies; now explicit |
| `psmisc` | `sysact` (`pstree`) | present as dependency; now explicit |
| `xorg-setxkbmap` | `remaps` | present; now explicit |
| `xorg-xrdb` | `Mod+F5` | present; now explicit |
| `python` | eww scripts | present; now explicit |
| `ripgrep`, `fd` | Neovim/Telescope | present; now explicit |
| `mmsg` | eww `control_center` Wayland branch | not needed for dwm/X11; the X11 branch now calls `eww` directly |
| `redshift` | eww red-light script | optional; not installed |
| `vibrant-cli` | eww grayscale script | optional AUR; not installed |
| `android-studio-beta` | `Mod+Shift+c` | missing; keybind is broken |
| `abook` | `Mod+Shift+e` | missing; keybind is broken |
| `torwrap`, `td-toggle`, `mailsync`, `mounter`, `unmounter`, `tutorialvids`, `pauseallmpv` | dwm `F6`-`F10` / `Mod+Shift+p` | scripts absent from repo; keybinds are broken |
| `sb-mpdup` | `~/.local/bin/music` | missing; music block is commented out in dwmblocks |
| `sb_battery` | eww battery icon script | missing |
| `~/pix/assets/icons/heart-solid.svg` | eww music widget | missing asset |
| `~/dox/...` | eww quote/timeslot scripts | missing directories |

Also missing from the repo but present in the live `~/.local/bin`: `headset`,
`spotify`, `thorium-browser`, `pkgman`, `zenn`, `md-viewer`, and some external
tool symlinks. A fresh install gets the packaged apps, but not these local
wrappers. Add them to the repo if you rely on them.

`dmenuunicode` and the snippet keybind also depend on `~/.local/share/larbs`
emoji/snippet files; those are not in this repo.

## Stale artifacts

- `pacman.csv` is a 2024 full package snapshot, not the current audit. It still
  lists old choices such as `linux-zen`, `pulseaudio`, `feh`, and `sxiv`. Do not
  use it for a fresh install; `packages/` is the maintained source.
- The old `install.sh` package line was replaced. The current `install.sh` only
  deploys config and deliberately excludes runtime state.
- `slstatus` source is unused; `dwmblocks` is the active status bar.
- The real `dmenu` source is built as `dmenu.real`; the active `dmenu` command is
  the rofi bridge. This keeps old dmenu scripts working with the Nordic rofi UI.
- `dwm` and `dwmblocks` are built into `~/.local/bin`; no `/usr/local` install is
  needed.

## Fresh-install usage

```sh
cd ~/Public/dots/dotFiles

# Inspect first
./arch-setup.sh --dry-run

# Core daily driver
./arch-setup.sh

# Add optional profiles (core is included automatically)
./arch-setup.sh --profile dev
./arch-setup.sh --profile selfhost
./arch-setup.sh --profile media
./arch-setup.sh --profile apps
./arch-setup.sh --profile full

# Add boot/disk packages if appropriate
./arch-setup.sh --with-boot
```

The installer:

1. Installs base build prerequisites and bootstraps `yay-bin` from the AUR.
2. Installs the selected official/AUR package lists.
3. Builds `dwm`, `dwmblocks`, and `pillontop` from the repo into
   `~/.local/bin`.
4. Runs `install.sh` to deploy configs and scripts.
5. Copies the Telegram theme asset, changes the login shell to zsh, and enables
   NetworkManager, Bluetooth, PipeWire, MPD, and profile-specific services.
6. Prints verification and manual next steps.

Nothing is removed. `install.sh` preserves an existing `~/.config/zsh/envs`
because it can contain secrets; a fresh install gets the sanitized repo copy.

## Security note

`BW_SESSION` was committed in `0082466` on `origin/main` and is still in the
public history. The working tree and repo copy are sanitized, but the history is
not. Rotate the Bitwarden session token and, if desired, clean history with
`git filter-repo` before force-pushing. Do not commit a new token.

## Suggested removal workflow (manual)

After reviewing, remove in small groups and test the session:

```sh
# Example only; do not paste the whole list blindly.
sudo pacman -Rns bemenu bemenu-x11 copyq gpaste sxiv maim scrot eza vim
sudo pacman -Rns transmission-qt deluge rtorrent qbittorrent-nox
sudo pacman -Rns material-black-colors-theme rose-pine-gtk-theme
sudo pacman -Rns ttf-cascadia-code ttf-cascadia-code-nerd woff2-font-awesome
sudo pacman -Rns xf86-video-vesa xorg-server-xephyr xorg-x11perf xorg-font-util xorg-fonts-100dpi
sudo pacman -Rns qemu-system-riscv qemu-tests qemu-tools qemu-user
```

Then check:

```sh
pacman -Qtdq
sudo pacman -Rns $(pacman -Qtdq)
```

Keep `blueberry` (used by `~/.local/bin/bluetooth`) and keep `dnsmasq` if you
use libvirt's default network.
