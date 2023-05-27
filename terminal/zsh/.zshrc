# Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path from oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
export DOTFILES_PATH=$HOME/.dotfiles
export ZSH_CONFIG_PATH=$DOTFILES_PATH/terminal/zsh

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    fast-syntax-highlighting
    colored-man-pages
    fzf
    sudo
    jsontools
    asdf
)

source $ZSH/oh-my-zsh.sh

# Loading aliases, exports and functions
source $ZSH_CONFIG_PATH/_aliases/utils.sh
source $ZSH_CONFIG_PATH/_exports/exports.sh
source $ZSH_CONFIG_PATH/_functions/functions.sh

# Load asdf
. "$HOME/.asdf/asdf.sh"

# Prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

