#!/bin/bash
# author: mrp4sten

# lsd
alias ls='lsd --group-dirs=first'
alias l='ls -l --group-dirs=first'
alias la='ls -a --group-dirs=first'
alias lla='ls -la --group-dirs=first'
alias lt='ls --tree --group-dirs=first'
alias vi='nvim'

# bat — works on both Arch (bat) and Debian/Ubuntu (batcat)
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never --theme="gruvbox-dark"'
  alias less='bat --theme="gruvbox-dark"'
elif command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never --theme="gruvbox-dark"'
  alias less='batcat --theme="gruvbox-dark"'
fi

# update packages — distro-aware
if command -v pacman &>/dev/null; then
  alias update="sudo pacman -Syu"
elif command -v nala &>/dev/null; then
  alias update="sudo nala update && sudo nala upgrade"
else
  alias update="sudo apt update && sudo apt upgrade"
fi

# fastfetch
alias fastfetchsm='fastfetch --config ~/.config/fastfetch/mavor-sm.jsonc'
alias fastfetchmd='fastfetch --config ~/.config/fastfetch/mavor-md.jsonc'
alias fastfetchlg='fastfetch --config ~/.config/fastfetch/mavor-lg.jsonc'

# lazydocker
alias lzd='lazydocker'

# containers
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dlogp='docker logs --tail=100 2>&1 | bat --paging=never -l log'

# Compose
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcb='docker compose up -d --build'
alias dcl='docker compose logs -f'
alias dcp='docker compose pull'
alias dcr='docker compose restart'

# Cleanup
alias dprune='docker system prune -f'
alias dprunea='docker system prune -a --volumes -f'

# Stats
alias dstats='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'

# SDKMAN!
alias sdkl='sdk list'
alias sdku='sdk use'
alias sdki='sdk install'
alias sdkc='sdk current'
alias sdkenv='sdk env'

# Grails
alias gr='grails run-app'
alias gs='grails shell'
alias gt='grails test-app'
alias gw='./gradlew'
alias gwb='./gradlew build'
alias gwt='./gradlew test'
alias gwc='./gradlew clean'
alias gwbr='./gradlew bootRun'
alias gwbd='./gradlew build -x test'

# Quick Groovy REPL
alias gsh='groovysh'
