#!/bin/bash
# author: mrp4sten

# Clean everything (packages and metadata), and update the metadata
clean() {
  sudo dnf clean all
  sudo dnf makecache
}

# Clean the old kernels installed in Fedora43
clean_kernels() {
  local keep="${1:-2}"
  local current
  current="$(uname -r)"

  local kernels=()
  while IFS= read -r k; do
    kernels+=("$k")
  done < <(
    rpm -q kernel-core \
    | sed 's/^kernel-core-//' \
    | sort -V -r
  )

  local count=0
  for k in "${kernels[@]}"; do
    ((count++))
    if (( count <= keep )); then
      continue
    fi
    if [[ "$k" == "$current" ]]; then
      continue
    fi

    echo "Removing kernel $k"
    sudo dnf remove \
      "kernel-core-$k" \
      "kernel-modules-$k" \
      "kernel-modules-extra-$k"
  done
}



# Create config developer files (.gitignore, .prettierrc, .htmlhintrc, .stylelintrc, webpack.config.js, etc.)
config_craft() {
  CONFIG_CRAFT=~/.dotfiles/automation/generators/config-craft/config-craft.sh
  bash $CONFIG_CRAFT
}

# Create a desktop entry file on Linux OS
# Usage: desktop_craft [--appimage | --manual]
desktop_craft() {
  local DESKTOP_CRAFT=~/.dotfiles/automation/install/desktop-craft.sh
  bash "${DESKTOP_CRAFT}" "$@"
}

# Setup AI skills in a project
# Usage: skills_setup [--path /path/to/project] [--all | --claude | --gemini | --codex | --copilot]
skills_setup() {
  local SKILLS_SETUP=~/.dotfiles/development/IA/opencode/skill/setup.sh
  bash "${SKILLS_SETUP}" "$@"
}

# Sync skill metadata to AGENTS.md Auto-invoke sections
# Usage: skills_sync [--path /path/to/project] [--dry-run] [--scope root|ui|api|sdk|mcp_server]
skills_sync() {
  local SKILLS_SYNC=~/.dotfiles/development/IA/opencode/skill/sync.sh
  bash "${SKILLS_SYNC}" "$@"
}
