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

###### fzf

```shell
# Official Download
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3
```

###### bat

```shell
pacman -S bat
```

catpucchin theme

```shell
cd ~
git clone git@github.com:catppuccin/bat.git
mkdir -p "$(bat --config-dir)/themes"
cd bat
cp *.tmTheme "$(bat --config-dir)/themes"
bat cache --build
```

###### lsd

```shell
pacman -S lsd
```

### powerlevel10k installation

```shell
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```
