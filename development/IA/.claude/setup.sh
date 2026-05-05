#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.claude"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[+]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }

link() {
    local src="$1" dst="$2"

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        warn "Already linked: $dst"
        return
    fi

    if [ -L "$dst" ]; then
        warn "Stale symlink at $dst — relinking"
        rm "$dst"
    elif [ -e "$dst" ]; then
        warn "Backing up: $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    ln -s "$src" "$dst"
    info "Linked: $dst → $src"
}

echo "Claude Code dotfiles setup"
echo "  source : $SCRIPT_DIR"
echo "  target : $TARGET"
echo ""

mkdir -p "$TARGET"

# Symlink shared directories
for dir in agents commands hooks includes skills; do
    link "$SCRIPT_DIR/$dir" "$TARGET/$dir"
done

# Symlink shared files
link "$SCRIPT_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"

# Ensure hooks are executable
chmod +x "$SCRIPT_DIR/hooks/"*.sh 2>/dev/null && info "Hooks marked executable" || true

# Bootstrap settings.json from example if missing (machine-local, not tracked)
SETTINGS="$TARGET/settings.json"
EXAMPLE="$SCRIPT_DIR/settings.json.example"

if [ ! -f "$SETTINGS" ]; then
    if [ -f "$EXAMPLE" ]; then
        cp "$EXAMPLE" "$SETTINGS"
        info "Created $SETTINGS from example — edit it to customize for this machine"
    else
        warn "No settings.json.example found — create $SETTINGS manually"
    fi
else
    warn "settings.json already exists at $TARGET — skipping (edit manually if needed)"
fi

echo ""
info "Done. Reload Claude Code to apply."
