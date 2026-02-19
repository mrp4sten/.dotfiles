# VS-Code Configurations

## Dependencies

- fonts
  - FantasqueSansMono NF
  - Comic Mono

### Download & Install Nerd Fonts if you dont have

```shell
cd /usr/share/fonts
sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FantasqueSansMono.zip
sudo unzip FantasqueSansMono.zip
sudo rm FantasqueSansMono.zip

sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Hack.zip
sudo unzip Hack.zip
sudo rm Hack.zip

sudo wget https://dtinth.github.io/comic-mono-font/ComicMono.ttf
sudo wget https://dtinth.github.io/comic-mono-font/ComicMono-Bold.ttf

fc-cache -fv
```

## Link config

```shell
ln -sf ~/.dotfiles/development/vscode/vscode/settings.json ~/.config/Code/User/settings.json
```

> Or just run `bash ~/.dotfiles/automation/install/install.sh` to set up everything at once.
