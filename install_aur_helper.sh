#!/bin/bash
# author: Mauricio Pasten (mrp4sten)

# +-+-+-+-+-+
# |U|T|I|L|S|
# +-+-+-+-+-+
sudo pacman -S gum figlet cowsay lolcat git nano tldr wget curl shfmt

# +-+-+-+ +-+-+-+-+-+-+
# |A|U|R| |H|E|L|P|E|R|
# +-+-+-+ +-+-+-+-+-+-+
sudo pacman -S --needed base-devel cargo
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd || exit
