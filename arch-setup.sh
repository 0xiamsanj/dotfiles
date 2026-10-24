#!/usr/bin/env bash
# arch-setup.sh - bootstrap a fresh Arch Linux install for the dwm workflow
# stored in this dotfiles repository.
#
# Defaults to the core daily-driver profile. Optional profiles are additive:
#
#   ./arch-setup.sh                         # core only
#   ./arch-setup.sh --profile dev           # core + dev
#   ./arch-setup.sh --profile selfhost      # core + self-hosted services
#   ./arch-setup.sh --profile media         # core + extra media tools
#   ./arch-setup.sh --profile apps          # core + optional desktop apps
#   ./arch-setup.sh --profile full          # core + dev + selfhost + media + apps
#
# Use --dry-run first. The script does not remove packages and does not touch
# ~/Public/dots/dotFiles-mirror.

set -Eeuo pipefail

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
PROFILES=(core)
SELECTED=()
DRY_RUN=0
NO_PACKAGES=0
NO_BUILD=0
NO_CONFIG=0
NO_SERVICES=0
WITH_BOOT=0

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<'EOF'
Usage: ./arch-setup.sh [options]

Profiles (additive; core is always included):
  --profile core       Daily dwm desktop and core apps (default)
  --profile dev        Compilers, language toolchains, IDEs, dev databases
  --profile selfhost   Docker, libvirt/QEMU, Jellyfin, PostgreSQL, Tailscale
  --profile media      Cava, VLC, qBittorrent, yazi, GStreamer extras
  --profile apps       Browsers, office, chat, note apps, extra utilities
  --profile full       All profiles

Options:
  --with-boot          Also install GRUB/EFI/NTFS/disk utilities
  --dry-run            Print commands without changing the system
  --no-packages        Skip pacman/yay package installation
  --no-build           Skip dwm/dwmblocks/pillontop builds
  --no-config          Skip install.sh (dotfile deployment)
  --no-services        Skip enabling NetworkManager/Bluetooth/audio/MPD services
  -y, --yes            Accepted for convenience; package commands are noninteractive
  -h, --help           Show this help

Before running:
  1. Boot the Arch ISO, install base + a kernel + sudo, create your user, and
     make sure GRUB/systemd-boot is already working.
  2. Log in as your normal user (not root) and run this script from the repo.
  3. Use --dry-run first if you want to inspect every command.

Not handled automatically: wallpaper selection, betterlockscreen cache,
Telegram theme import, Bitwarden login, external self-hosted repositories,
and any manually installed binaries not packaged in this repo.
EOF
}

while (($#)); do
    case "$1" in
        --profile)
            (($# >= 2)) || die "--profile needs a value"
            PROFILES+=("$2")
            shift 2
            ;;
        --with-boot) WITH_BOOT=1; shift ;;
        --dry-run) DRY_RUN=1; shift ;;
        --no-packages) NO_PACKAGES=1; shift ;;
        --no-build) NO_BUILD=1; shift ;;
        --no-config) NO_CONFIG=1; shift ;;
        --no-services) NO_SERVICES=1; shift ;;
        -y|--yes) shift ;;
        -h|--help) usage; exit 0 ;;
        *) die "unknown option: $1 (try --help)" ;;
    esac
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

run() {
    if ((DRY_RUN)); then
        printf '+'
        printf ' %q' "$@"
        printf '\n'
    else
        "$@"
    fi
}

pkg_names_from_file() {
    local file=$1
    [ -f "$file" ] || die "missing package list: $file"
    sed -e 's/#.*//' -e 's/[[:space:]]//g' "$file" | grep -v '^$' || true
}

