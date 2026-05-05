# Windows Install Scripts

Native PowerShell port of `bootstrap.sh` + `install.sh`. No WSL required.

## Quick Start

```powershell
# 1. Clone
git clone https://github.com/mrp4sten/.dotfiles.git $HOME\.dotfiles
cd $HOME\.dotfiles
git submodule update --init --recursive

# 2. Prerequisites (one-time — see docs/windows-setup.md)
#    Enable Developer Mode in Windows Settings
#    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# 3. Install tools
pwsh -ExecutionPolicy Bypass -File automation\install\windows\bootstrap.ps1

# 4. Link configs
pwsh -File automation\install\windows\install.ps1

# 5. Reload shell
. $PROFILE
```

## Scripts

### `bootstrap.ps1` — Install tools

```powershell
bootstrap.ps1              # Install everything
bootstrap.ps1 -Core        # Shell: PS7, starship, PSReadLine, posh-git, Windows Terminal
bootstrap.ps1 -Langs       # Runtimes: nvm-windows, pyenv-win, temurin-lts
bootstrap.ps1 -Devtools    # CLI: lazygit, fzf, atuin, lsd, bat, eza, yazi, fastfetch
bootstrap.ps1 -Apps        # Apps: Neovim, Nerd Fonts
```

### `install.ps1` — Link configs

Creates symbolic links from `%USERPROFILE%` / `%APPDATA%` / `%LOCALAPPDATA%` into this repo.
Backs up any existing file to `~\.dotfiles-backup\<timestamp>\` before replacing.

## lib/

| File | Purpose |
|---|---|
| `logging.ps1` | `Write-Section/Ok/Skip/Warn/Step` — console output helpers |
| `package.ps1` | `Install-WingetPackage`, `Install-ScoopPackage`, `Test-CommandExists` |
| `symlink.ps1` | `New-RepoSymbolicLink` with backup + privilege check |

## Skipped on Windows (intentional)

- `system/desktop/` — Hyprland, Waybar, Rofi, Dunst (Wayland/X11 only)
- `system/services/`, `system/boot/` — systemd, GRUB
- `core/multiplexer/tmux/` — POSIX only; use Windows Terminal panes instead
- `core/terminal/kitty/`, `ghostty/` — no Windows builds
- `visual/themes/grub`, `visual/icons/` — GTK / X11 cursor themes
