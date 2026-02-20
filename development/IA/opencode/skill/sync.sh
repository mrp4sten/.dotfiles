#!/usr/bin/env bash
# author: mrp4sten
# Sync skill metadata to AGENTS.md Auto-invoke sections
#
# Usage:
#   ./sync.sh                           # Interactive mode
#   ./sync.sh --path /path/to/project   # Sync specific project
#   ./sync.sh --dry-run                 # Show changes without applying
#   ./sync.sh --scope root              # Only sync specific scope
#
# Optional dependencies (with graceful fallbacks):
#   - gum: Better interactive menus (fallback: bash select)
#   - zoxide: Suggest frecent directories (fallback: manual path entry)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR"
REGISTRY_FILE="$SCRIPT_DIR/.skill-registry"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Feature detection
HAS_GUM=false
HAS_ZOXIDE=false
command -v gum >/dev/null 2>&1 && HAS_GUM=true
command -v zoxide >/dev/null 2>&1 && HAS_ZOXIDE=true

# Configuration
TARGET_PROJECT=""
DRY_RUN=false
FILTER_SCOPE=""

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Sync skill metadata to AGENTS.md Auto-invoke sections."
    echo ""
    echo "Options:"
    echo "  --path PATH  Target project directory (default: interactive selection)"
    echo "  --dry-run    Show what would change without modifying files"
    echo "  --scope      Only sync specific scope (root, ui, api, sdk, mcp_server)"
    echo "  --help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                # Interactive mode"
    echo "  $0 --path ~/projects/my-app       # Sync specific project"
    echo "  $0 --dry-run --scope root         # Preview root scope changes"
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

get_zoxide_dirs() {
    if $HAS_ZOXIDE; then
        zoxide query -l 2>/dev/null | head -20 || true
    fi
}

get_registry_dirs() {
    if [ -f "$REGISTRY_FILE" ]; then
        cat "$REGISTRY_FILE"
    fi
}

select_project_interactive() {
    echo -e "${BOLD}Select target project to sync:${NC}"
    echo ""
    
    local options=()
    local current_dir="$(pwd)"
    
    options+=("Current directory: $current_dir")
    
    if $HAS_GUM; then
        options+=("Browse with file picker")
    fi
    
    local registry_count=0
    if [ -f "$REGISTRY_FILE" ]; then
        registry_count=$(wc -l < "$REGISTRY_FILE" | tr -d ' ')
        if [ "$registry_count" -gt 0 ]; then
            options+=("Recent projects (registry)")
        fi
    fi
    
    local zoxide_count=0
    if $HAS_ZOXIDE; then
        zoxide_count=$(get_zoxide_dirs | wc -l | tr -d ' ')
        if [ "$zoxide_count" -gt 0 ]; then
            options+=("Frecent directories (zoxide)")
        fi
    fi
    
    options+=("Enter path manually")
    
    local choice=""
    
    if $HAS_GUM; then
        choice=$(printf '%s\n' "${options[@]}" | gum choose --header "Which project do you want to sync?")
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
            TARGET_PROJECT="${TARGET_PROJECT/#\~/$HOME}"
            ;;
    esac
    
    if [ -z "$TARGET_PROJECT" ]; then
        echo -e "${RED}No project selected${NC}"
        exit 1
    fi
    
    if [ ! -d "$TARGET_PROJECT" ]; then
        echo -e "${RED}Directory does not exist: $TARGET_PROJECT${NC}"
        exit 1
    fi
    
    TARGET_PROJECT="$(cd "$TARGET_PROJECT" && pwd)"
}

# Map scope to AGENTS.md path (auto-detect project structure)
get_agents_path() {
    local scope="$1"
    local candidate=""
    
    case "$scope" in
        root)
            candidate="$TARGET_PROJECT/AGENTS.md"
            ;;
        ui)
            candidate="$TARGET_PROJECT/ui/AGENTS.md"
            ;;
        api)
            candidate="$TARGET_PROJECT/api/AGENTS.md"
            ;;
        sdk)
            # Try prowler/ first, fallback to sdk/
            if [ -f "$TARGET_PROJECT/prowler/AGENTS.md" ]; then
                candidate="$TARGET_PROJECT/prowler/AGENTS.md"
            elif [ -f "$TARGET_PROJECT/sdk/AGENTS.md" ]; then
                candidate="$TARGET_PROJECT/sdk/AGENTS.md"
            fi
            ;;
        mcp_server)
            candidate="$TARGET_PROJECT/mcp_server/AGENTS.md"
            ;;
    esac
    
    # Only return if file exists
    if [ -n "$candidate" ] && [ -f "$candidate" ]; then
        echo "$candidate"
    fi
}

