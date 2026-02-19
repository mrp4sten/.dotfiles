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
sudo nala install zsh
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
```

##### sdkman

```shell
curl -s "https://get.sdkman.io" | bash
```

#### pyenv

```shell
sudo nala install pyenv
```

##### fzf

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

###### bat

```shell
# Download the .deb file from release here: https://github.com/sharkdp/bat
sudo nala install *.deb
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
sudo nala install lsd
```

###### atuin

```shell
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
# This is already on .zshrc file, but JUST FYI this is how enable it in zsh
# echo 'eval "$(atuin init zsh)"' >> ~/.zshrc 
```

> Visit project here: <https://github.com/atuinsh/atuin>

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
cp ~/.dotfiles/core/shell/zsh/starship.toml ~/.config/
```

Set `eval "$(starship init zsh)"` on `~/.zshrc`

#### Yazi

Download from release <https://github.com/sxyazi/yazi> and install .deb file

##### pass

I like `pass` is a simple terminal password manager and this is a little manual to your config

```shell
sudo nala install pass

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

### Link config files

```shell
ln -sf ~/.dotfiles/core/shell/zsh/starship.toml ~/.config/starship.toml
```

> Or just run `bash ~/.dotfiles/automation/install/install.sh` to set up everything at once.
