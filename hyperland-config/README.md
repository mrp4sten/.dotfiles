<h1 align="center"> mrp4sten 💻 config <h1>

![preview browser](./img/preview-browser.png)

![preview terminal](./img/preview-terminal.png)

![preview vscode](./img/preview-vscode.png)

## Installations ⬇️

### Dependencies

- Installations

```shell
paru -S hyprland waybar-hyprland-git rofi rofi-emoji dunst kitty swaybg mugshot swaylock-effects swayidle pamixer light brillo grimblast pavucontrol bluez bluez-utils lxappearance thunar firefox cava neo-matrix sddm-git xdg-desktop-portal
```

- Fonts

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

- Config files 📁

```shell
cp -r dunst hypr rofi waybar ~/.config/
```
