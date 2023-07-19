# Tmux installation and set-up

## Dependencies

- tmux
- tpm

### Install tmux

```bash
sudo pacman -Sy tmux
```

### Install tpm

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

#### Set configurations

```bash
cp -r .dotfiles/terminal/tmux .config/tmux
ln -s -f .config/tmux/.tmux.conf .
```