# Extract YAML frontmatter field using awk
extract_field() {
    local file="$1"
    local field="$2"
    awk -v field="$field" '
        /^---$/ { in_frontmatter = !in_frontmatter; next }
        in_frontmatter && $1 == field":" {
            sub(/^[^:]+:[[:space:]]*/, "")
            if ($0 != "" && $0 != ">") {
                gsub(/^["'\'']|["'\'']$/, "")
                print
                exit
            }
            getline
            while (/^[[:space:]]/ && !/^---$/) {
                sub(/^[[:space:]]+/, "")
                printf "%s ", $0
                if (!getline) break
            }
            print ""
            exit
        }
    ' "$file" | sed 's/[[:space:]]*$//'
}

# Extract nested metadata field
extract_metadata() {
    local file="$1"
    local field="$2"

    awk -v field="$field" '
        function trim(s) {
            sub(/^[[:space:]]+/, "", s)
            sub(/[[:space:]]+$/, "", s)
            return s
        }

        /^---$/ { in_frontmatter = !in_frontmatter; next }

        in_frontmatter && /^metadata:/ { in_metadata = 1; next }
        in_frontmatter && in_metadata && /^[a-z]/ && !/^[[:space:]]/ { in_metadata = 0 }

        in_frontmatter && in_metadata && $1 == field":" {
            sub(/^[^:]+:[[:space:]]*/, "")

            if ($0 != "") {
                v = $0
                gsub(/^["'\'']|["'\'']$/, "", v)
                gsub(/^\[|\]$/, "", v)
                print trim(v)
                exit
            }

            out = ""
            while (getline) {
                if (!in_frontmatter) break
                if (!in_metadata) break
                if ($0 ~ /^[a-z]/ && $0 !~ /^[[:space:]]/) break

                line = $0
                if (line ~ /^---$/) break
                if (line ~ /^[[:space:]]*-[[:space:]]*/) {
                    sub(/^[[:space:]]*-[[:space:]]*/, "", line)
                    line = trim(line)
                    gsub(/^["'\'']|["'\'']$/, "", line)
                    if (line != "") {
                        if (out == "") out = line
                        else out = out "|" line
                    }
                } else {
                    break
                }
            }

            if (out != "") print out
            exit
        }
    ' "$file"
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
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --scope)
            FILTER_SCOPE="$2"
            shift 2
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

echo -e "${BLUE}Skill Sync - Updating AGENTS.md Auto-invoke sections${NC}"
echo "========================================================"
echo ""

# Show tool suggestions if any are missing
suggest_tools

# Select target project if not specified
if [ -z "$TARGET_PROJECT" ]; then
    select_project_interactive
else
    TARGET_PROJECT="${TARGET_PROJECT/#\~/$HOME}"
    if [ ! -d "$TARGET_PROJECT" ]; then
        echo -e "${RED}Directory does not exist: $TARGET_PROJECT${NC}"
        exit 1
    fi
    TARGET_PROJECT="$(cd "$TARGET_PROJECT" && pwd)"
fi

echo -e "${CYAN}Target project: $TARGET_PROJECT${NC}"
echo ""

# Collect skills by scope
declare -A SCOPE_SKILLS

