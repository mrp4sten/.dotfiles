#!/bin/bash
#author: mrp4sten

# Clean everything (packages and metadata), and update the metadata
clean() {
  sudo dnf clean all
  sudo dnf makecache
}

# Clean the old kernels installed in Fedora43
clean_kernels() {
  local keep="${1:-2}"
  local current
  current="$(uname -r)"

  local kernels=()
  while IFS= read -r k; do
    kernels+=("$k")
  done < <(
    rpm -q kernel-core \
    | sed 's/^kernel-core-//' \
    | sort -V -r
  )

  local count=0
  for k in "${kernels[@]}"; do
    ((count++))
    if (( count <= keep )); then
      continue
    fi
    if [[ "$k" == "$current" ]]; then
      continue
    fi

    echo "Removing kernel $k"
    sudo dnf remove \
      "kernel-core-$k" \
      "kernel-modules-$k" \
      "kernel-modules-extra-$k"
  done
}



# Create config developer files (.gitignore, .prettierrc, .htmlhintrc, .stylelintrc, webpack.config.js, etc.)
config_craft() {
  CONFIG_CRAFT=~/.dotfiles/terminal/zsh/scripts/config-craft/config-craft.sh
  bash $CONFIG_CRAFT
}

# Create a desktop entry file on Linuz OS
desktop_craft() {
  DESKTOP_CRAFT=~/.dotfiles/terminal/zsh/scripts/desktop-craft.sh
  bash $DESKTOP_CRAFT
}
