# Ghostty

Just Follow this for install: <https://github.com/dariogriffo/ghostty-debian>

## Link config

```shell
mkdir -p ~/.config/ghostty
ln -sf ~/.dotfiles/core/terminal/ghostty/config ~/.config/ghostty/config
```

> Or just run `bash ~/.dotfiles/automation/install/install.sh` to set up everything at once.

## Keybinds

```shell
ghostty +list-keybinds --default
```
