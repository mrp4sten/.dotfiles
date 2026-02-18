#!/bin/bash
# author: mrp4sten

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export KUBE_PS1_ENABLED=off
export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}"
export KUBE_PS1_CLUSTER_FUNCTION=""
export KUBE_PS1_NS_ENABLE=false

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Atuin
export PATH="$HOME/.atuin/bin:$PATH"
eval "$(atuin init zsh)"

