# Dunst

Lightweight notification daemon for X11 and Wayland.

## Installation

```bash
pacman -S dunst
```

## Copy/Symlink

```bash
ln -s ~/.dotfiles/system/desktop/dunst ~/.config/dunst
```

Or use the install script:

```bash
bash ~/.dotfiles/automation/install/install.sh
```

## Usage

```bash
dunst                    # start daemon
dunstify "Title" "Body"   # send test notification
dunstctl reload         # reload config
dunstctl close          # close all notifications
```

## Dependencies

- `dunstify` (optional) — send notifications from CLI

## Notes

- Dunst is auto-started via D-Bus when a notification is sent
- Kill any stale instances before running manually: `pkill dunst`