#!/bin/bash
# author: Mauricio Pasten (mrp4sten)

sudo pacman -S gum

sudo pacman -S --needed base-devel cargo
git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si && cd
