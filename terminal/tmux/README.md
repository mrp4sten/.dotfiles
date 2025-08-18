# Tmux installation and set-up

## Dependencies

- tmux
- tpm

### Installation

#### tmux installation

```shell
sudo dnf install tmux
```

#### tpm installation

```shell
cd ~/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

#### Setting my custom config

```bash
cp -r .dotfiles/terminal/tmux ~/.config
ln -s -f .config/tmux/.tmux.conf ~/
```

#### Load plugins and settings
```shell
cd ~/
tmux
tmux source ~/.config/tmux/.tmux.conf

# Now press ctrl + space
# Then press shift + I
```
