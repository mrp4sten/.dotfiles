#Requires -Version 5.1
<#
.SYNOPSIS
    bootstrap.ps1 — Full dev environment installer for Windows

.DESCRIPTION
    Native PowerShell port of automation/install/bootstrap.sh.
    Installs tools via winget + scoop. Safe to re-run: skips anything already installed.
    Supports: Windows 10 (1903+) / Windows 11

.PARAMETER Core
    PowerShell 7, PSReadLine modules, posh-git, Terminal-Icons, starship, Windows Terminal

.PARAMETER Langs
    Language runtimes: nvm-windows (Node), pyenv-win (Python), temurin-lts (Java)

.PARAMETER Devtools
    CLI dev tools: lazygit, fzf, atuin, lsd, bat, eza, yazi, fastfetch, win32yank, engram

.PARAMETER Apps
    Terminal apps: Neovim, Nerd Fonts (Hack, CascadiaCode, FantasqueSansMono, JetBrainsMono)

.EXAMPLE
    pwsh -ExecutionPolicy Bypass -File bootstrap.ps1
    pwsh -ExecutionPolicy Bypass -File bootstrap.ps1 -Core
    pwsh -ExecutionPolicy Bypass -File bootstrap.ps1 -Devtools
#>

[CmdletBinding()]
param (
    [switch]$Core,
    [switch]$Langs,
    [switch]$Devtools,
    [switch]$Apps
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ── Guard: Windows only ───────────────────────────────────────────────────────
if (-not ($IsWindows -or $env:OS -eq 'Windows_NT')) {
    Write-Host "This script is for Windows only." -ForegroundColor Red
    Write-Host "On Linux/macOS use: bash automation/install/bootstrap.sh" -ForegroundColor Yellow
    exit 2
}

# ── Load helpers ──────────────────────────────────────────────────────────────
. "$PSScriptRoot\lib\logging.ps1"
. "$PSScriptRoot\lib\package.ps1"

# ── Default: install everything ───────────────────────────────────────────────
if (-not ($Core -or $Langs -or $Devtools -or $Apps)) {
    $Core     = $true
    $Langs    = $true
    $Devtools = $true
    $Apps     = $true
}

$DOTFILES_DIR = "$env:USERPROFILE\.dotfiles"

# ─────────────────────────────────────────────────────────────────────────────
#  Prerequisite: Scoop
# ─────────────────────────────────────────────────────────────────────────────

Write-Section "Prerequisites"
Write-Info "Detected: Windows $([System.Environment]::OSVersion.Version)"

Install-Scoop
Add-ScoopBucket "extras"
Add-ScoopBucket "nerd-fonts"
Add-ScoopBucket "java"

# ─────────────────────────────────────────────────────────────────────────────
#  Core — Shell, prompt, terminal
# ─────────────────────────────────────────────────────────────────────────────

if ($Core) {
    Write-Section "Core — Shell & Prompt"

    Install-WingetPackage -Id "Microsoft.PowerShell"      -Command "pwsh"
    Install-WingetPackage -Id "Microsoft.WindowsTerminal" -Command "wt"
    Install-WingetPackage -Id "Starship.Starship"         -Command "starship"
    Install-WingetPackage -Id "Git.Git"                   -Command "git"

    Write-Step "Installing PowerShell modules..."
    Install-PSModule "PSReadLine"
    Install-PSModule "posh-git"
    Install-PSModule "Terminal-Icons"
    Install-PSModule "z"

    Write-Ok "Core done"
}

# ─────────────────────────────────────────────────────────────────────────────
#  Langs — Node, Python, Java
# ─────────────────────────────────────────────────────────────────────────────

if ($Langs) {
    Write-Section "Languages"

    # Node — nvm-windows
    Install-ScoopPackage -Package "nvm" -Command "nvm"
    if (Test-CommandExists nvm) {
        $nodeInstalled = nvm list 2>$null | Select-String '\d+\.\d+\.\d+'
        if (-not $nodeInstalled) {
            Write-Step "Installing Node LTS via nvm..."
            nvm install lts
            nvm use lts
            Write-Ok "Node LTS"
        } else {
            Write-Skip "Node (managed by nvm)"
        }
    }

    # Python — pyenv-win
    Install-ScoopPackage -Package "pyenv" -Command "pyenv"

    # Java — Eclipse Temurin LTS
    Install-ScoopPackage -Package "temurin-lts-jdk" -Command "java"

    Write-Ok "Languages done"
}

# ─────────────────────────────────────────────────────────────────────────────
#  Devtools — CLI tools
# ─────────────────────────────────────────────────────────────────────────────

if ($Devtools) {
    Write-Section "Dev Tools"

    Install-ScoopPackage -Package "lazygit"
    Install-WingetPackage -Id "junegunn.fzf"  -Command "fzf"
    Install-ScoopPackage -Package "atuin"
    Install-ScoopPackage -Package "lsd"
    Install-ScoopPackage -Package "bat"
    Install-ScoopPackage -Package "eza"
    Install-ScoopPackage -Package "yazi"
    Install-ScoopPackage -Package "fastfetch"
    Install-ScoopPackage -Package "win32yank"   # nvim clipboard on Windows
    Install-ScoopPackage -Package "zoxide"      # smarter cd, replaces z

    # engram — persistent AI memory binary
    if (-not (Test-CommandExists engram)) {
        Write-Step "Installing engram..."
        $engramDest = "$env:USERPROFILE\.local\bin\engram.exe"
        $null = New-Item -ItemType Directory -Path (Split-Path $engramDest -Parent) -Force
        $engramUrl = "https://github.com/mudler/engram/releases/latest/download/engram-windows-amd64.exe"
        Invoke-WebRequest -Uri $engramUrl -OutFile $engramDest -UseBasicParsing
        Write-Ok "engram"
    } else {
        Write-Skip "engram"
    }

    Write-Ok "Dev tools done"
}

# ─────────────────────────────────────────────────────────────────────────────
#  Apps — Neovim, Nerd Fonts
# ─────────────────────────────────────────────────────────────────────────────

if ($Apps) {
    Write-Section "Apps"

    Install-WingetPackage -Id "Neovim.Neovim" -Command "nvim"

    Write-Step "Installing Nerd Fonts via scoop..."
    foreach ($font in @("Hack-NF", "CascadiaCode-NF", "FantasqueSansMono-NF", "JetBrainsMono-NF")) {
        Install-ScoopPackage -Package $font -Command ""
    }

    Write-Ok "Apps done"
}

# ─────────────────────────────────────────────────────────────────────────────
#  Summary of intentional skips (Linux-only layers)
# ─────────────────────────────────────────────────────────────────────────────

Write-Section "Skipped — Linux-only (expected)"
Write-Info "system/desktop/   — Hyprland, Waybar, Rofi, Dunst (Wayland/X11 only)"
Write-Info "system/services/  — systemd units (Linux only)"
Write-Info "system/boot/      — GRUB bootloader (Linux only)"
Write-Info "tmux              — POSIX only; use Windows Terminal panes instead"
Write-Info "kitty / ghostty   — no Windows build; Windows Terminal is your terminal"
Write-Info "visual/themes/    — GTK / X11 cursor themes (Linux only)"

Write-Host ""
Write-Host "  Bootstrap complete." -ForegroundColor Green
Write-Host "  Next step: pwsh -File $DOTFILES_DIR\automation\install\windows\install.ps1" -ForegroundColor Cyan
Write-Host ""
