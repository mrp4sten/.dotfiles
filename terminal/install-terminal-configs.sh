#!/bin/bash
# author: Mauricio Pasten (mrp4sten)

TERMINAL_DIR=~/.dotfiles/terminal

# nano
sudo pacman -Sy nano
cp ${TERMINAL_DIR}/.nanorc ~/

# Install alacritty by default
paru -S alacritty
cp -r ${TERMINAL_DIR}/alacritty ~/.config

# kitty terminal
paru -S kitty
cp -r ${TERMINAL_DIR}/kitty ~/.config

# bash configs
sudo pacman -Sy exa bat curl git
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
cp ${TERMINAL_DIR}/bash/.git-prompt.sh ~/
cp ${TERMINAL_DIR}/bash/.bashrc ~/

# cava config
sudo pacman -Sy cava
cp -r ${TERMINAL_DIR}/cava ~/.config
pacman -S base-devel fftw ncurses alsa-lib iniparser pulseaudio autoconf-archive pkgconf

# tmux
pacman -S tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp -r ${TERMINAL_DIR}/tmux ~/.config
ln -s -f ${TERMINAL_DIR}/.tmux.conf ~/

# zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
pacman -S bat
cd ~ || exit
git clone git@github.com:catppuccin/bat.git
mkdir -p "$(bat --config-dir)/themes"
cd bat || exit
cp *.tmTheme "$(bat --config-dir)/themes"
bat cache --build
pacman -S lsd
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
paru -S ranger
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
echo "default_linemode devicons" >>"$HOME"/.config/ranger/rc.conf
paru -S ueberzugpp
echo "set preview_images true" >>"$HOME"/.config/ranger/rc.conf
echo "set preview_images_method ueberzug" >>"$HOME"/.config/ranger/rc.conf
paru -S pass
cp ${TERMINAL_DIR}/zsh/.zshrc ~/
cp ${TERMINAL_DIR}/zsh/.p10k.zsh ~/
