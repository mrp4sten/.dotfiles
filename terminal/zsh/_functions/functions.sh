#!/bin/bash
#author: mrp4sten

clean() {
  paccache=~/.dotfiles/terminal/zsh/scripts/paccache-clear.sh
  echo $paccache

  sudo pacman -Scc
  bash $paccache
}

add-config-files() {
  script=~/.dotfiles/terminal/zsh/scripts/initial-config-files/initial-config-files.sh
  bash $script
}
