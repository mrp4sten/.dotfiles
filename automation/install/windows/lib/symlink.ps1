# symlink.ps1 — Symbolic link helpers for install.ps1
# Requires Developer Mode (Settings → Privacy & security → For developers)
# OR running PowerShell as Administrator.

function Test-SymlinkPrivilege {
    $devMode = (Get-ItemProperty `
        -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" `
        -Name "AllowDevelopmentWithoutDevLicense" `
        -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($devMode -eq 1 -or $isAdmin) { return $true }

    Write-Host ""
    Write-Host "  ERROR: Cannot create symbolic links." -ForegroundColor Red
    Write-Host "  Fix one of:" -ForegroundColor Yellow
    Write-Host "    A) Enable Developer Mode:" -ForegroundColor Yellow
    Write-Host "       Settings -> Privacy & security -> For developers -> Developer Mode -> ON" -ForegroundColor White
    Write-Host "    B) Re-run this script as Administrator." -ForegroundColor Yellow
    Write-Host ""
    return $false
}

# Returns $true if the caller should proceed with symlink creation; $false if already correctly linked.
function Backup-Existing {
    param([string]$Target, [string]$DotfilesDir)

    $item = Get-Item $Target -ErrorAction SilentlyContinue -Force
    if ($null -eq $item) { return $true }

    if ($item.LinkType -eq 'SymbolicLink') {
        $resolved = (Resolve-Path $item.Target -ErrorAction SilentlyContinue).Path
        if ($resolved -and $resolved.StartsWith($DotfilesDir)) {
            Write-Skip "Already linked -> $Target"
            return $false
        }
        Write-Warn "Removing stale symlink: $Target"
        Remove-Item $Target -Force
        return $true
    }

    $timestamp  = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir  = "$env:USERPROFILE\.dotfiles-backup\$timestamp"
    $null       = New-Item -ItemType Directory -Path $backupDir -Force
    $backupPath = Join-Path $backupDir (Split-Path $Target -Leaf)
    Write-Info "Backing up: $Target -> $backupPath"
    Move-Item -Path $Target -Destination $backupPath -Force
    return $true
}

function New-RepoSymbolicLink {
    param(
        [string]$Source,
        [string]$Target,
        [string]$DotfilesDir = "$env:USERPROFILE\.dotfiles"
    )

    if (-not (Backup-Existing -Target $Target -DotfilesDir $DotfilesDir)) { return }

    $null = New-Item -ItemType Directory -Path (Split-Path $Target -Parent) -Force
    New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
    Write-Ok "Linked: $Target -> $Source"
}
