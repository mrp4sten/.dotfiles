# PowerShell

Windows shell layer. Replaces zsh + oh-my-zsh on Windows. Uses PowerShell 7 + starship prompt.

## Structure

```
powershell/
├── Microsoft.PowerShell_profile.ps1   # entry point — symlinked to $PROFILE
├── _aliases/utils.ps1                 # lsd, bat, docker, gradle aliases
├── _exports/exports.ps1               # PATH, env vars, tool inits (starship, atuin, zoxide)
└── _functions/functions.ps1           # config_craft, skills_setup, skills_sync
```

Mirrors `core/shell/zsh/` — same three-subdir structure sourced by the profile.

## Symlink

`install.ps1` links `Microsoft.PowerShell_profile.ps1` to `$PROFILE`:

```
Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

## Reload

```powershell
. $PROFILE
```

## Prerequisites

Installed via `bootstrap.ps1 -Core`:

| Tool | Purpose |
|---|---|
| PowerShell 7 | Shell (`pwsh`) |
| starship | Prompt (same `starship.toml` as Linux) |
| PSReadLine | Line editing + history prediction |
| posh-git | Git status in prompt |
| Terminal-Icons | File icons in `ls` output |
| atuin | Shell history sync |
| zoxide | Smarter `cd` |
