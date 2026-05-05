# package.ps1 — Winget / Scoop install helpers with idempotency checks

function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Bootstrap Scoop itself if missing
function Install-Scoop {
    if (Test-CommandExists scoop) {
        Write-Skip "scoop"
        return
    }
    Write-Step "Installing Scoop package manager..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri 'https://get.scoop.sh' | Invoke-Expression
    Write-Ok "scoop"
}

# Add a Scoop bucket if not already added
function Add-ScoopBucket {
    param([string]$Bucket)
    $existing = scoop bucket list 2>$null
    if ($existing -match "(?m)^\s*$([regex]::Escape($Bucket))\s*$") {
        Write-Skip "scoop bucket $Bucket"
        return
    }
    Write-Step "Adding scoop bucket: $Bucket"
    scoop bucket add $Bucket
    Write-Ok "scoop bucket $Bucket"
}

# Install a package via Scoop (idempotent)
function Install-ScoopPackage {
    param(
        [string]$Package,
        [string]$Command = $Package   # command to probe; defaults to package name
    )
    if (Test-CommandExists $Command) {
        Write-Skip $Package
        return
    }
    Write-Step "Installing $Package via scoop..."
    scoop install $Package
    Write-Ok $Package
}

# Install a package via Winget (idempotent)
function Install-WingetPackage {
    param(
        [string]$Id,
        [string]$Command = ""
    )
    if ($Command -and (Test-CommandExists $Command)) {
        Write-Skip $Id
        return
    }
    $installed = winget list --id $Id --exact --accept-source-agreements 2>$null
    if ($LASTEXITCODE -eq 0 -and "$installed" -match [regex]::Escape($Id)) {
        Write-Skip $Id
        return
    }
    Write-Step "Installing $Id via winget..."
    winget install --id $Id --exact --silent --accept-package-agreements --accept-source-agreements
    Write-Ok $Id
}

# Install a PowerShell module if not already present
function Install-PSModule {
    param([string]$Module)
    if (Get-Module -ListAvailable -Name $Module -ErrorAction SilentlyContinue) {
        Write-Skip "PSModule $Module"
        return
    }
    Write-Step "Installing PowerShell module: $Module"
    Install-Module -Name $Module -Scope CurrentUser -Force -SkipPublisherCheck
    Write-Ok "PSModule $Module"
}
