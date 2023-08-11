#!/bin/bash
# author: Mauricio Pasten (mrp4sten)

# Installations
paru -Sy hyprland waybar-hyprland-git rofi rofi-emoji dunst alacritty swaybg mugshot swaylock-effects swayidle pamixer light brillo grimblast pavucontrol bluez bluez-utils lxappearance thunar brave-bin cava neo-matrix sddm-git xdg-desktop-portal

# Installing fonts
cd /usr/share/fonts
sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip
sudo unzip JetBrainsMono.zip
sudo rm JetBrainsMono.zip

sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Iosevka.zip
sudo unzip Iosevka.zip
sudo rm Iosevka.zip

sudo wget https://github.com/googlefonts/noto-emoji/raw/main/fonts/NotoColorEmoji.ttf
sudo wget https://github.com/microsoft/vscode-codicons/raw/main/dist/codicon.ttf
cd

mkdir ~/.fonts
cd ~/.fonts
sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip
sudo unzip JetBrainsMono.zip
sudo rm JetBrainsMono.zip

sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Iosevka.zip
sudo unzip Iosevka.zip
sudo rm Iosevka.zip

sudo wget https://github.com/googlefonts/noto-emoji/raw/main/fonts/NotoColorEmoji.ttf
sudo wget https://github.com/microsoft/vscode-codicons/raw/main/dist/codicon.ttf
cd

paru -S ttf-font-awesome

fc-cache -fv

# Setting Configs
cp -r dunst hypr rofi waybar ~/.config/
