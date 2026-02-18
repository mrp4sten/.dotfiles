# GRUB Themes

Custom GRUB bootloader themes.

## Available Themes

| Theme | Description |
|-------|-------------|
| `crt-amber-theme` | Retro CRT amber monitor aesthetic with Fixedsys font |

---

## Structure

```
visual/themes/grub/
├── README.md
├── install-grub-theme.sh       # Automated install/uninstall script
└── crt-amber-theme/
    ├── theme.txt               # GRUB theme definition
    ├── background.png          # Full-screen background image
    ├── fixedsys-regular-32.pf2 # Bitmap font for GRUB
    ├── item_c.png              # Unselected boot entry style
    ├── selected_item_c.png     # Selected boot entry style
    └── terminal_box_c.png      # Terminal overlay box
```

---

## Installation (Automated)

Use the provided script. It handles copying files, patching `/etc/default/grub`, and running `update-grub` automatically.

```bash
# Install default theme (crt-amber-theme)
sudo bash ~/.dotfiles/visual/themes/grub/install-grub-theme.sh

# Install a specific theme by name
sudo bash ~/.dotfiles/visual/themes/grub/install-grub-theme.sh crt-amber-theme
```

Reboot to see the theme applied at the bootloader.

---

## Uninstall (Automated)

```bash
sudo bash ~/.dotfiles/visual/themes/grub/install-grub-theme.sh --uninstall crt-amber-theme
```

This removes the theme files from `/boot/grub/themes/` and strips `GRUB_THEME` from `/etc/default/grub`, then runs `update-grub`.

---

## Manual Installation

If you prefer to do it by hand:

### 1. Copy theme to GRUB themes directory

```bash
sudo cp -r ~/.dotfiles/visual/themes/grub/crt-amber-theme /boot/grub/themes/
```

### 2. Edit GRUB config

```bash
sudo nano /etc/default/grub
```

Add or update this line:

```ini
GRUB_THEME="/boot/grub/themes/crt-amber-theme/theme.txt"
```

### 3. Rebuild GRUB

```bash
sudo update-grub
```

### 4. Reboot

```bash
reboot
```

---

## Manual Uninstall

```bash
# Remove theme files
sudo rm -rf /boot/grub/themes/crt-amber-theme

# Edit GRUB config and remove the GRUB_THEME line
sudo nano /etc/default/grub

# Rebuild GRUB
sudo update-grub
```

---

## Troubleshooting

**Theme doesn't appear after reboot**
- Confirm `GRUB_THEME` points to the correct absolute path in `/etc/default/grub`
- Check that `/boot/grub/themes/crt-amber-theme/theme.txt` exists
- Run `sudo update-grub` again and check for errors in the output

**GRUB shows an error about the font**
- The `.pf2` font file must be present in the theme directory
- GRUB loads fonts relative to the theme path — do not move individual files

**Backup of original config**
- The install script creates a timestamped backup at `/etc/default/grub.bak.YYYYMMDD_HHMMSS` before making any changes
