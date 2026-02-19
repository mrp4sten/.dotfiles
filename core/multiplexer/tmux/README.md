# Tmux installation and set-up

## Dependencies

- tmux
- tpm

### Installation

#### tmux installation

```shell
sudo nala install tmux
```

#### tpm installation

```shell
cd ~/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

#### Link config

```bash
ln -sf ~/.dotfiles/core/multiplexer/tmux ~/.config/tmux
ln -sf ~/.config/tmux/.tmux.conf ~/
```

> Or just run `bash ~/.dotfiles/automation/install/install.sh` to set up everything at once.

#### Load plugins and settings

```shell
cd ~/
tmux
tmux source ~/.config/tmux/.tmux.conf

# Now press ctrl + space
# Then press shift + I
```
