# Kitty Configurations

## Dependencies

- fonts
  - CascadiaCode NF
  - FantasqueSansMono NF
  - MartianMono NF

### Download & Install Nerd Font

```shell
cd /usr/share/fonts

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
yay -Sy kitty
```

### Kitty Config

```shell
cd ~/
cp -r ~/.dotfiles/terminal/kitty ~/.config
```
