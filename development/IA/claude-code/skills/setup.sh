#!/bin/bash
# author: mrp4sten
# Setup AI Skills for any project
# Configures AI coding assistants that follow agentskills.io standard:
#   - Claude Code: .claude/skills/ symlink + CLAUDE.md copies
#   - Gemini CLI: .gemini/skills/ symlink + GEMINI.md copies
#   - Codex (OpenAI): .codex/skills/ symlink + AGENTS.md (native)
#   - GitHub Copilot: .github/copilot-instructions.md copy
#
# Usage:
#   ./setup.sh              # Interactive mode (select project + AI assistants)
#   ./setup.sh --all        # Configure all AI assistants in current dir
#   ./setup.sh --claude     # Configure only Claude Code in current dir
#   ./setup.sh --path /path/to/project --all  # Specify target project
#
# Optional dependencies (with graceful fallbacks):
#   - gum: Better interactive menus (fallback: bash select)
#   - zoxide: Suggest frecent directories (fallback: manual path entry)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="$SCRIPT_DIR"
REGISTRY_FILE="$SCRIPT_DIR/.skill-registry"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Feature detection
HAS_GUM=false
HAS_ZOXIDE=false
command -v gum >/dev/null 2>&1 && HAS_GUM=true
command -v zoxide >/dev/null 2>&1 && HAS_ZOXIDE=true

# Configuration
TARGET_PROJECT=""
SETUP_CLAUDE=false
SETUP_GEMINI=false
SETUP_CODEX=false
SETUP_COPILOT=false

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Configure AI coding assistants for any project."
    echo ""
    echo "Options:"
    echo "  --path PATH  Target project directory (default: interactive selection)"
    echo "  --all        Configure all AI assistants"
    echo "  --claude     Configure Claude Code"
    echo "  --gemini     Configure Gemini CLI"
    echo "  --codex      Configure Codex (OpenAI)"
    echo "  --copilot    Configure GitHub Copilot"
    echo "  --help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Interactive mode"
    echo "  $0 --all                              # All AI assistants in current dir"
    echo "  $0 --path ~/projects/my-app --claude  # Claude in specific project"
    echo ""
    echo "Optional dependencies:"
    echo "  - gum:    Better interactive menus (install: pacman -S gum / brew install gum)"
    echo "  - zoxide: Suggest frecent directories (install: pacman -S zoxide / brew install zoxide)"
}

