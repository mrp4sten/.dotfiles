#!/bin/bash
# author: mrp4sten
# Claude Code Configuration Installer

set -euo pipefail

DOTFILES_DIR="${HOME}/.dotfiles"
CLAUDE_DIR="${HOME}/.claude"
CLAUDE_CODE_DIR="${DOTFILES_DIR}/development/IA/claude-code"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Check if Claude Code is installed
check_claude_installed() {
    if ! command -v claude &> /dev/null; then
        print_error "Claude Code is not installed"
        print_info "Installing Claude Code..."
        curl -fsSL https://claude.ai/install.sh | bash
        
        # Add to PATH if needed
        if [[ ":$PATH:" != *":${HOME}/.local/bin:"* ]]; then
            print_info "Adding ~/.local/bin to PATH in ~/.bashrc and ~/.zshrc"
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            [[ -f ~/.zshrc ]] && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
            export PATH="${HOME}/.local/bin:$PATH"
        fi
        
        print_success "Claude Code installed"
    else
        print_success "Claude Code is already installed ($(claude --version 2>&1 | head -1))"
    fi
}

# Backup existing configuration
backup_existing_config() {
    local backup_dir="${CLAUDE_DIR}/backups/$(date +%Y%m%d_%H%M%S)"
    
    if [[ -d "${CLAUDE_DIR}/skills" ]] || [[ -f "${CLAUDE_DIR}/settings.json" ]]; then
        print_info "Backing up existing configuration to ${backup_dir}"
        mkdir -p "${backup_dir}"
        
        [[ -d "${CLAUDE_DIR}/skills" ]] && cp -r "${CLAUDE_DIR}/skills" "${backup_dir}/"
        [[ -f "${CLAUDE_DIR}/settings.json" ]] && cp "${CLAUDE_DIR}/settings.json" "${backup_dir}/"
        
        print_success "Backup created"
    fi
}

# Link skills directory
link_skills() {
    print_info "Linking skills directory..."
    
    if [[ -L "${CLAUDE_DIR}/skills" ]]; then
        rm "${CLAUDE_DIR}/skills"
    elif [[ -d "${CLAUDE_DIR}/skills" ]]; then
        mv "${CLAUDE_DIR}/skills" "${CLAUDE_DIR}/skills.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    ln -sf "${CLAUDE_CODE_DIR}/skills" "${CLAUDE_DIR}/skills"
    print_success "Skills linked from dotfiles"
}

# Merge settings.json
merge_settings() {
    print_info "Merging settings.json..."
    
    local dotfiles_settings="${CLAUDE_CODE_DIR}/settings.json"
    local claude_settings="${CLAUDE_DIR}/settings.json"
    
    if [[ -f "${claude_settings}" ]]; then
        # Backup current settings
        cp "${claude_settings}" "${claude_settings}.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Merge with jq if available, otherwise replace
        if command -v jq &> /dev/null; then
            jq -s '.[0] * .[1]' "${claude_settings}" "${dotfiles_settings}" > "${claude_settings}.tmp"
            mv "${claude_settings}.tmp" "${claude_settings}"
            print_success "Settings merged (keeping your existing Engram config)"
        else
            print_warning "jq not found, replacing settings.json entirely"
            cp "${dotfiles_settings}" "${claude_settings}"
            print_success "Settings replaced"
        fi
    else
        cp "${dotfiles_settings}" "${claude_settings}"
        print_success "Settings created"
    fi
}

# Link global CLAUDE.md
link_global_claude_md() {
    print_info "Linking global CLAUDE.md..."
    
    if [[ -L "${HOME}/CLAUDE.md" ]]; then
        rm "${HOME}/CLAUDE.md"
    elif [[ -f "${HOME}/CLAUDE.md" ]]; then
        mv "${HOME}/CLAUDE.md" "${HOME}/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    ln -sf "${CLAUDE_CODE_DIR}/CLAUDE.md" "${HOME}/CLAUDE.md"
    print_success "Global CLAUDE.md linked"
}

