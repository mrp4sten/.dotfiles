#!/bin/bash
#author: mrp4sten

# Clean the cache of pacman and aur packages on Arch linux OS
clean() {
  sudo dnf clean
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
