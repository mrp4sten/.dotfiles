# lsd
alias ls='lsd --group-dirs=first'
alias l='ls -l --group-dirs=first'
alias la='ls -a --group-dirs=first'
alias lla='ls -la --group-dirs=first'
alias lt='ls --tree --group-dirs=first'

# bat
alias cat="bat --paging=never --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub)"

# update packages
alias update="paru -Syyuu"