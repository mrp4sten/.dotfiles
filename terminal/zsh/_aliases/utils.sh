#!/bin/bash

# lsd
alias ls='lsd --group-dirs=first'
alias l='ls -l --group-dirs=first'
alias la='ls -a --group-dirs=first'
alias lla='ls -la --group-dirs=first'
alias lt='ls --tree --group-dirs=first'
alias vi='nvim'

# bat
alias cat='bat --paging=never --theme="Catppuccin Mocha"'

# update packages
alias update="yay -Syyuu"

# fastfetch
alias fastfetchsm='fastfetch --config ~/.config/fastfetch/mavor-sm.jsonc'
alias fastfetchmd='fastfetch --config ~/.config/fastfetch/mavor-md.jsonc'
alias fastfetchlg='fastfetch --config ~/.config/fastfetch/mavor-lg.jsonc'
