#!/bin/bash
#author: mrp4sten

clean() {
  paccache=~/.dotfiles/terminal/zsh/scripts/paccache-clear.sh
  echo $paccache

  sudo pacman -Scc
  bash $paccache
}
