# utils.ps1 — Aliases and shortcuts
# Mirrors core/shell/zsh/_aliases/utils.sh

# ── lsd ───────────────────────────────────────────────────────────────────────
if (Get-Command lsd -ErrorAction SilentlyContinue) {
    function ls  { lsd --group-dirs=first @args }
    function l   { lsd -l --group-dirs=first @args }
    function la  { lsd -a --group-dirs=first @args }
    function lla { lsd -la --group-dirs=first @args }
    function lt  { lsd --tree --group-dirs=first @args }
}

# ── bat ───────────────────────────────────────────────────────────────────────
if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat  { bat --paging=never --theme="gruvbox-dark" @args }
    function less { bat --theme="gruvbox-dark" @args }
}

# ── nvim ──────────────────────────────────────────────────────────────────────
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Set-Alias vi nvim
}

# ── Update all packages (winget + scoop) ─────────────────────────────────────
function update {
    Write-Host "Updating winget packages..." -ForegroundColor Cyan
    winget upgrade --all --accept-package-agreements --accept-source-agreements
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host "Updating scoop packages..." -ForegroundColor Cyan
        scoop update *
    }
}

# ── fastfetch presets ─────────────────────────────────────────────────────────
function fastfetchsm { fastfetch --config "$env:USERPROFILE\.config\fastfetch\mavor-sm.jsonc" }
function fastfetchmd { fastfetch --config "$env:USERPROFILE\.config\fastfetch\mavor-md.jsonc" }
function fastfetchlg { fastfetch --config "$env:USERPROFILE\.config\fastfetch\mavor-lg.jsonc" }

# ── lazydocker ────────────────────────────────────────────────────────────────
if (Get-Command lazydocker -ErrorAction SilentlyContinue) {
    Set-Alias lzd lazydocker
}

# ── Docker ────────────────────────────────────────────────────────────────────
if (Get-Command docker -ErrorAction SilentlyContinue) {
    function dps    { docker ps --format "table {{.Names}}`t{{.Status}}`t{{.Ports}}" }
    function dpsa   { docker ps -a --format "table {{.Names}}`t{{.Status}}`t{{.Ports}}" }
    function dex    { docker exec -it @args }
    function dlog   { docker logs -f @args }
    function dcu    { docker compose up -d @args }
    function dcd    { docker compose down @args }
    function dcb    { docker compose up -d --build @args }
    function dcl    { docker compose logs -f @args }
    function dcp    { docker compose pull @args }
    function dcr    { docker compose restart @args }
    function dprune  { docker system prune -f }
    function dprunea { docker system prune -a --volumes -f }
    function dstats  { docker stats --format "table {{.Name}}`t{{.CPUPerc}}`t{{.MemUsage}}`t{{.NetIO}}" }
}

# ── Gradle ────────────────────────────────────────────────────────────────────
function gw   { .\gradlew @args }
function gwb  { .\gradlew build @args }
function gwt  { .\gradlew test @args }
function gwc  { .\gradlew clean @args }
function gwbr { .\gradlew bootRun @args }
function gwbd { .\gradlew build -x test @args }
