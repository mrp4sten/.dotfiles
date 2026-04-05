# Changelog - AI Skills Setup Scripts

## 2026-02-19 - Major Refactor

### Author
Changed from original Prowler-specific scripts to **mrp4sten** signature.

### Key Changes

#### 1. **Project-Agnostic Design**
- **Before**: Scripts assumed they were running inside a Prowler monorepo
- **After**: Scripts run from dotfiles and target ANY project via interactive selection

#### 2. **Optional Dependencies with Graceful Degradation**
Added support for modern tools with automatic fallbacks:

**gum** (interactive menus):
- If available: Beautiful multi-select menus with `gum choose`
- If missing: Falls back to bash `select` menus
- Suggests installation on first run

**zoxide** (frecent directories):
- If available: Suggests recently/frequently visited directories
- If missing: Works without it, manual path entry still available
- Suggests installation on first run

#### 3. **Interactive Project Selection**
New `select_project_interactive()` function offers:
1. Current directory
2. Browse with file picker (gum only)
3. Recent projects (from `.skill-registry`)
4. Frecent directories (from zoxide)
5. Manual path entry

#### 4. **Project Registry**
- Creates `.skill-registry` to remember configured projects
- Offers quick access to previously configured projects
- Optional: asks to save project after successful setup

#### 5. **Smart Structure Detection**
- Auto-detects monorepo vs single-repo structure
- Finds AGENTS.md files at root and subdirectories
- Adapts sync behavior based on detected structure

#### 6. **Improved Error Handling**
- Validates paths before use
- Expands `~` to `$HOME` automatically
- Converts to absolute paths
- Clear error messages with color coding

#### 7. **Enhanced CLI**
New flags:
```bash
# setup.sh
--path /path/to/project   # Specify target (bypass interactive)

# sync.sh
--path /path/to/project   # Specify target (bypass interactive)
--dry-run                 # Preview changes
--scope root              # Sync specific scope only
```

#### 8. **Zero Prowler Dependencies**
- Removed all hardcoded Prowler references
- Generic scope mapping (root, ui, api, sdk, mcp_server)
- Works with any project structure

### Shell Functions

Added to `~/.dotfiles/core/shell/zsh/_functions/functions.sh`:

```bash
# Setup AI skills in a project
skills_setup [--path /path] [--all | --claude | ...]

# Sync skill metadata to AGENTS.md
skills_sync [--path /path] [--dry-run] [--scope root]
```

### Migration Guide

#### Old Usage (Prowler-specific)
```bash
cd /path/to/prowler
./skills/setup.sh --all
./skills/skill-sync/assets/sync.sh
```

#### New Usage (Any Project)
```bash
# Interactive mode (recommended)
skills_setup
skills_sync

# Direct mode
skills_setup --path ~/projects/my-app --claude
skills_sync --path ~/projects/my-app

# From anywhere
~/.dotfiles/development/IA/opencode/skill/setup.sh
~/.dotfiles/development/IA/opencode/skill/sync.sh
```

### Backward Compatibility

✅ **Fully backward compatible** with command-line flags:
```bash
# Still works
./setup.sh --all
./setup.sh --claude --codex
./sync.sh --dry-run --scope root
```

✅ **New behavior** only activates when:
- No `--path` flag provided → triggers interactive selection
- `gum`/`zoxide` available → enhanced menus/suggestions

### Testing

Run existing test suites to verify:
```bash
bash ~/.dotfiles/development/IA/opencode/skill/setup_test.sh
bash ~/.dotfiles/development/IA/opencode/skill/skill-sync/assets/sync_test.sh
```

**Note**: Tests create isolated temp environments, so they test the old logic (project in current dir). Real-world usage now supports dotfiles → project workflows.

### Installation Recommendations

For best experience, install optional dependencies:

**Arch/Manjaro**:
```bash
sudo pacman -S gum zoxide
```

**macOS**:
```bash
brew install gum zoxide
```

**Ubuntu/Debian**:
```bash
# gum
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install gum

# zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

### Files Modified
- `setup.sh` - Complete rewrite with project selection + feature detection
- `sync.sh` - Complete rewrite with project selection + feature detection
- `README.md` - Updated setup instructions and workflow docs
- `functions.sh` - Added `skills_setup` and `skills_sync` shell functions
- `CHANGELOG.md` - This file

### Files Unchanged
- `setup_test.sh` - Tests still pass (isolated environments)
- `sync_test.sh` - Tests still pass (isolated environments)
- All `SKILL.md` files - No changes to skill content
