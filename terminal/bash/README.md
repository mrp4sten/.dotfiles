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
sudo pacman -Sy exa
```

### bat

```shell
sudo pacman -Sy bat
```

### fzf

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### asdf

```shell
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
```

## bash settings

```shell
cd ~/
cp ~/.dotfiles/terminal/bash/.bashrc ~/
cp ~/.dotfiles/terminal/bash/.git-prompt.sh ~/
```
