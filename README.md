# dotFiles

Modern, responsive, and minimalist **dwm (X11)** environment with live theme switching, GPU frosted glass blur, floating TUIs, and bootstrap scripts for Arch Linux.

---

## Features

- **Window Manager:** Custom-patched `dwm` with dynamic gaps (`vanitygaps`), `xrdb` runtime color reloading, and dedicated floating rules for HUDs.
- **Compositor (Picom):** Hardware-accelerated `dual_kawase` (strength 6) background blur, 8px rounded corners, and physics-eased window/notification animations.
- **Live System Theme Switcher:** Instant system-wide switching across **DWM**, **GTK 3/4**, **Alacritty**, **Tmux**, **lf**, **Rofi**, and **Dunst** without restarting your session.
- **Frosted Glass Launchers & Status Bar Menus:**
  - **App Launcher / Spotlight:** Centered floating Rofi HUD with instant in-place response.
  - **Wi-Fi (`nmtui`):** Floating network manager spawned directly on bar click.
  - **Bluetooth (`bluetui`):** Real-time device discovery and pairing spawned on bar click.
  - **Audio (`pulsemixer`):** Floating per-app channel control spawned on volume click.
  - **Calendar:** Lightweight GTK3 frosted floating calendar on date click.
  - **Power Menu (`sysact`):** Frosted session manager (`Lock`, `Sleep`, `Reboot`, `Power Off`, `Log Out`).

---

## Quick Start (Fresh Arch Install)

Run the bootstrap installer from any regular user account with `sudo` access:

```bash
git clone https://github.com/0xiamsanj/dotFiles.git ~/dotFiles
cd ~/dotFiles

# Preview planned package installations and actions:
./arch-setup.sh --dry-run

# Run standard installation (core daily-driver setup):
./arch-setup.sh
```

### Optional Additive Profiles:

```bash
./arch-setup.sh --profile dev       # Development tooling (Rust, Go, Node, Docker, etc.)
./arch-setup.sh --profile media     # Creative and media tools (OBS, GIMP, Kdenlive, etc.)
./arch-setup.sh --profile selfhost  # Self-hosting utilities and server tools
./arch-setup.sh --profile apps      # Desktop apps (Browsers, Telegram, Discord, etc.)
./arch-setup.sh --profile full      # All profiles combined
```

---

## Deploy Configurations Only

If you already have your base packages installed and just want to deploy the dotfiles:

```bash
cd ~/dotFiles

# Inspect what will be linked / copied:
./install.sh --dry-run

# Deploy configs into $HOME:
./install.sh
```

> **Note:** Existing environment variables (such as `~/.config/zsh/envs`) containing private tokens or secrets are preserved and never overwritten.

---

## Included Theme Presets

Switch themes on-the-fly using **`Mod + Shift + F5`** or by running `theme-switcher <theme>` in a terminal:

| Preset | Accent | Surface Palette | Window Focus |
| :--- | :--- | :--- | :--- |
| **`nordic-blue`** | Frost Cyan (`#88c0d0`) | Dark Slate (`#242933`) | Pastel Blue (`#a1baf0`) |
| **`pastel-red`** | Pastel Red (`#e06c75`) | Deep Charcoal (`#2b2d31`) | Warm Red (`#e06c75`) |
| **`pitch-red`** | Crimson (`#ff2233`) | OLED Black (`#000000`) | Vivid Red (`#ff2233`) |

```bash
theme-switcher nordic-blue
theme-switcher pastel-red
theme-switcher pitch-red
```

---

## Keybindings (Modifier: `Alt` / `Mod1`)

### Window Management & Workspaces
| Keybinding | Action |
| :--- | :--- |
| `Mod + Return` | Open terminal (`alacritty`) |
| `Mod + q` | Close focused window |
| `Mod + d` | Open frosted application launcher (`rofi`) |
| `Mod + Shift + q` | Open power & session menu (`sysact`) |
| `Mod + Shift + F5` | Open live system theme switcher |
| `Mod + f` | Toggle window fullscreen |
| `Mod + Shift + Space` | Toggle window floating state |
| `Mod + 1-9` | Switch to workspace `1-9` |
| `Mod + Shift + 1-9` | Move focused window to workspace `1-9` |
| `Mod + a` / `Mod + z` | Toggle vanity gaps / Increase gaps |

### Top Bar Click Actions
| Module | Left Click | Right Click | Scroll Wheel |
| :--- | :--- | :--- | :--- |
| **Wi-Fi** | Open floating `nmtui` | Open floating `nmtui` | — |
| **Bluetooth** | Open floating `bluetui` | Open floating `bluetui` | — |
| **Volume** | Open floating `pulsemixer` | Show notification details | Adjust volume `+/-` |
| **Date** | Toggle floating calendar | Toggle floating calendar | — |
| **Battery** | Show detailed health card | Show status summary | — |

---

## Post-Installation Checklist

1. Log in on your display or TTY and start X11:
   ```bash
   startx
   ```
2. Set your preferred wallpaper:
   ```bash
   nitrogen --set-zoom-fill --save /path/to/your/wallpaper.jpg
   ```
3. Generate the lockscreen blur cache:
   ```bash
   betterlockscreen -u /path/to/your/wallpaper.jpg
   ```
4. Configure your music library directory (if using `mpd`):
   Edit `music_directory` in `~/.config/mpd/mpd.conf` to match your local music folder.
