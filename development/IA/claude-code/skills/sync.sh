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

# Discover all AGENTS.md and SUBAGENT files in the target project
# Returns an associative array: scope -> file_path
# 
# Supported patterns:
#   AGENTS.md (root)           -> scope: root
#   SUBAGENT-{name}.md (root)  -> scope: {name}
#   {dir}/SUBAGENT.md          -> scope: {dir}
#   {dir}/AGENTS.md            -> scope: {dir}
#
# Example results:
#   root       -> /path/to/project/AGENTS.md
#   shell      -> /path/to/project/core/shell/SUBAGENT.md
#   automation -> /path/to/project/automation/SUBAGENT.md
#   ui         -> /path/to/project/ui/AGENTS.md
discover_agent_files() {
    declare -gA AGENT_FILES
    
    # Find root AGENTS.md
    if [ -f "$TARGET_PROJECT/AGENTS.md" ]; then
        AGENT_FILES["root"]="$TARGET_PROJECT/AGENTS.md"
    fi
    
    # Find all SUBAGENT-*.md files in root (with explicit name suffix)
    while IFS= read -r subagent_file; do
        # Only process files in project root, not subdirectories
        local file_dir
        file_dir=$(dirname "$subagent_file")
        [ "$file_dir" != "$TARGET_PROJECT" ] && continue
        
        local filename
        filename=$(basename "$subagent_file")
        
        # Extract scope from SUBAGENT-{scope}.md
        if [[ "$filename" =~ ^SUBAGENT-(.+)\.md$ ]]; then
            local scope="${BASH_REMATCH[1]}"
            AGENT_FILES["$scope"]="$subagent_file"
        fi
    done < <(find "$TARGET_PROJECT" -type f -name "SUBAGENT-*.md" 2>/dev/null)
    
    # Find all SUBAGENT.md files in subdirectories (no suffix)
    while IFS= read -r subagent_file; do
        # Skip root SUBAGENT.md if it exists
        [ "$subagent_file" = "$TARGET_PROJECT/SUBAGENT.md" ] && continue
        
        # Get relative path from project root
        local rel_path="${subagent_file#$TARGET_PROJECT/}"
        local parent_dir
        parent_dir=$(dirname "$rel_path")
        
        # Use directory path as scope (e.g., "core/shell" or "automation")
        # Remove leading/trailing slashes
        parent_dir="${parent_dir#/}"
        parent_dir="${parent_dir%/}"
        
        # Convert path to scope name (replace / with -)
        local scope="${parent_dir//\//-}"
        
        AGENT_FILES["$scope"]="$subagent_file"
    done < <(find "$TARGET_PROJECT" -mindepth 2 -type f -name "SUBAGENT.md" 2>/dev/null)
    
    # Find component-level AGENTS.md files (ui, api, sdk, etc.)
    while IFS= read -r agents_file; do
        # Skip root AGENTS.md (already handled)
        [ "$agents_file" = "$TARGET_PROJECT/AGENTS.md" ] && continue
        
        # Get relative path from project root
        local rel_path="${agents_file#$TARGET_PROJECT/}"
        local parent_dir
        parent_dir=$(dirname "$rel_path")
        
        # Use directory name as scope
        parent_dir="${parent_dir#/}"
        parent_dir="${parent_dir%/}"
        
        # Convert path to scope name (replace / with -)
        local scope="${parent_dir//\//-}"
        
        AGENT_FILES["$scope"]="$agents_file"
    done < <(find "$TARGET_PROJECT" -mindepth 2 -type f -name "AGENTS.md" 2>/dev/null)
}

