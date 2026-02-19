# Kitty Configurations

## Dependencies

- fonts
  - CascadiaCode NF
  - FantasqueSansMono NF
  - MartianMono NF

### Download & Install Nerd Font

```shell
cd /usr/share/fonts

sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Hack.zip
sudo unzip Hack.zip
sudo rm Hack.zip

sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip
sudo unzip CascadiaCode.zip
sudo rm CascadiaCode.zip

sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FantasqueSansMono.zip
sudo unzip FantasqueSansMono.zip
sudo rm FantasqueSansMono.zip

sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/MartianMono.zip
sudo unzip MartianMono.zip
sudo rm MartianMono.zip
fc-cache -fv
```

## Installation

```shell
sudo nala install kitty
```

### Kitty Config

```shell
ln -sf ~/.dotfiles/core/terminal/kitty ~/.config/kitty
```

> Or just run `bash ~/.dotfiles/automation/install/install.sh` to set up everything at once.