install_official_file() {
    local file=$1
    local -a pkgs=()
    local p
    while IFS= read -r p; do
        [ -n "$p" ] && pkgs+=("$p")
    done < <(pkg_names_from_file "$file")
    ((${#pkgs[@]})) || return 0
    log "Installing official packages: ${file#"$REPO_DIR"/}"
    if ((DRY_RUN)); then
        printf '+ sudo pacman -S --needed --noconfirm'
        printf ' %q' "${pkgs[@]}"
        printf '\n'
    else
        sudo pacman -S --needed --noconfirm "${pkgs[@]}"
    fi
}

install_official_names() {
    local -a pkgs=("$@")
    ((${#pkgs[@]})) || return 0
    log "Installing official prerequisites: ${pkgs[*]}"
    if ((DRY_RUN)); then
        printf '+ sudo pacman -S --needed --noconfirm'
        printf ' %q' "${pkgs[@]}"
        printf '\n'
    else
        sudo pacman -S --needed --noconfirm "${pkgs[@]}"
    fi
}

bootstrap_yay() {
    if command -v yay >/dev/null 2>&1; then
        return 0
    fi
    if ((DRY_RUN)); then
        printf '+ git clone --depth=1 https://aur.archlinux.org/yay-bin.git <tmp>/yay-bin\n'
        printf '+ (cd <tmp>/yay-bin && makepkg -si --noconfirm)\n'
        return 0
    fi
    log "Bootstrapping yay (AUR helper)"
    local tmp
    tmp=$(mktemp -d)
    if ! git clone --depth=1 https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"; then
        rm -rf "$tmp"
        die "failed to clone yay-bin"
    fi
    if ! (cd "$tmp/yay-bin" && makepkg -si --noconfirm); then
        rm -rf "$tmp"
        die "failed to build yay-bin"
    fi
    rm -rf "$tmp"
}

install_aur_file() {
    local file=$1
    local -a pkgs=()
    local p
    while IFS= read -r p; do
        [ -n "$p" ] && pkgs+=("$p")
    done < <(pkg_names_from_file "$file")
    ((${#pkgs[@]})) || return 0
    bootstrap_yay
    log "Installing AUR packages: ${file#"$REPO_DIR"/}"
    if ((DRY_RUN)); then
        printf '+ yay -S --needed --noconfirm'
        printf ' %q' "${pkgs[@]}"
        printf '\n'
    else
        yay -S --needed --noconfirm "${pkgs[@]}"
    fi
}

normalize_profiles() {
    local -a expanded=()
    local p q found
    for p in "${PROFILES[@]}"; do
        case "$p" in
            full) expanded+=(core dev selfhost media apps) ;;
            core|dev|selfhost|media|apps) expanded+=("$p") ;;
            *) die "unknown profile: $p" ;;
        esac
    done
    # core is always part of the result
    expanded+=(core)
    SELECTED=()
    for p in "${expanded[@]}"; do
        found=0
        for q in "${SELECTED[@]:-}"; do
            [ "$p" = "$q" ] && found=1
        done
        ((found)) || SELECTED+=("$p")
    done
}

has_profile() {
    local p
    for p in "${SELECTED[@]}"; do
        [ "$p" = "$1" ] && return 0
    done
    return 1
}

install_profile() {
    case "$1" in
        core)
            install_official_file "$REPO_DIR/packages/core.txt"
            install_aur_file "$REPO_DIR/packages/core-aur.txt"
            ;;
        dev)
            install_official_file "$REPO_DIR/packages/dev.txt"
            install_aur_file "$REPO_DIR/packages/dev-aur.txt"
            ;;
        selfhost)
            install_official_file "$REPO_DIR/packages/selfhost.txt"
            install_aur_file "$REPO_DIR/packages/selfhost-aur.txt"
            ;;
        media)
            install_official_file "$REPO_DIR/packages/media.txt"
            install_aur_file "$REPO_DIR/packages/media-aur.txt"
            ;;
        apps)
            install_official_file "$REPO_DIR/packages/apps.txt"
            install_aur_file "$REPO_DIR/packages/apps-aur.txt"
            ;;
        *) die "internal error: unknown profile $1" ;;
    esac
}

build_local_components() {
    local src="$HOME/.local/source"
    log "Building local dwm/dwmblocks/pillontop components"
    run install -d "$src" "$HOME/.local/bin"
    run install -d "$src/dwm" "$src/dwmblocks" "$src/pillontop" "$src/dmenu"
    run cp -a "$REPO_DIR/.local/dwm/." "$src/dwm/"
    run cp -a "$REPO_DIR/.local/dwmblocks/." "$src/dwmblocks/"
    run cp -a "$REPO_DIR/.local/pillontop/." "$src/pillontop/"

    run make -C "$src/dwm" clean all
    run install -m 755 "$src/dwm/dwm" "$HOME/.local/bin/dwm"

    run make -C "$src/dwmblocks" clean
    run make -C "$src/dwmblocks"
    run install -m 755 "$src/dwmblocks/dwmblocks" "$HOME/.local/bin/dwmblocks"

    run cc -O2 -Wall -Wextra -o "$HOME/.local/bin/pillontop" \
        "$src/pillontop/pillontop.c" -lX11

    # The real dmenu source is kept for reference, but the active `dmenu`
    # command is the rofi bridge deployed by install.sh. Build the real one
    # alongside it so it can be used explicitly if desired.
    if [ -f "$REPO_DIR/.local/dmenu/Makefile" ]; then
        run cp -a "$REPO_DIR/.local/dmenu/." "$src/dmenu/"
        run make -C "$src/dmenu" clean all
        run install -m 755 "$src/dmenu/dmenu" "$HOME/.local/bin/dmenu.real"
    fi
}

enable_system_unit() {
    local unit=$1
    if ! systemctl list-unit-files "$unit" >/dev/null 2>&1; then
        warn "systemd unit not found: $unit"
        return 0
    fi
    if systemctl is-enabled --quiet "$unit" >/dev/null 2>&1; then
        log "Service already enabled: $unit"
        return 0
    fi
    if ! run sudo systemctl enable --now "$unit"; then
        warn "could not enable service: $unit"
    fi
}

