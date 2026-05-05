#Requires -Version 5.1
<#
.SYNOPSIS
    install.ps1 — Dotfiles symlink installer for Windows

.DESCRIPTION
    Native PowerShell port of automation/install/install.sh.
    Creates symbolic links from %USERPROFILE% / %APPDATA% / %LOCALAPPDATA%
    into this dotfiles repo. Safe to re-run: backs up existing items before replacing.

    Requires Developer Mode OR Administrator — see docs/windows-setup.md.
#>

[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ── Guard: Windows only ───────────────────────────────────────────────────────
if (-not ($IsWindows -or $env:OS -eq 'Windows_NT')) {
    Write-Host "This script is for Windows only." -ForegroundColor Red
    Write-Host "On Linux/macOS use: bash automation/install/install.sh" -ForegroundColor Yellow
    exit 2
}

# ── Load helpers ──────────────────────────────────────────────────────────────
. "$PSScriptRoot\lib\logging.ps1"
. "$PSScriptRoot\lib\symlink.ps1"

# ── Privilege check ───────────────────────────────────────────────────────────
if (-not (Test-SymlinkPrivilege)) { exit 1 }

# ─────────────────────────────────────────────────────────────────────────────
$DOTFILES     = "$env:USERPROFILE\.dotfiles"
$APPDATA      = $env:APPDATA
$LOCALAPPDATA = $env:LOCALAPPDATA
$HOME_DIR     = $env:USERPROFILE

Write-Host ""
Write-Host "  Dotfiles Symlink Installer (Windows)" -ForegroundColor Cyan
Write-Host "  dotfiles dir : $DOTFILES"
Write-Host "  APPDATA      : $APPDATA"
Write-Host "  LOCALAPPDATA : $LOCALAPPDATA"

# ─────────────────────────────────────────────────────────────────────────────
#  Editor — Neovim  (%LOCALAPPDATA%\nvim)
# ─────────────────────────────────────────────────────────────────────────────

Write-Section "Editor — Neovim"
New-RepoSymbolicLink `
    -Source "$DOTFILES\core\editor\nvim" `
    -Target "$LOCALAPPDATA\nvim"

# ─────────────────────────────────────────────────────────────────────────────
#  Shell — PowerShell profile
#  $PROFILE = Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# ─────────────────────────────────────────────────────────────────────────────

Write-Section "Shell — PowerShell profile"
$null = New-Item -ItemType Directory -Path (Split-Path $PROFILE -Parent) -Force
New-RepoSymbolicLink `
    -Source "$DOTFILES\core\shell\powershell\Microsoft.PowerShell_profile.ps1" `
    -Target $PROFILE

# ─────────────────────────────────────────────────────────────────────────────
#  Prompt — Starship  (%USERPROFILE%\.config\starship.toml — same file as Linux)
# ─────────────────────────────────────────────────────────────────────────────

Write-Section "Prompt — Starship"
New-RepoSymbolicLink `
    -Source "$DOTFILES\core\shell\zsh\starship.toml" `
    -Target "$HOME_DIR\.config\starship.toml"

# ─────────────────────────────────────────────────────────────────────────────
#  Terminal — Windows Terminal
#  Probe Store path first, then non-Store path.
# ─────────────────────────────────────────────────────────────────────────────

Write-Section "Terminal — Windows Terminal"
$wtStore    = "$LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$wtNoStore  = "$LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
$wtTarget   = $null

if (Test-Path (Split-Path $wtStore -Parent))   { $wtTarget = $wtStore }
elseif (Test-Path (Split-Path $wtNoStore -Parent)) { $wtTarget = $wtNoStore }
else { Write-Warn "Windows Terminal settings dir not found — install Windows Terminal first, then re-run" }

if ($wtTarget) {
    New-RepoSymbolicLink `
        -Source "$DOTFILES\core\terminal\windows-terminal\settings.json" `
        -Target $wtTarget
}

# ─────────────────────────────────────────────────────────────────────────────
#  Development — Lazygit  (%APPDATA%\lazygit)
# ─────────────────────────────────────────────────────────────────────────────

Write-Section "Development — Lazygit"
New-RepoSymbolicLink `
    -Source "$DOTFILES\development\git\lazygit" `
    -Target "$APPDATA\lazygit"

# ─────────────────────────────────────────────────────────────────────────────
#  Development — VS Code  (%APPDATA%\Code\User\settings.json)
# ─────────────────────────────────────────────────────────────────────────────

Write-Section "Development — VS Code"
New-RepoSymbolicLink `
    -Source "$DOTFILES\development\vscode\vscode\settings.json" `
    -Target "$APPDATA\Code\User\settings.json"

# ─────────────────────────────────────────────────────────────────────────────
#  Development — opencode  (%APPDATA%\opencode)
# ─────────────────────────────────────────────────────────────────────────────

Write-Section "Development — opencode"
if (Test-Path "$DOTFILES\development\IA\opencode") {
    New-RepoSymbolicLink `
        -Source "$DOTFILES\development\IA\opencode" `
        -Target "$APPDATA\opencode"
} else {
    Write-Skip "opencode (config not present in repo)"
}

# ─────────────────────────────────────────────────────────────────────────────
#  Utilities — fastfetch  (%USERPROFILE%\.config\fastfetch)
# ─────────────────────────────────────────────────────────────────────────────

Write-Section "Utilities — fastfetch"
New-RepoSymbolicLink `
    -Source "$DOTFILES\utilities\system-info\fastfetch" `
    -Target "$HOME_DIR\.config\fastfetch"

# ─────────────────────────────────────────────────────────────────────────────
#  Visual — Fonts (copy + per-user registry registration)
#  Windows font cache cannot follow symlinks, so we copy and register.
# ─────────────────────────────────────────────────────────────────────────────

Write-Section "Visual — Fonts (per-user)"
$fontsSource = "$DOTFILES\visual\fonts"
$fontsDest   = "$LOCALAPPDATA\Microsoft\Windows\Fonts"
$fontsReg    = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

if (Test-Path $fontsSource) {
    $null = New-Item -ItemType Directory -Path $fontsDest -Force
    Get-ChildItem -Path $fontsSource -Recurse -Include "*.ttf","*.otf" | ForEach-Object {
        $destFile = Join-Path $fontsDest $_.Name
        $regName  = $_.BaseName + " (TrueType)"
        $already  = (Get-ItemProperty -Path $fontsReg -Name $regName -ErrorAction SilentlyContinue).$regName
        if ($already) {
            Write-Skip "Font: $($_.Name)"
        } else {
            Copy-Item -Path $_.FullName -Destination $destFile -Force
            New-ItemProperty -Path $fontsReg -Name $regName -Value $_.Name -PropertyType String -Force | Out-Null
            Write-Ok "Font: $($_.Name)"
        }
    }
} else {
    Write-Skip "visual/fonts (directory not present)"
}

# ─────────────────────────────────────────────────────────────────────────────
#  Done
# ─────────────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "  All done!" -ForegroundColor Green
Write-Host "  Reload your shell: . `$PROFILE" -ForegroundColor Cyan
Write-Host ""
