# Automation Scripts Sub-agent

This sub-agent specializes in automation scripts and interactive tools for the dotfiles repository.

## Scope

Work with automation scripts in:
- `automation/generators/` — Config file generators (config-craft)
- `automation/install/` — System setup scripts (desktop-craft)
- `automation/maintenance/` — System maintenance scripts
- `core/shell/zsh/_functions/functions.sh` — Shell function wrappers

## Key Scripts

### config-craft — Project Config Generator
**Location:** `automation/generators/config-craft/config-craft.sh`

Interactive script using `gum` to scaffold config files for JS/Webpack projects.

**Features:**
- Interactive menu to select config file type
- Copies templates to current working directory
- Available templates:
  - `.gitignore` (JS/Node projects)
  - `.prettierrc` (no semicolons, single quotes)
  - `.htmlhintrc` (HTML linting)
  - `.stylelintrc.json` (SCSS linting)
  - `webpack.config.js` (Webpack 5 config)

**Usage:**
```bash
# Direct invocation
bash ~/.dotfiles/automation/generators/config-craft/config-craft.sh

# Via shell function wrapper
config_craft
```

**Template Location:**
```
automation/generators/config-craft/
├── config-craft.sh              # Main script
└── js-project-settings/         # Template directory
    ├── .gitignore
    ├── .prettierrc
    ├── .htmlhintrc
    ├── .stylelintrc.json
    └── webpack.config.js
```

### desktop-craft — .desktop Entry Creator
**Location:** `automation/install/desktop-craft.sh`

Interactive script to create `.desktop` launcher files for applications.

**Features:**
- Prompts for app name, executable path, icon
- Generates valid `.desktop` file
- Installs to `~/.local/share/applications/`
- Makes executable automatically

**Usage:**
```bash
# Direct invocation
bash ~/.dotfiles/automation/install/desktop-craft.sh

# Via shell function wrapper
desktop_craft
```

### Maintenance Scripts
**Location:** `automation/maintenance/`

System maintenance and cleanup scripts (may include kernel cleanup, cache clearing, etc.)

## Script Conventions

### Interactive Tools (gum)
All interactive scripts use `gum` for user input:

```bash
# Install gum if missing
if ! command -v gum &> /dev/null; then
    echo "Error: gum is required"
    echo "Install: sudo pacman -S gum  # or: brew install gum"
    exit 1
fi

# Interactive menu
choice=$(gum choose "Option 1" "Option 2" "Option 3")

# Text input
name=$(gum input --placeholder "Enter name...")

# Confirmation
gum confirm "Are you sure?" && echo "Confirmed"
```

### Script Structure
```bash
#!/bin/bash
# author: mrp4sten

# Feature detection
HAS_GUM=false
command -v gum >/dev/null 2>&1 && HAS_GUM=true

# Graceful fallback if tool missing
if ! $HAS_GUM; then
    echo "Warning: gum not found, using basic input"
    # Fallback to 'select' or 'read'
fi

# Main logic
main() {
    # Validate inputs
    # Process selection
    # Perform action
}

main "$@"
```

### File Copying Pattern
```bash
# Copy template to current directory
TEMPLATE_DIR="$HOME/.dotfiles/automation/generators/config-craft/js-project-settings"
TARGET_FILE=".prettierrc"

if [ -f "$TARGET_FILE" ]; then
    echo "Warning: $TARGET_FILE already exists"
    gum confirm "Overwrite?" || exit 0
fi

cp "$TEMPLATE_DIR/$TARGET_FILE" .
echo "✓ Created $TARGET_FILE"
```

### Error Handling
```bash
# Check if template exists
if [ ! -f "$TEMPLATE_DIR/$TEMPLATE_FILE" ]; then
    echo "Error: Template not found: $TEMPLATE_FILE"
    exit 1
fi

# Check write permissions
if [ ! -w . ]; then
    echo "Error: No write permission in current directory"
    exit 1
fi
```

## Shell Function Wrappers

Location: `core/shell/zsh/_functions/functions.sh`

### Pattern
```bash
# Function name matches script name (snake_case)
config_craft() {
  local SCRIPT_PATH=~/.dotfiles/automation/generators/config-craft/config-craft.sh
  bash "${SCRIPT_PATH}" "$@"
}
```

### Why Use Wrappers
1. **Short, memorable names** — `config_craft` vs full path
2. **Pass arguments** — `config_craft --help`
3. **Consistent interface** — all tools available as functions

## Adding a New Automation Script

### Step 1: Create the script
```bash
# Choose appropriate directory
cd ~/.dotfiles/automation/generators/  # or install/ or maintenance/
mkdir my-tool
cd my-tool

# Create main script
cat > my-tool.sh << 'EOF'
#!/bin/bash
# author: mrp4sten

# Feature detection
HAS_GUM=false
command -v gum >/dev/null 2>&1 && HAS_GUM=true

# Main logic here
echo "Hello from my-tool"
EOF

chmod +x my-tool.sh
```

### Step 2: Add shell function wrapper
```bash
# Edit core/shell/zsh/_functions/functions.sh
my_tool() {
  local MY_TOOL=~/.dotfiles/automation/generators/my-tool/my-tool.sh
  bash "${MY_TOOL}" "$@"
}
```

### Step 3: Test
```bash
# Reload shell
source ~/.zshrc

# Test function
my_tool
```

## Testing

### Syntax Check
```bash
bash -n script.sh
shellcheck script.sh
```

### Manual Testing
```bash
# Test in current directory
cd /tmp/test-project
config_craft  # Select .gitignore
ls -la .gitignore  # Verify created
```

### Edge Cases to Test
- [ ] Script works without `gum` (fallback to basic input)
- [ ] Handles existing files (prompts for overwrite)
- [ ] Validates write permissions
- [ ] Returns clear error messages

## Deployment

Automation scripts stay in `~/.dotfiles/automation/` and are invoked via:
1. Shell function wrappers (recommended)
2. Direct bash invocation
3. Added to PATH (optional)

No deployment needed — scripts run from dotfiles directory.

## Related Files

- `AGENTS.md` — Repository-wide guidelines
- `SUBAGENT-shell.md` — Shell function conventions
- `automation/generators/config-craft/README.md` — config-craft docs
- `automation/install/desktop-craft.sh` — desktop-craft implementation
