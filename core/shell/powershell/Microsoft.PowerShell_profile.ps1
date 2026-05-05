# Microsoft.PowerShell_profile.ps1
# Symlinked to $PROFILE by automation/install/windows/install.ps1
# Structure mirrors core/shell/zsh/.zshrc — three sourced subdirs.

$DOTFILES = "$env:USERPROFILE\.dotfiles"
$PS_DIR   = "$DOTFILES\core\shell\powershell"

# ── Exports (PATH, env vars, tool inits) ─────────────────────────────────────
. "$PS_DIR\_exports\exports.ps1"

# ── Aliases ───────────────────────────────────────────────────────────────────
. "$PS_DIR\_aliases\utils.ps1"

# ── Functions ────────────────────────────────────────────────────────────────
. "$PS_DIR\_functions\functions.ps1"

# ── PSReadLine — better line editing ─────────────────────────────────────────
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# ── posh-git ──────────────────────────────────────────────────────────────────
if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module posh-git
}

# ── Terminal-Icons (icons in ls output) ──────────────────────────────────────
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons
}