suggest_tools() {
    local suggestions=()
    
    if ! $HAS_GUM; then
        suggestions+=("${YELLOW}💡 Install 'gum' for better interactive menus${NC}")
        suggestions+=("${CYAN}   → sudo pacman -S gum  # or: brew install gum${NC}")
    fi
    
    if ! $HAS_ZOXIDE; then
        suggestions+=("${YELLOW}💡 Install 'zoxide' to track frecent directories${NC}")
        suggestions+=("${CYAN}   → sudo pacman -S zoxide  # or: brew install zoxide${NC}")
    fi
    
    if [ ${#suggestions[@]} -gt 0 ]; then
        echo ""
        for suggestion in "${suggestions[@]}"; do
            echo -e "$suggestion"
        done
        echo ""
    fi
}

# Get zoxide directories (frecent = frequent + recent)
get_zoxide_dirs() {
    if $HAS_ZOXIDE; then
        zoxide query -l 2>/dev/null | head -20 || true
    fi
}

# Get registry entries
get_registry_dirs() {
    if [ -f "$REGISTRY_FILE" ]; then
        cat "$REGISTRY_FILE"
    fi
}

# Add project to registry
add_to_registry() {
    local project="$1"
    
    if [ ! -f "$REGISTRY_FILE" ]; then
        touch "$REGISTRY_FILE"
    fi
    
    # Add if not already present
    if ! grep -Fxq "$project" "$REGISTRY_FILE" 2>/dev/null; then
        echo "$project" >> "$REGISTRY_FILE"
    fi
}

# Interactive project selection
select_project_interactive() {
    echo -e "${BOLD}Select target project:${NC}"
    echo ""
    
    local options=()
    local current_dir="$(pwd)"
    
    # Option 1: Current directory
    options+=("Current directory: $current_dir")
    
    # Option 2: Browse with file picker (only if gum available)
    if $HAS_GUM; then
        options+=("Browse with file picker")
    fi
    
    # Option 3: Recent projects from registry
    local registry_count=0
    if [ -f "$REGISTRY_FILE" ]; then
        registry_count=$(wc -l < "$REGISTRY_FILE" | tr -d ' ')
        if [ "$registry_count" -gt 0 ]; then
            options+=("Recent projects (registry)")
        fi
    fi
    
    # Option 4: Frecent directories from zoxide
    local zoxide_count=0
    if $HAS_ZOXIDE; then
        zoxide_count=$(get_zoxide_dirs | wc -l | tr -d ' ')
        if [ "$zoxide_count" -gt 0 ]; then
            options+=("Frecent directories (zoxide)")
        fi
    fi
    
    # Option 5: Manual path entry
    options+=("Enter path manually")
    
    local choice=""
    
    if $HAS_GUM; then
        choice=$(printf '%s\n' "${options[@]}" | gum choose --header "Where do you want to setup AI skills?")
    else
        PS3="Select option: "
        select choice in "${options[@]}"; do
            [[ -n "$choice" ]] && break
        done
    fi
    
    echo ""
    
    case "$choice" in
        "Current directory:"*)
            TARGET_PROJECT="$current_dir"
            ;;
        "Browse with file picker")
            TARGET_PROJECT=$(gum file --directory)
            ;;
        "Recent projects (registry)")
            local registry_dirs
            mapfile -t registry_dirs < "$REGISTRY_FILE"
            
            if $HAS_GUM; then
                TARGET_PROJECT=$(printf '%s\n' "${registry_dirs[@]}" | gum choose --header "Select from recent projects")
            else
                PS3="Select project: "
                select TARGET_PROJECT in "${registry_dirs[@]}"; do
                    [[ -n "$TARGET_PROJECT" ]] && break
                done
            fi
            ;;
        "Frecent directories (zoxide)")
            local zoxide_dirs
            mapfile -t zoxide_dirs < <(get_zoxide_dirs)
            
            if $HAS_GUM; then
                TARGET_PROJECT=$(printf '%s\n' "${zoxide_dirs[@]}" | gum choose --header "Select from frecent directories")
            else
                PS3="Select directory: "
                select TARGET_PROJECT in "${zoxide_dirs[@]}"; do
                    [[ -n "$TARGET_PROJECT" ]] && break
                done
            fi
            ;;
        "Enter path manually")
            echo -n "Enter project path: "
            read -r TARGET_PROJECT
            TARGET_PROJECT="${TARGET_PROJECT/#\~/$HOME}"  # Expand ~
            ;;
    esac
    
    # Validate target
    if [ -z "$TARGET_PROJECT" ]; then
        echo -e "${RED}No project selected${NC}"
        exit 1
    fi
    
    if [ ! -d "$TARGET_PROJECT" ]; then
        echo -e "${RED}Directory does not exist: $TARGET_PROJECT${NC}"
        exit 1
    fi
    
    # Convert to absolute path
    TARGET_PROJECT="$(cd "$TARGET_PROJECT" && pwd)"
}

# Interactive AI assistant selection
select_assistants_interactive() {
    if $HAS_GUM; then
        echo -e "${BOLD}Which AI assistants do you use?${NC}"
        echo ""
        
        local selected
        selected=$(gum choose --no-limit \
            "Claude Code" \
            "Gemini CLI" \
            "Codex (OpenAI)" \
            "GitHub Copilot")
        
        echo ""
        
        echo "$selected" | grep -q "Claude Code" && SETUP_CLAUDE=true
        echo "$selected" | grep -q "Gemini CLI" && SETUP_GEMINI=true
        echo "$selected" | grep -q "Codex" && SETUP_CODEX=true
        echo "$selected" | grep -q "Copilot" && SETUP_COPILOT=true
    else
        # Fallback: ask one by one
        echo -e "${BOLD}Which AI assistants do you use?${NC}"
        echo ""
        
        echo -n "Configure Claude Code? [Y/n] "
        read -r response
        [[ "$response" =~ ^[Nn]$ ]] || SETUP_CLAUDE=true
        
        echo -n "Configure Gemini CLI? [y/N] "
        read -r response
        [[ "$response" =~ ^[Yy]$ ]] && SETUP_GEMINI=true
        
        echo -n "Configure Codex (OpenAI)? [y/N] "
        read -r response
        [[ "$response" =~ ^[Yy]$ ]] && SETUP_CODEX=true
        
        echo -n "Configure GitHub Copilot? [y/N] "
        read -r response
        [[ "$response" =~ ^[Yy]$ ]] && SETUP_COPILOT=true
        
        echo ""
    fi
}

# Detect project structure
detect_project_structure() {
    local project="$1"
    
    echo -e "${BLUE}Detecting project structure...${NC}"
    
    # Check for AGENTS.md
    if [ -f "$project/AGENTS.md" ]; then
        echo -e "${GREEN}  ✓ Found AGENTS.md at project root${NC}"
    else
        echo -e "${YELLOW}  ⚠ No AGENTS.md found at root${NC}"
    fi
    
    # Check for monorepo structure
    local has_subdirs=false
    for subdir in ui api sdk prowler mcp_server; do
        if [ -d "$project/$subdir" ]; then
            has_subdirs=true
            echo -e "${GREEN}  ✓ Found $subdir/ subdirectory${NC}"
        fi
    done
    
    if $has_subdirs; then
        echo -e "${CYAN}  → Monorepo structure detected${NC}"
    else
        echo -e "${CYAN}  → Single-repo structure detected${NC}"
    fi
    
    echo ""
}

