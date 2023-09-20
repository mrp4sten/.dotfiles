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
- ranger

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

Follow the Installation here <https://asdf-vm.com/>

###### fzf

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
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

#### ranger

```shell
paru -S ranger
```

##### ranger_devicons

```shell
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf
```

##### ranger img preview

```shell
paru -S ueberzugpp

echo "set preview_images true" >> $HOME/.config/ranger/rc.conf
echo "set preview_images_method ueberzug" >> $HOME/.config/ranger/rc.conf
```

##### pass

I like `pass` is a simple terminal password manager and this is a little manual to your config

```shell
paru -S pass

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
