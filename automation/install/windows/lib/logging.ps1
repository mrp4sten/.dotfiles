# logging.ps1 — Console output helpers (parity with bash log_*() in bootstrap.sh)

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "══════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "══════════════════════════════════════════" -ForegroundColor Cyan
}

function Write-Info  { param([string]$Msg) Write-Host "  [INFO]  $Msg" -ForegroundColor Gray }
function Write-Ok    { param([string]$Msg) Write-Host "  [ OK ]  $Msg" -ForegroundColor Green }
function Write-Skip  { param([string]$Msg) Write-Host "  [SKIP]  $Msg — already installed" -ForegroundColor DarkGray }
function Write-Warn  { param([string]$Msg) Write-Host "  [WARN]  $Msg" -ForegroundColor Yellow }
function Write-Step  { param([string]$Msg) Write-Host "  ····    $Msg" -ForegroundColor DarkCyan }
