#!/bin/sh
# install.sh - deploy the dotfiles in this repository into $HOME.
#
# This script only copies configuration. It does not install packages, build
# dwm, or enable services. For a fresh Arch Linux machine use arch-setup.sh.
#
# Usage:
#   ./install.sh [--dry-run] [--no-backup]
#
# Runtime state is deliberately not deployed:
#   - mpd database/log/state/sticker
#   - ncmpcpp/error.log and .config/error.log
#   - zsh/envs when the destination already exists (may contain secrets)

set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DRY_RUN=0
NO_BACKUP=0
BACKUP_DIR="$HOME/.local/share/backups/dotfiles-$(date +%Y%m%d-%H%M%S)"

usage() {
    cat <<'EOF'
Usage: ./install.sh [--dry-run] [--no-backup]

  --dry-run    Show what would be copied without changing anything.
  --no-backup  Do not keep backups of overwritten files.
  -h, --help   Show this help.

Packages, builds, and services are handled by ./arch-setup.sh.
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --dry-run) DRY_RUN=1 ;;
        --no-backup) NO_BACKUP=1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "install.sh: unknown option: $1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

say() {
    printf '==> %s\n' "$*"
}

run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '+'
        printf ' %s' "$@"
        printf '\n'
    else
        "$@"
    fi
}

backup_path() {
    path=$1
    [ "$NO_BACKUP" -eq 1 ] && return 0
    [ -e "$path" ] || return 0
    mkdir -p "$BACKUP_DIR"
    rel=${path#"$HOME"/}
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    cp -a "$path" "$BACKUP_DIR/$rel"
}

copy_file() {
    src=$1
    dest=$2
    [ -e "$src" ] || return 0
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '+ cp -a %s %s\n' "$src" "$dest"
        return 0
    fi
    mkdir -p "$(dirname "$dest")"
    backup_path "$dest"
    cp -a "$src" "$dest"
}

copy_tree() {
    src=$1
    dest=$2
    shift 2
    [ -d "$src" ] || return 0
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '+ rsync -a'
        printf ' %s' "$@"
        printf ' %s/ %s/\n' "$src" "$dest"
        return 0
    fi
    mkdir -p "$dest"
    if ! command -v rsync >/dev/null 2>&1; then
        echo "install.sh: rsync is required (it is in packages/core.txt)" >&2
        exit 1
    fi
    if [ "$NO_BACKUP" -eq 1 ]; then
        rsync -a "$@" "$src/" "$dest/"
    else
        mkdir -p "$BACKUP_DIR"
        rsync -a --backup --backup-dir="$BACKUP_DIR" "$@" "$src/" "$dest/"
    fi
}

say "Deploying dotfiles from $REPO_DIR"
[ "$DRY_RUN" -eq 1 ] && say "Dry run: no files will be changed"

# Main configuration. Keep runtime databases/logs out of the deployment.
copy_tree "$REPO_DIR/.config" "$HOME/.config" \
    --exclude 'mpd/database' \
    --exclude 'mpd/log' \
    --exclude 'mpd/state' \
    --exclude 'mpd/sticker.sql' \
    --exclude 'ncmpcpp/error.log' \
    --exclude 'error.log' \
    --exclude 'zsh/envs'

# zsh/envs may contain machine-specific secrets. The repo copy is sanitized,
# so only install it when there is no existing file.
if [ ! -e "$HOME/.config/zsh/envs" ]; then
    copy_file "$REPO_DIR/.config/zsh/envs" "$HOME/.config/zsh/envs"
else
    say "Keeping existing ~/.config/zsh/envs (not overwritten)"
fi

copy_tree "$REPO_DIR/.local/bin" "$HOME/.local/bin"
copy_file "$REPO_DIR/.xinitrc" "$HOME/.xinitrc"
copy_file "$REPO_DIR/.zshrc" "$HOME/.zshrc"
copy_file "$REPO_DIR/.gtkrc-2.0" "$HOME/.gtkrc-2.0"

# Telegram theme asset (the theme still has to be imported in Telegram once).
if [ -f "$REPO_DIR/.config/telegram/nordic.tdesktop-theme" ]; then
    run mkdir -p "$HOME/.local/share/telegram-themes"
    run cp -a "$REPO_DIR/.config/telegram/nordic.tdesktop-theme" \
        "$HOME/.local/share/telegram-themes/nordic.tdesktop-theme"
fi

if [ "$DRY_RUN" -eq 0 ]; then
    # The bridge and the other helper scripts must stay executable.
    find "$HOME/.local/bin" -maxdepth 1 -type f -exec chmod +x {} +
    chmod +x "$HOME/.xinitrc" 2>/dev/null || true
fi

if [ "$DRY_RUN" -eq 0 ] && [ "$NO_BACKUP" -eq 0 ] && [ -d "$BACKUP_DIR" ]; then
    say "Overwritten files backed up to $BACKUP_DIR"
fi

say "Configuration deployed"
say "Next: ./arch-setup.sh (packages, dwm, services), then log out and back in."
