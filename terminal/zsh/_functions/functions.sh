#!/bin/bash
#author: mrp4sten

# Clean everything (packages and metadata), and update the metadata
clean() {
  sudo dnf clean all
  sudo dnf makecache
}

# Clean the old kernels installed in Fedora43
clean_knls() {
  local keep_count="$1"
  local packages

  packages=$(sudo dnf repoquery --installonly --latest-limit=-"$keep_count" -q 2>/dev/null)

  if [[ -z "$packages" ]]; then
    echo "No old kernels to remove (keeping $keep_count most recent)"
    return 0
  fi

  echo "Removing old kernels (keeping $keep_count most recent):"
  echo "$packages"

  sudo dnf remove $packages
}

# Create config developer files (.gitignore, .prettierrc, .htmlhintrc, .stylelintrc, webpack.config.js, etc.)
config_craft() {
  CONFIG_CRAFT=~/.dotfiles/terminal/zsh/scripts/config-craft/config-craft.sh
  bash $CONFIG_CRAFT
}

# Create a desktop entry file on Linuz OS
desktop_craft() {
  DESKTOP_CRAFT=~/.dotfiles/terminal/zsh/scripts/desktop-craft.sh
  bash $DESKTOP_CRAFT
}
