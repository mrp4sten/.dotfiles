# === oh-my-bash configuration ===

# Enable the subsequent settings only in interactive sessions
case $- in
*i*) ;;
*) return ;;
esac

# Path to your oh-my-bash installation.
export OSH='/home/mrp4sten/.oh-my-bash'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="agnoster"
OMB_USE_SUDO=true

completions=(
  git
  composer
  ssh
)

aliases=(
  general
)

plugins=(
  git
  bashmarks
)

source "$OSH"/oh-my-bash.sh

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH=~/.console-ninja/.bin:$PATH

# === Manual Configuration ===

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
. ~/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[33m\]$(__git_ps1 "(%s)")\[\033[37m\]\$\[\033[00m\] '

# aliases
alias grep='grep --color=auto'
alias cat='bat --style=plain --paging=never'
alias ls='exa --group-directories-first'
alias tree='exa -T'

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mrp4sten/NicheAimWorkspace/projects/google-cloud-sdk/path.bash.inc' ]; then . '/home/mrp4sten/NicheAimWorkspace/projects/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/mrp4sten/NicheAimWorkspace/projects/google-cloud-sdk/completion.bash.inc' ]; then . '/home/mrp4sten/NicheAimWorkspace/projects/google-cloud-sdk/completion.bash.inc'; fi

# OCP exports
source ~/ocp_exports/nj/ocp_dev.sh
