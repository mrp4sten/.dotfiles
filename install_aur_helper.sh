#!/bin/bash
# author: Mauricio Pasten (mrp4sten)

# Utilities
sudo pacman -S git nano tldr wget curl shfmt

# AUR helper
sudo pacman -S --needed base-devel cargo
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd || exit

# AUR packages

yay -Sy google-chrome-stable \
  kitty \
  visual-studio-code-bin \
  bruno-bin \
  postman-bin \
  notepadqq \
  bitwarden \
  stacer-bin \
  libreoffice \
  discord \
  flatpak \
  snapd \
  kdenlive \
  thunderbird \
  timeshift \
  ulauncher \
  pass \
  task \
  bpytop \
  figlet \
  cowsay \
  lolcat \
  timeshift \
  timetrap
