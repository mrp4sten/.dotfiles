# exports.ps1 — PATH, env vars, and tool initializations
# Mirrors core/shell/zsh/_exports/exports.sh

# ── Local bin ─────────────────────────────────────────────────────────────────
$localBin = "$env:USERPROFILE\.local\bin"
if (Test-Path $localBin) { $env:PATH = "$localBin;$env:PATH" }

# ── Cargo (Rust) ──────────────────────────────────────────────────────────────
$cargoPath = "$env:USERPROFILE\.cargo\bin"
if (Test-Path $cargoPath) { $env:PATH = "$cargoPath;$env:PATH" }

# ── pyenv-win ─────────────────────────────────────────────────────────────────
$pyenvRoot = "$env:USERPROFILE\.pyenv\pyenv-win"
if (Test-Path $pyenvRoot) {
    $env:PYENV      = $pyenvRoot
    $env:PYENV_ROOT = $pyenvRoot
    $env:PYENV_HOME = $pyenvRoot
    $env:PATH = "$pyenvRoot\bin;$pyenvRoot\shims;$env:PATH"
}

# ── nvm-windows ───────────────────────────────────────────────────────────────
$nvmHome = "$env:APPDATA\nvm"
if (Test-Path $nvmHome) {
    $env:NVM_HOME    = $nvmHome
    $env:NVM_SYMLINK = "$env:ProgramFiles\nodejs"
    $env:PATH = "$nvmHome;$env:NVM_SYMLINK;$env:PATH"
}

# ── Java (temurin via scoop) ───────────────────────────────────────────────────
$javaCmd = Get-Command java -ErrorAction SilentlyContinue
if ($javaCmd) {
    $env:JAVA_HOME = (Resolve-Path (Join-Path (Split-Path $javaCmd.Source -Parent) "..")).Path
}

# ── Atuin ─────────────────────────────────────────────────────────────────────
if (Get-Command atuin -ErrorAction SilentlyContinue) {
    Invoke-Expression (& atuin init powershell | Out-String)
}

# ── Zoxide (smarter cd, replaces z) ──────────────────────────────────────────
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& zoxide init powershell | Out-String)
}

# ── Starship prompt ───────────────────────────────────────────────────────────
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell | Out-String)
}

# ── opencode ──────────────────────────────────────────────────────────────────
$opencodeBin = "$env:USERPROFILE\.opencode\bin"
if (Test-Path $opencodeBin) { $env:PATH = "$opencodeBin;$env:PATH" }

# ── kubectl (optional) ────────────────────────────────────────────────────────
$kubeConfig = "$env:USERPROFILE\.kube\config"
if (Test-Path $kubeConfig) { $env:KUBECONFIG = $kubeConfig }