# Map scope to AGENTS.md path (uses discovered files)
get_agents_path() {
    local scope="$1"
    echo "${AGENT_FILES[$scope]:-}"
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

# Generate Available Skills section (all skills with description + URL)
generate_available_skills_section() {
    local section="## Available Skills

Use these skills for detailed patterns on-demand:

| Skill | Description | URL |
|-------|-------------|-----|"

    local rows=()
    
    # Collect all skills
    while IFS= read -r skill_file; do
        [ -f "$skill_file" ] || continue
        
        local skill_name
        local skill_desc
        local skill_path
        
        skill_name=$(extract_field "$skill_file" "name")
        skill_desc=$(extract_field "$skill_file" "description")
        
        # Make path relative to dotfiles
        skill_path=$(echo "$skill_file" | sed "s|$HOME|~|")
        
        [ -z "$skill_name" ] && continue
        [ -z "$skill_desc" ] && skill_desc="No description"
        
        # Truncate long descriptions
        if [ ${#skill_desc} -gt 80 ]; then
            skill_desc="${skill_desc:0:77}..."
        fi
        
        rows+=("$skill_name	$skill_desc	$skill_path")
    done < <(find "$SKILLS_DIR" -mindepth 2 -maxdepth 2 -name SKILL.md -print 2>/dev/null | sort)
    
    # Sort rows by skill name
    while IFS=$'\t' read -r skill_name skill_desc skill_path; do
        [ -z "$skill_name" ] && continue
        section="$section
| \`$skill_name\` | $skill_desc | [SKILL.md]($skill_path) |"
    done < <(printf "%s\n" "${rows[@]}" | LC_ALL=C sort -t $'\t' -k1,1)
    
    echo "$section"
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

# Discover all agent files in the target project
discover_agent_files

if [ ${#AGENT_FILES[@]} -eq 0 ]; then
    echo -e "${RED}No AGENTS.md or SUBAGENT-*.md files found in $TARGET_PROJECT${NC}"
    exit 1
fi

echo -e "${GREEN}Discovered ${#AGENT_FILES[@]} agent file(s):${NC}"
for scope in "${!AGENT_FILES[@]}"; do
    echo -e "  ${BLUE}$scope${NC} -> ${AGENT_FILES[$scope]}"
done
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

# =============================================================================
# STEP 1: Insert/Update "Available Skills" section in root AGENTS.md ONLY
# =============================================================================

if [ -n "${AGENT_FILES[root]}" ]; then
    root_agents="${AGENT_FILES[root]}"
    
    echo -e "${BLUE}Step 1: Updating Available Skills in root AGENTS.md${NC}"
    echo -e "${BLUE}Processing: root -> $(basename "$root_agents")${NC}"
    
    available_skills_section=$(generate_available_skills_section)
    
    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY RUN] Would update $root_agents with Available Skills section${NC}"
        echo "$available_skills_section"
        echo ""
    else
        section_file=$(mktemp)
        echo "$available_skills_section" > "$section_file"
        
        if grep -q "^## Available Skills" "$root_agents"; then
            # Replace existing section (up to next ## heading or ---)
            awk '
                /^## Available Skills/ {
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
            ' "$root_agents" > "$root_agents.tmp"
            mv "$root_agents.tmp" "$root_agents"
            echo -e "${GREEN}  ✓ Updated Available Skills section${NC}"
        else
            # Insert at the beginning after YAML frontmatter (if present) or at top
            awk '
                BEGIN { inserted = 0 }
                /^---$/ && NR == 1 { in_frontmatter = 1; print; next }
                /^---$/ && in_frontmatter { 
                    print
                    print ""
                    while ((getline line < "'"$section_file"'") > 0) print line
                    close("'"$section_file"'")
                    print ""
                    inserted = 1
                    next
                }
                NR == 1 && !inserted {
                    while ((getline line < "'"$section_file"'") > 0) print line
                    close("'"$section_file"'")
                    print ""
                    inserted = 1
                }
                { print }
            ' "$root_agents" > "$root_agents.tmp"
            mv "$root_agents.tmp" "$root_agents"
            echo -e "${GREEN}  ✓ Inserted Available Skills section${NC}"
        fi
        
        rm -f "$section_file"
    fi
    
    echo ""
fi

# =============================================================================
# STEP 2: Insert/Update "Auto-invoke Skills" section in ALL discovered files
# =============================================================================

echo -e "${BLUE}Step 2: Updating Auto-invoke Skills sections${NC}"

# Generate Auto-invoke section for each scope
scopes_sorted=()
while IFS= read -r scope; do
    scopes_sorted+=("$scope")
done < <(printf "%s\n" "${!SCOPE_SKILLS[@]}" | sort)

synced_count=0

for scope in "${scopes_sorted[@]}"; do
    agents_path=$(get_agents_path "$scope")

    # Skip scopes that don't exist in this project (silent)
    if [ -z "$agents_path" ]; then
        continue
    fi

    echo -e "${BLUE}Processing: $scope -> $(basename "$agents_path")${NC}"

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
            # Insert after Available Skills section or any ## heading
            # Strategy:
            # 1. If ## Available Skills exists, insert right after the FULL table
            # 2. Otherwise, insert after any >.*SKILL.md pattern (old format)
            # 3. Otherwise, insert at the beginning
            awk '
                BEGIN { inserted = 0; in_table = 0 }
                
                # Detect Available Skills section start
                /^## Available Skills/ { 
                    in_available_skills = 1
                    print
                    next
                }
                
                # Detect table start (header separator line)
                in_available_skills && /^\|[-:| ]+\|$/ {
                    in_table = 1
                    print
                    next
                }
                
                # After table ends (first blank line after table rows)
                in_available_skills && in_table && /^$/ && !inserted {
                    print
                    while ((getline line < "'"$section_file"'") > 0) print line
                    close("'"$section_file"'")
                    print ""
                    inserted = 1
                    in_available_skills = 0
                    in_table = 0
                    next
                }
                
                # Stop tracking if we hit another ## heading without inserting
                /^## / && in_available_skills && !inserted {
                    in_available_skills = 0
                    in_table = 0
                }
                
                # Fallback: after blockquote pattern (old format)
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
