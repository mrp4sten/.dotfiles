# functions.ps1 — Shell functions
# Mirrors core/shell/zsh/_functions/functions.sh
# desktop_craft intentionally omitted — Linux-only (.desktop files have no Windows equivalent).

# Create config developer files (.gitignore, .prettierrc, .htmlhintrc, .stylelintrc, webpack.config.js, etc.)
function config_craft {
    $script = "$env:USERPROFILE\.dotfiles\automation\generators\config-craft\config-craft.sh"
    if (Get-Command bash -ErrorAction SilentlyContinue) {
        bash $script @args
    } else {
        Write-Host "config_craft requires bash. Install Git for Windows: https://git-scm.com" -ForegroundColor Yellow
    }
}

# Setup AI skills in a project
function skills_setup {
    $script = "$env:USERPROFILE\.dotfiles\development\IA\opencode\skill\setup.sh"
    if (Get-Command bash -ErrorAction SilentlyContinue) {
        bash $script @args
    } else {
        Write-Host "skills_setup requires bash (Git for Windows)." -ForegroundColor Yellow
    }
}

# Sync skill metadata to AGENTS.md
function skills_sync {
    $script = "$env:USERPROFILE\.dotfiles\development\IA\opencode\skill\sync.sh"
    if (Get-Command bash -ErrorAction SilentlyContinue) {
        bash $script @args
    } else {
        Write-Host "skills_sync requires bash (Git for Windows)." -ForegroundColor Yellow
    }
}
