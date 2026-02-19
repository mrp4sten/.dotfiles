# Ghostty shell integration
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

# Path from oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
export DOTFILES_PATH=$HOME/.dotfiles
export ZSH_CONFIG_PATH=$DOTFILES_PATH/core/shell/zsh

# Theme
ZSH_THEME=""

# Plugins
plugins=(
    git
    git-auto-fetch
    git-commit
    zsh-autosuggestions
    fast-syntax-highlighting
    colored-man-pages
    fzf
    sudo
    jsontools
    gcloud
    docker
    docker-compose
    dotenv
    spring
    python
    pyenv
    pylint
    node
    yarn
    npm
    nodenv
    emoji
    emoji-clock
    kubectl
    kubectx
    kube-ps1
    svcat
    minikube
		z
		ubuntu
		copyfile
		copypath
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

# Loading aliases, exports and functions
source $ZSH_CONFIG_PATH/_aliases/utils.sh
source $ZSH_CONFIG_PATH/_exports/exports.sh
source $ZSH_CONFIG_PATH/_functions/functions.sh

# Load sdkman
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ghcup-env 
[ -f "/home/mrp4sten/.ghcup/env" ] && . "/home/mrp4sten/.ghcup/env"
