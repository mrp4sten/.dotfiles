#!/bin/bash
# author: Mauricio Pasten (mrp4sten)

# Installations
paru -S hyprland rofi rofi-emoji dunst alacritty swaybg mugshot swaylock-effects swayidle pamixer light brillo grimblast pavucontrol bluez bluez-utils lxappearance thunar google-chrome cava neo-matrix sddm-git xdg-desktop-portal
sudo systemctl enable sddm.service
sudo systemctl start sddm.service
paru -S bluetooth-support
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
paru -S spdlog
paru -Rd fmt --nodeps
paru -S fmt
paru -S waybar-git

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

# and also

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
