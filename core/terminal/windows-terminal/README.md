# Windows Terminal

Replaces Kitty/Ghostty on Windows. Default profile: PowerShell 7. Color scheme: Gruvbox Dark. Font: Hack Nerd Font Mono.

## Symlink

`install.ps1` links `settings.json` to whichever location Windows Terminal uses on your machine:

| Install type | Settings path |
|---|---|
| Microsoft Store | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` |
| winget / GitHub release | `%LOCALAPPDATA%\Microsoft\Windows Terminal\settings.json` |

`install.ps1` probes both paths automatically and uses whichever parent directory exists.

## Manual setup

If the symlink wasn't created (Windows Terminal wasn't installed yet when you ran `install.ps1`):

```powershell
# Install Windows Terminal first
winget install --id Microsoft.WindowsTerminal --exact

# Then re-run install
pwsh -File ~\.dotfiles\automation\install\windows\install.ps1
```

## Customization

Edit `settings.json` in this repo — changes apply immediately on the next Windows Terminal launch (symlink is live).
