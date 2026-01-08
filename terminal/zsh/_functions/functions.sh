#!/bin/bash
#author: mrp4sten

# Clean everything (packages and metadata), and update the metadata
clean() {
  sudo dnf clean all
  sudo dnf makecache
}

# Clean the old kernels installed in Fedora43
clean_knls() {
  sudo dnf remove $(dnf repoquery --installonly --latest-limit=-2 -q)
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