setup_claude() {
    local target="$TARGET_PROJECT/.claude/skills"
    
    if [ ! -d "$TARGET_PROJECT/.claude" ]; then
        mkdir -p "$TARGET_PROJECT/.claude"
    fi
    
    if [ -L "$target" ]; then
        rm "$target"
    elif [ -d "$target" ]; then
        mv "$target" "$TARGET_PROJECT/.claude/skills.backup.$(date +%s)"
    fi
    
    ln -s "$SKILLS_SOURCE" "$target"
    echo -e "${GREEN}  ✓ .claude/skills -> $SKILLS_SOURCE${NC}"
    
    # Copy AGENTS.md to CLAUDE.md
    copy_agents_md "CLAUDE.md"
}

setup_gemini() {
    local target="$TARGET_PROJECT/.gemini/skills"
    
    if [ ! -d "$TARGET_PROJECT/.gemini" ]; then
        mkdir -p "$TARGET_PROJECT/.gemini"
    fi
    
    if [ -L "$target" ]; then
        rm "$target"
    elif [ -d "$target" ]; then
        mv "$target" "$TARGET_PROJECT/.gemini/skills.backup.$(date +%s)"
    fi
    
    ln -s "$SKILLS_SOURCE" "$target"
    echo -e "${GREEN}  ✓ .gemini/skills -> $SKILLS_SOURCE${NC}"
    
    # Copy AGENTS.md to GEMINI.md
    copy_agents_md "GEMINI.md"
}

setup_codex() {
    local target="$TARGET_PROJECT/.codex/skills"
    
    if [ ! -d "$TARGET_PROJECT/.codex" ]; then
        mkdir -p "$TARGET_PROJECT/.codex"
    fi
    
    if [ -L "$target" ]; then
        rm "$target"
    elif [ -d "$target" ]; then
        mv "$target" "$TARGET_PROJECT/.codex/skills.backup.$(date +%s)"
    fi
    
    ln -s "$SKILLS_SOURCE" "$target"
    echo -e "${GREEN}  ✓ .codex/skills -> $SKILLS_SOURCE${NC}"
    echo -e "${GREEN}  ✓ Codex uses AGENTS.md natively${NC}"
}

setup_copilot() {
    if [ -f "$TARGET_PROJECT/AGENTS.md" ]; then
        mkdir -p "$TARGET_PROJECT/.github"
        cp "$TARGET_PROJECT/AGENTS.md" "$TARGET_PROJECT/.github/copilot-instructions.md"
        echo -e "${GREEN}  ✓ AGENTS.md -> .github/copilot-instructions.md${NC}"
    else
        echo -e "${YELLOW}  ⚠ No AGENTS.md found, skipping Copilot setup${NC}"
    fi
}

copy_agents_md() {
    local target_name="$1"
    local agents_files
    local count=0
    
    agents_files=$(find "$TARGET_PROJECT" -name "AGENTS.md" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null || true)
    
    for agents_file in $agents_files; do
        local agents_dir
        agents_dir=$(dirname "$agents_file")
        cp "$agents_file" "$agents_dir/$target_name"
        count=$((count + 1))
    done
    
    if [ $count -gt 0 ]; then
        echo -e "${GREEN}  ✓ Copied $count AGENTS.md -> $target_name${NC}"
    else
        echo -e "${YELLOW}  ⚠ No AGENTS.md files found${NC}"
    fi
}

# =============================================================================
# PARSE ARGUMENTS
# =============================================================================

while [[ $# -gt 0 ]]; do
    case $1 in
        --path)
            TARGET_PROJECT="$2"
            shift 2
            ;;
        --all)
            SETUP_CLAUDE=true
            SETUP_GEMINI=true
            SETUP_CODEX=true
            SETUP_COPILOT=true
            shift
            ;;
        --claude)
            SETUP_CLAUDE=true
            shift
            ;;
        --gemini)
            SETUP_GEMINI=true
            shift
            ;;
        --codex)
            SETUP_CODEX=true
            shift
            ;;
        --copilot)
            SETUP_COPILOT=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# =============================================================================
# MAIN
# =============================================================================

echo "🤖 AI Skills Setup"
echo "=================="
echo ""

