# Zsh Manual Configuration

## Dependencies

- oh-my-zsh
  - plugins
    - zsh-autosuggestions
    - fast-syntax-highlighting
    - fzf
    - asdf
    - bat
      - Catpucchin theme
    - lsd
- powerlevel10k
- spaceship-prompt
- starship
- ranger

### zsh installation
```shell
sudo dnf install zsh
sudo chsh -s /bin/zsh $USER
```

### oh-my-zsh installation

#### Installation with cURL

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### Installation with wget

```shell
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```

##### Plugins Installation

###### zsh-autosuggestions

```shell
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

###### fast-syntax-highlighting

```shell
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
```

###### asdf

```shell
cd Downloads
wget https://github.com/asdf-vm/asdf/releases/download/v0.18.0/asdf-v0.18.0-linux-386.tar.gz
tar -xf asdf-v0.18.0-linux-386.tar.gz
sudo mv asdf /bin
rm asdf
```

##### sdkman

```shell
curl -s "https://get.sdkman.io" | bash
```

###### fzf

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

###### bat

```shell
sudo dnf install bat
```

catpucchin theme

```shell
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build
```

###### lsd

```shell
sudo dnf install lsd
```

### powerlevel10k installation

```shell
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Set `ZSH_THEME="powerlevel10k/powerlevel10k"` on `~/.zshrc`

### spaceship-prompt installation

```shell
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
```

Set `ZSH_THEME="spaceship"` on `~/.zshrc`

### starship installation

```shell
curl -sS https://starship.rs/install.sh | sh

# Copy config file
cp ~/.dotfiles/terminal/zsh/starship.toml ~/.config/
```

Set `eval "$(starship init zsh)"` on `~/.zshrc`

#### ranger

```shell
sudo dnf install ranger
```

##### ranger_devicons

```shell
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf
```

##### ranger img preview

```shell
# Dependencies
echo "set preview_images true" >> $HOME/.config/ranger/rc.conf
echo "set preview_images_method kitty" >> $HOME/.config/ranger/rc.conf
```

##### pass

I like `pass` is a simple terminal password manager and this is a little manual to your config

```shell
sudo dnf install pass

gpg --gen-key
gpg --edit-key [example_gpg_id]

# Om gpg menu insert the follow:
#  - expire
#  - 0
#  - save

pass init [example_gpg_id]
pass git init
pass generate example
pass show example
pass git remote add origin [github-repo]
pass git push origin master

gpg --list-secret-keys --keyid-format=long  to list gpg keys
gpg --output public.pgp --armor --export [example_gpg_id]
gpg --output private.pgp --armor --export-secret-key [example_gpg_id]
```

### Copy file settings

```shell
cd ~/
cp ~/.dotfiles/terminal/zsh/.zshrc ~/
cp ~/.dotfiles/terminal/zsh/.p10k.zsh ~/
```
