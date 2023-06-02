<h1 align="center"> mrp4sten 💻 config <h1>

![preview browser](./img/preview-browser.png)

![preview terminal](./img/preview-terminal.png)

![preview vscode](./img/preview-vscode.png)

## Installations ⬇️

### Dependencies

- Install Hyprland

```shell
paru -S hyprland-git
```

- Base set-ups

```shell
paru -S waybar-hyprland-git rofi dunst kitty swaybg mugshot swaylock-effects swayidle pamixer light brillo grimblast pavucontrol bluez bluez-utils lxappearance thunar firefox cava hyprland neo-matrix
```

- Installing Fonts

```shell
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
```

- Install correct xdg-desktop-portal

```shell
paru -Ss xdg-desktop-portal
paru -S xdg-desktop-portal-hyprland-git
```

- Copy files 📁

```shell
cp -r dunst hypr rofi waybar ~/.config/
```
