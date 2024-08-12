#!/bin/bash
# author: Mauricio Pasten (mrp4sten)

# AUR helper
sudo pacman -S --needed base-devel cargo
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd || exit