while IFS= read -r skill_file; do
    [ -f "$skill_file" ] || continue

    skill_name=$(extract_field "$skill_file" "name")
    scope_raw=$(extract_metadata "$skill_file" "scope")

    auto_invoke_raw=$(extract_metadata "$skill_file" "auto_invoke")
    auto_invoke=${auto_invoke_raw//|/;;}

    [ -z "$scope_raw" ] || [ -z "$auto_invoke" ] && continue

    IFS=', ' read -ra scopes <<< "$scope_raw"

    for scope in "${scopes[@]}"; do
        scope=$(echo "$scope" | tr -d '[:space:]')
        [ -z "$scope" ] && continue

        [ -n "$FILTER_SCOPE" ] && [ "$scope" != "$FILTER_SCOPE" ] && continue

        if [ -z "${SCOPE_SKILLS[$scope]}" ]; then
            SCOPE_SKILLS[$scope]="$skill_name:$auto_invoke"
        else
            SCOPE_SKILLS[$scope]="${SCOPE_SKILLS[$scope]}|$skill_name:$auto_invoke"
        fi
    done
done < <(find "$SKILLS_DIR" -mindepth 2 -maxdepth 2 -name SKILL.md -print 2>/dev/null | sort)

# Generate Auto-invoke section for each scope
scopes_sorted=()
while IFS= read -r scope; do
    scopes_sorted+=("$scope")
done < <(printf "%s\n" "${!SCOPE_SKILLS[@]}" | sort)

synced_count=0

for scope in "${scopes_sorted[@]}"; do
    agents_path=$(get_agents_path "$scope")

    if [ -z "$agents_path" ]; then
        echo -e "${YELLOW}Warning: No AGENTS.md found for scope '$scope' in $TARGET_PROJECT${NC}"
        continue
    fi

    echo -e "${BLUE}Processing: $scope -> $(basename "$(dirname "$agents_path")")/AGENTS.md${NC}"

    # Build the Auto-invoke table
    auto_invoke_section="### Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action | Skill |
|--------|-------|"

    rows=()

    IFS='|' read -ra skill_entries <<< "${SCOPE_SKILLS[$scope]}"
    for entry in "${skill_entries[@]}"; do
        skill_name="${entry%%:*}"
        actions_raw="${entry#*:}"

        actions_raw=${actions_raw//;;/|}
        IFS='|' read -ra actions <<< "$actions_raw"
        for action in "${actions[@]}"; do
            action="$(echo "$action" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
            [ -z "$action" ] && continue
            rows+=("$action	$skill_name")
        done
    done

    while IFS=$'\t' read -r action skill_name; do
        [ -z "$action" ] && continue
        auto_invoke_section="$auto_invoke_section
| $action | \`$skill_name\` |"
    done < <(printf "%s\n" "${rows[@]}" | LC_ALL=C sort -t $'\t' -k1,1 -k2,2)

    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY RUN] Would update $agents_path with:${NC}"
        echo "$auto_invoke_section"
        echo ""
    else
        section_file=$(mktemp)
        echo "$auto_invoke_section" > "$section_file"

        if grep -q "### Auto-invoke Skills" "$agents_path"; then
            # Replace existing section
            awk '
                /^### Auto-invoke Skills/ {
                    while ((getline line < "'"$section_file"'") > 0) print line
                    close("'"$section_file"'")
                    skip = 1
                    next
                }
                skip && /^(---|## )/ {
                    skip = 0
                    print ""
                }
                !skip { print }
            ' "$agents_path" > "$agents_path.tmp"
            mv "$agents_path.tmp" "$agents_path"
            echo -e "${GREEN}  ✓ Updated Auto-invoke section${NC}"
        else
            # Insert after Skills Reference blockquote
            awk '
                /^>.*SKILL\.md\)$/ && !inserted {
                    print
                    getline
                    if (/^$/) {
                        print ""
                        while ((getline line < "'"$section_file"'") > 0) print line
                        close("'"$section_file"'")
                        print ""
                        inserted = 1
                        next
                    }
                }
                { print }
            ' "$agents_path" > "$agents_path.tmp"
            mv "$agents_path.tmp" "$agents_path"
            echo -e "${GREEN}  ✓ Inserted Auto-invoke section${NC}"
        fi

        rm -f "$section_file"
        synced_count=$((synced_count + 1))
    fi
done

echo ""

if $DRY_RUN; then
    echo -e "${YELLOW}Dry run completed - no files modified${NC}"
else
    echo -e "${GREEN}Done! Synced $synced_count scope(s)${NC}"
fi

# Show skills without metadata
echo ""
echo -e "${BLUE}Skills missing sync metadata:${NC}"
missing=0
while IFS= read -r skill_file; do
    [ -f "$skill_file" ] || continue
    skill_name=$(extract_field "$skill_file" "name")
    scope_raw=$(extract_metadata "$skill_file" "scope")
    auto_invoke_raw=$(extract_metadata "$skill_file" "auto_invoke")
    auto_invoke=${auto_invoke_raw//|/;;}

    if [ -z "$scope_raw" ] || [ -z "$auto_invoke" ]; then
        echo -e "  ${YELLOW}$skill_name${NC} - missing: ${scope_raw:+}${scope_raw:-scope} ${auto_invoke:+}${auto_invoke:-auto_invoke}"
        missing=$((missing + 1))
    fi
done < <(find "$SKILLS_DIR" -mindepth 2 -maxdepth 2 -name SKILL.md -print 2>/dev/null | sort)

if [ $missing -eq 0 ]; then
    echo -e "  ${GREEN}All skills have sync metadata${NC}"
fi