# Count available skills
SKILL_COUNT=$(find "$SKILLS_SOURCE" -maxdepth 2 -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')

if [ "$SKILL_COUNT" -eq 0 ]; then
    echo -e "${RED}No skills found in $SKILLS_SOURCE${NC}"
    exit 1
fi

echo -e "${BLUE}Found $SKILL_COUNT skills available${NC}"
echo ""

# Show tool suggestions if any are missing
suggest_tools

# Select target project if not specified
if [ -z "$TARGET_PROJECT" ]; then
    select_project_interactive
else
    # Validate provided path
    TARGET_PROJECT="${TARGET_PROJECT/#\~/$HOME}"  # Expand ~
    if [ ! -d "$TARGET_PROJECT" ]; then
        echo -e "${RED}Directory does not exist: $TARGET_PROJECT${NC}"
        exit 1
    fi
    TARGET_PROJECT="$(cd "$TARGET_PROJECT" && pwd)"
fi

echo -e "${CYAN}Target project: $TARGET_PROJECT${NC}"
echo ""

# Detect project structure
detect_project_structure "$TARGET_PROJECT"

# Select AI assistants if not specified via flags
if [ "$SETUP_CLAUDE" = false ] && [ "$SETUP_GEMINI" = false ] && [ "$SETUP_CODEX" = false ] && [ "$SETUP_COPILOT" = false ]; then
    select_assistants_interactive
fi

# Check if at least one selected
if [ "$SETUP_CLAUDE" = false ] && [ "$SETUP_GEMINI" = false ] && [ "$SETUP_CODEX" = false ] && [ "$SETUP_COPILOT" = false ]; then
    echo -e "${YELLOW}No AI assistants selected. Nothing to do.${NC}"
    exit 0
fi

# Run selected setups
STEP=1
TOTAL=0
[ "$SETUP_CLAUDE" = true ] && TOTAL=$((TOTAL + 1))
[ "$SETUP_GEMINI" = true ] && TOTAL=$((TOTAL + 1))
[ "$SETUP_CODEX" = true ] && TOTAL=$((TOTAL + 1))
[ "$SETUP_COPILOT" = true ] && TOTAL=$((TOTAL + 1))

if [ "$SETUP_CLAUDE" = true ]; then
    echo -e "${YELLOW}[$STEP/$TOTAL] Setting up Claude Code...${NC}"
    setup_claude
    STEP=$((STEP + 1))
fi

if [ "$SETUP_GEMINI" = true ]; then
    echo -e "${YELLOW}[$STEP/$TOTAL] Setting up Gemini CLI...${NC}"
    setup_gemini
    STEP=$((STEP + 1))
fi

if [ "$SETUP_CODEX" = true ]; then
    echo -e "${YELLOW}[$STEP/$TOTAL] Setting up Codex (OpenAI)...${NC}"
    setup_codex
    STEP=$((STEP + 1))
fi

if [ "$SETUP_COPILOT" = true ]; then
    echo -e "${YELLOW}[$STEP/$TOTAL] Setting up GitHub Copilot...${NC}"
    setup_copilot
fi

# =============================================================================
# SUMMARY
# =============================================================================
echo ""
echo -e "${GREEN}✅ Successfully configured $SKILL_COUNT AI skills!${NC}"
echo ""
echo "Configured in: $TARGET_PROJECT"
[ "$SETUP_CLAUDE" = true ] && echo "  • Claude Code:    .claude/skills/ + CLAUDE.md"
[ "$SETUP_CODEX" = true ] && echo "  • Codex (OpenAI): .codex/skills/ + AGENTS.md (native)"
[ "$SETUP_GEMINI" = true ] && echo "  • Gemini CLI:     .gemini/skills/ + GEMINI.md"
[ "$SETUP_COPILOT" = true ] && echo "  • GitHub Copilot: .github/copilot-instructions.md"
echo ""

# Offer to save to registry
if [ -f "$REGISTRY_FILE" ]; then
    if ! grep -Fxq "$TARGET_PROJECT" "$REGISTRY_FILE" 2>/dev/null; then
        if $HAS_GUM; then
            if gum confirm "Save this project to registry for quick access?"; then
                add_to_registry "$TARGET_PROJECT"
                echo -e "${GREEN}✓ Added to registry${NC}"
            fi
        else
            echo -n "Save this project to registry for quick access? [Y/n] "
            read -r response
            if [[ ! "$response" =~ ^[Nn]$ ]]; then
                add_to_registry "$TARGET_PROJECT"
                echo -e "${GREEN}✓ Added to registry${NC}"
            fi
        fi
    fi
else
    add_to_registry "$TARGET_PROJECT"
    echo -e "${GREEN}✓ Created registry and added project${NC}"
fi

echo ""
echo -e "${BLUE}Note: Restart your AI assistant to load the skills.${NC}"
echo -e "${BLUE}      Run this script again anytime to update or add more assistants.${NC}"