enable_services() {
    log "Enabling desktop services"
    enable_system_unit NetworkManager
    enable_system_unit bluetooth

    if ((DRY_RUN)); then
        printf '+ systemctl --user enable --now pipewire pipewire-pulse wireplumber mpd.socket mpd.service\n'
    else
        systemctl --user enable --now pipewire pipewire-pulse wireplumber mpd.socket mpd.service \
            || warn "could not enable one or more user audio/MPD services (run inside a user session)"
    fi

    if has_profile selfhost; then
        enable_system_unit docker.socket
        enable_system_unit libvirtd
        enable_system_unit postgresql
        enable_system_unit tailscaled
        enable_system_unit jellyfin.service
        enable_system_unit sshd
        if ((DRY_RUN)); then
            printf '+ systemctl --user enable --now syncthing\n'
        else
            systemctl --user enable --now syncthing 2>/dev/null \
                || warn "could not enable syncthing user service"
        fi
    fi
}

verify_installation() {
    ((DRY_RUN)) && return 0
    log "Verification"
    local c
    for c in dwm dwmblocks eww rofi dunst picom alacritty tmux zsh ncmpcpp mpv zathura nsxiv btop lf nvim gitui pillontop; do
        if command -v "$c" >/dev/null 2>&1; then
            printf '  ok  %s\n' "$c"
        else
            printf '  MISSING  %s\n' "$c"
        fi
    done
    if command -v fc-list >/dev/null 2>&1 && fc-list 2>/dev/null | grep -qi 'JetBrainsMono Nerd'; then
        printf '  ok  JetBrainsMono Nerd Font\n'
    else
        printf '  MISSING  JetBrainsMono Nerd Font\n'
    fi
    if [ -d /usr/share/themes/Nordic ] || [ -d "$HOME/.themes/Nordic" ]; then
        printf '  ok  Nordic GTK theme\n'
    else
        printf '  MISSING  Nordic GTK theme\n'
    fi
    if [ -d /usr/share/icons/Tokyonight-Dark ] || [ -d "$HOME/.icons/Tokyonight-Dark" ]; then
        printf '  ok  Tokyonight-Dark icons\n'
    else
        printf '  MISSING  Tokyonight-Dark icons\n'
    fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

[ -f /etc/arch-release ] || die "this script is for Arch Linux"
((EUID != 0)) || die "run as a normal user, not root"
command -v sudo >/dev/null 2>&1 || die "sudo is required"
normalize_profiles

if ((!DRY_RUN)); then
    sudo -v || die "sudo authentication failed"
fi

log "Repository: $REPO_DIR"
log "Profiles: ${SELECTED[*]}"

if ((!NO_PACKAGES)); then
    install_official_names base-devel git curl wget rsync
    for p in "${SELECTED[@]}"; do
        install_profile "$p"
    done
    if ((WITH_BOOT)); then
        install_official_file "$REPO_DIR/packages/conditional.txt"
    fi
else
    log "Skipping package installation (--no-packages)"
fi

if ((!NO_BUILD)); then
    build_local_components
else
    log "Skipping local builds (--no-build)"
fi

if ((!NO_CONFIG)); then
    if [ -x "$REPO_DIR/install.sh" ]; then
        if ((DRY_RUN)); then
            "$REPO_DIR/install.sh" --dry-run
        else
            "$REPO_DIR/install.sh"
        fi
    else
        die "install.sh is missing or not executable"
    fi
else
    log "Skipping dotfile deployment (--no-config)"
fi

# Change the login shell only when needed.
if ((!DRY_RUN)); then
    current_user=$(id -un)
    current_shell=$(getent passwd "$current_user" | cut -d: -f7)
    if [ "$current_shell" != "/usr/bin/zsh" ]; then
        log "Changing login shell to /usr/bin/zsh"
        sudo chsh -s /usr/bin/zsh "$current_user" || warn "could not change login shell"
    fi
fi

if ((!NO_SERVICES)); then
    enable_services
else
    log "Skipping service enablement (--no-services)"
fi

if [ ! -e "$HOME/.local/share/bg" ]; then
    warn "No wallpaper link at ~/.local/share/bg; set one with nitrogen after starting X"
fi

verify_installation

cat <<'EOF'

Next steps:
  1. Log out and back in (or reboot) so zsh and group changes apply.
  2. Start X from tty1 with: startx
  3. Set a wallpaper: nitrogen --set-zoom-fill --save /path/to/wallpaper
  4. Build the lockscreen cache: betterlockscreen -u /path/to/wallpaper
  5. Import the Telegram theme once:
       Settings > Chat settings > Create new theme > Import existing theme
       ~/.local/share/telegram-themes/nordic.tdesktop-theme
  6. Review PACKAGE-AUDIT.md and packages/remove-candidates.txt before removing
     any old packages. Nothing is removed automatically.
  7. If you use Bitwarden, authenticate manually; do not commit BW_SESSION.

EOF