# Create shell aliases
create_aliases() {
    print_info "Creating shell aliases..."
    
    local alias_block='
# Claude Code aliases
alias lenny="claude --agent lenny"
alias gentleman="claude --agent gentleman"
alias cl="claude"
'
    
    if [[ -f ~/.zshrc ]] && ! grep -q "# Claude Code aliases" ~/.zshrc; then
        echo "${alias_block}" >> ~/.zshrc
        print_success "Aliases added to ~/.zshrc"
    fi
    
    if [[ -f ~/.bashrc ]] && ! grep -q "# Claude Code aliases" ~/.bashrc; then
        echo "${alias_block}" >> ~/.bashrc
        print_success "Aliases added to ~/.bashrc"
    fi
}

# Verify installation
verify_installation() {
    print_header "Verifying Installation"
    
    local errors=0
    
    # Check Claude CLI
    if command -v claude &> /dev/null; then
        print_success "Claude Code CLI: $(claude --version 2>&1 | head -1)"
    else
        print_error "Claude Code CLI not found"
        ((errors++))
    fi
    
    # Check skills symlink
    if [[ -L "${CLAUDE_DIR}/skills" ]] && [[ -d "${CLAUDE_DIR}/skills" ]]; then
        local skill_count=$(find "${CLAUDE_DIR}/skills" -maxdepth 1 -type d | wc -l)
        print_success "Skills directory: ${skill_count} skills available"
    else
        print_error "Skills directory not linked correctly"
        ((errors++))
    fi
    
    # Check settings.json
    if [[ -f "${CLAUDE_DIR}/settings.json" ]]; then
        print_success "Settings file: ${CLAUDE_DIR}/settings.json"
    else
        print_error "Settings file not found"
        ((errors++))
    fi
    
    # Check global CLAUDE.md
    if [[ -L "${HOME}/CLAUDE.md" ]] && [[ -f "${HOME}/CLAUDE.md" ]]; then
        print_success "Global CLAUDE.md: linked"
    else
        print_warning "Global CLAUDE.md not linked (optional)"
    fi
    
    # Check agent files
    if [[ -f "${CLAUDE_CODE_DIR}/agents/lenny.md" ]] && [[ -f "${CLAUDE_CODE_DIR}/agents/gentleman.md" ]]; then
        print_success "Agent prompts: lenny.md, gentleman.md"
    else
        print_error "Agent prompt files not found"
        ((errors++))
    fi
    
    echo ""
    if [[ ${errors} -eq 0 ]]; then
        print_success "All checks passed!"
    else
        print_error "${errors} error(s) found"
        return 1
    fi
}

# Print next steps
print_next_steps() {
    print_header "Next Steps"
    
    echo "1. Authenticate with Anthropic (if not already done):"
    echo "   ${BLUE}claude auth login${NC}"
    echo ""
    echo "2. Test the Lenny agent:"
    echo "   ${BLUE}lenny${NC}"
    echo "   or"
    echo "   ${BLUE}claude --agent lenny${NC}"
    echo ""
    echo "3. Test the Gentleman agent:"
    echo "   ${BLUE}gentleman${NC}"
    echo "   or"
    echo "   ${BLUE}claude --agent gentleman${NC}"
    echo ""
    echo "4. Load a skill in a session:"
    echo "   ${BLUE}claude${NC}"
    echo "   ${YELLOW}/skill tdd${NC}"
    echo ""
    echo "5. Continue your last session:"
    echo "   ${BLUE}claude --continue${NC}"
    echo ""
    echo "6. (Optional) Enable Context7 by adding your API key to:"
    echo "   ${BLUE}~/.claude/settings.json${NC}"
    echo ""
    echo "For more info, see:"
    echo "   ${BLUE}~/.dotfiles/development/IA/claude-code/README.md${NC}"
    echo ""
}

# Main installation flow
main() {
    print_header "Claude Code Configuration Installer"
    
    # Check prerequisites
    if [[ ! -d "${DOTFILES_DIR}" ]]; then
        print_error "Dotfiles directory not found: ${DOTFILES_DIR}"
        exit 1
    fi
    
    if [[ ! -d "${CLAUDE_CODE_DIR}" ]]; then
        print_error "Claude Code config directory not found: ${CLAUDE_CODE_DIR}"
        exit 1
    fi
    
    # Run installation steps
    check_claude_installed
    backup_existing_config
    link_skills
    merge_settings
    link_global_claude_md
    create_aliases
    
    # Verify
    verify_installation
    
    # Print next steps
    print_next_steps
    
    print_success "Installation complete!"
}

# Run
main "$@"
