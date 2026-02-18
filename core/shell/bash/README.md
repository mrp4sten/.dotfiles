# Bash Set-Up

## Dependencies

Dependencies:

- oh my bash
- download .git-prompt.sh
- install exa
- install bat
- fzf
- install asdf

### Installation

#### oh-my-bash

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
```

### exa

```shell
sudo nala install cargo # if you dont have installed cargo
cargo install exa
```

### bat

```shell
# Download the .deb file from release here: https://github.com/sharkdp/bat
sudo nala install *.deb
```

### fzf

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### asdf

```shell
cd Downloads
wget https://github.com/asdf-vm/asdf/releases/download/v0.18.0/asdf-v0.18.0-linux-386.tar.gz
tar -xf asdf-v0.18.0-linux-386.tar.gz
sudo mv asdf /bin
```

## bash settings

```shell
cd ~/
cp ~/.dotfiles/core/shell/bash/.bashrc ~/
cp ~/.dotfiles/core/shell/bash/.git-prompt.sh ~/
```
