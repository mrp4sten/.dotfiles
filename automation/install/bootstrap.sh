#!/bin/bash
# author: mrp4sten
#
# bootstrap.sh — Full dev environment installer
#
# Installs all tools referenced across this dotfiles repo.
# Safe to re-run: each installer checks if the tool already exists before acting.
#
# Usage:
#   bash bootstrap.sh              # Install everything
#   bash bootstrap.sh --core       # Shell + terminal tools only
#   bash bootstrap.sh --langs      # Language runtimes only (nvm, pyenv, sdkman)
#   bash bootstrap.sh --devtools   # Dev CLI tools (lazygit, fzf, atuin, etc.)
#   bash bootstrap.sh --apps       # Terminal apps (nvim, kitty, ghostty)
#   bash bootstrap.sh --help       # Show this help

set -euo pipefail

# ─────────────────────────────────────────────
#  Flags
# ─────────────────────────────────────────────

INSTALL_CORE=false
INSTALL_LANGS=false
INSTALL_DEVTOOLS=false
INSTALL_APPS=false

parse_args() {
  if [[ $# -eq 0 ]]; then
    INSTALL_CORE=true
    INSTALL_LANGS=true
    INSTALL_DEVTOOLS=true
    INSTALL_APPS=true
    return
  fi

  for arg in "$@"; do
    case "${arg}" in
      --core)     INSTALL_CORE=true ;;
      --langs)    INSTALL_LANGS=true ;;
      --devtools) INSTALL_DEVTOOLS=true ;;
      --apps)     INSTALL_APPS=true ;;
      --help|-h)
        echo ""
        echo "  Usage: bash bootstrap.sh [--core] [--langs] [--devtools] [--apps]"
        echo ""
        echo "  --core       Shell (zsh/bash), oh-my-zsh, oh-my-bash, starship, nala"
        echo "  --langs      Language runtimes: nvm (Node), pyenv (Python), sdkman (Java)"
        echo "  --devtools   CLI dev tools: lazygit, fzf, atuin, lsd, bat, eza, yazi, gum"
        echo "  --apps       Terminal apps: Neovim AppImage, kitty, ghostty, pass"
        echo ""
        echo "  No flags = install everything"
        echo ""
        exit 0
        ;;
      *)
        echo "  Unknown flag: ${arg}. Run with --help for usage."
        exit 1
        ;;
    esac
  done
}

# ─────────────────────────────────────────────
#  Helpers
# ─────────────────────────────────────────────

log_section() {
  echo ""
  echo "══════════════════════════════════════════"
  echo "  $1"
  echo "══════════════════════════════════════════"
}

log_info()  { echo "  [INFO]  $1"; }
log_ok()    { echo "  [ OK ]  $1"; }
log_skip()  { echo "  [SKIP]  $1 — already installed"; }
log_warn()  { echo "  [WARN]  $1"; }
log_step()  { echo "  ····    $1"; }

# is_installed <command>
is_installed() {
  command -v "$1" &>/dev/null
}

# nala_install <pkg> [<pkg> ...]  — skips if all already installed
nala_install() {
  local pkgs=("$@")
  local to_install=()

  for pkg in "${pkgs[@]}"; do
    if ! dpkg -s "${pkg}" &>/dev/null 2>&1; then
      to_install+=("${pkg}")
    else
      log_skip "${pkg} (apt)"
    fi
  done

  if [[ ${#to_install[@]} -gt 0 ]]; then
    log_step "Installing via nala: ${to_install[*]}"
    sudo nala install -y "${to_install[@]}"
    log_ok "Installed: ${to_install[*]}"
  fi
}

# ─────────────────────────────────────────────
#  Sections
# ─────────────────────────────────────────────

install_nala() {
  log_section "nala (apt wrapper)"
  if is_installed nala; then
    log_skip "nala"
  else
    log_step "Installing nala via apt"
    sudo apt update -qq
    sudo apt install -y nala
    log_ok "nala installed"
  fi
}

install_core() {
  log_section "Core — Shell & Prompt"

  # ── Base packages ──────────────────────────
  nala_install \
    zsh \
    curl \
    wget \
    git \
    unzip \
    build-essential

  # ── oh-my-zsh ─────────────────────────────
  if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    log_skip "oh-my-zsh"
  else
    log_step "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_ok "oh-my-zsh installed"
  fi

  # ── oh-my-zsh plugins ─────────────────────
  local omz_custom="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"

  if [[ -d "${omz_custom}/plugins/zsh-autosuggestions" ]]; then
    log_skip "zsh-autosuggestions"
  else
    log_step "Installing zsh-autosuggestions"
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
      "${omz_custom}/plugins/zsh-autosuggestions"
    log_ok "zsh-autosuggestions"
  fi

  if [[ -d "${omz_custom}/plugins/fast-syntax-highlighting" ]]; then
    log_skip "fast-syntax-highlighting"
  else
    log_step "Installing fast-syntax-highlighting"
    git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
      "${omz_custom}/plugins/fast-syntax-highlighting"
    log_ok "fast-syntax-highlighting"
  fi

  # ── oh-my-bash ────────────────────────────
  if [[ -d "${HOME}/.oh-my-bash" ]]; then
    log_skip "oh-my-bash"
  else
    log_step "Installing oh-my-bash"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" "" --unattended
    log_ok "oh-my-bash installed"
  fi

  # ── Starship prompt ───────────────────────
  if is_installed starship; then
    log_skip "starship"
  else
    log_step "Installing starship"
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    log_ok "starship installed"
  fi

  # ── Set zsh as default shell ───────────────
  local zsh_path
  zsh_path="$(command -v zsh)"
  if [[ "${SHELL}" == "${zsh_path}" ]]; then
    log_skip "Default shell is already zsh"
  else
    log_step "Setting zsh as default shell"
    sudo chsh -s "${zsh_path}" "${USER}"
    log_ok "Default shell set to zsh (re-login to apply)"
  fi
}

install_langs() {
  log_section "Language Runtimes"

  # ── nvm (Node Version Manager) ────────────
  if [[ -d "${HOME}/.nvm" ]]; then
    log_skip "nvm"
  else
    log_step "Installing nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
    log_ok "nvm installed"
  fi

  # ── Node LTS via nvm ──────────────────────
  # Source nvm so we can use it right now
  export NVM_DIR="${HOME}/.nvm"
  # shellcheck disable=SC1091
  [[ -s "${NVM_DIR}/nvm.sh" ]] && source "${NVM_DIR}/nvm.sh"

  if is_installed node; then
    log_skip "node ($(node -v))"
  else
    log_step "Installing Node.js LTS"
    nvm install --lts
    nvm alias default node
    log_ok "Node LTS installed and set as default"
  fi

  # ── pyenv (Python Version Manager) ────────
  if [[ -d "${HOME}/.pyenv" ]]; then
    log_skip "pyenv"
  else
    log_step "Installing pyenv build dependencies"
    nala_install \
      libssl-dev \
      zlib1g-dev \
      libbz2-dev \
      libreadline-dev \
      libsqlite3-dev \
      libncursesw5-dev \
      xz-utils \
      tk-dev \
      libxml2-dev \
      libxmlsec1-dev \
      libffi-dev \
      liblzma-dev

    log_step "Installing pyenv"
    curl https://pyenv.run | bash
    log_ok "pyenv installed"
    log_warn "Add pyenv to your shell config and re-login to use it"
    log_info "  export PYENV_ROOT=\"\$HOME/.pyenv\""
    log_info "  export PATH=\"\$PYENV_ROOT/bin:\$PATH\""
    log_info "  eval \"\$(pyenv init - zsh)\""
    log_info "  (already in dotfiles exports.sh — just re-login)"
  fi

  # ── sdkman (Java Version Manager) ─────────
  if [[ -d "${HOME}/.sdkman" ]]; then
    log_skip "sdkman"
  else
    log_step "Installing sdkman"
    curl -s "https://get.sdkman.io" | bash
    log_ok "sdkman installed"
    log_warn "Run: source \"\$HOME/.sdkman/bin/sdkman-init.sh\" to activate"
  fi

  # ── Java LTS via sdkman ───────────────────
  # Source sdkman to use it in this script
  export SDKMAN_DIR="${HOME}/.sdkman"
  # shellcheck disable=SC1091
  [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

  if is_installed java; then
    log_skip "java ($(java -version 2>&1 | head -1))"
  else
    log_step "Installing Java 21 LTS via sdkman"
    sdk install java 21-tem
    log_ok "Java 21 (Temurin) installed"
  fi
}

install_devtools() {
  log_section "Dev Tools — CLI"

  # ── fzf ───────────────────────────────────
  if [[ -d "${HOME}/.fzf" ]]; then
    log_skip "fzf"
  else
    log_step "Installing fzf"
    git clone --depth=1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
    "${HOME}/.fzf/install" --all --no-update-rc
    log_ok "fzf installed"
  fi

  # ── atuin (shell history) ─────────────────
  if is_installed atuin; then
    log_skip "atuin"
  else
    log_step "Installing atuin"
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    log_ok "atuin installed"
  fi

  # ── lazygit ───────────────────────────────
  if is_installed lazygit; then
    log_skip "lazygit"
  else
    log_step "Installing lazygit"
    local lazygit_version
    lazygit_version="$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
      | grep -Po '"tag_name": "v\K[^"]*')"
    curl -Lo /tmp/lazygit.tar.gz \
      "https://github.com/jesseduffield/lazygit/releases/download/v${lazygit_version}/lazygit_${lazygit_version}_Linux_x86_64.tar.gz"
    tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin
    rm /tmp/lazygit /tmp/lazygit.tar.gz
    log_ok "lazygit ${lazygit_version} installed"
  fi

  # ── lsd (modern ls) ───────────────────────
  if is_installed lsd; then
    log_skip "lsd"
  else
    log_step "Installing lsd"
    nala_install lsd
  fi

  # ── bat / batcat ──────────────────────────
  if is_installed bat || is_installed batcat; then
    log_skip "bat"
  else
    log_step "Installing bat"
    local bat_version
    bat_version="$(curl -s "https://api.github.com/repos/sharkdp/bat/releases/latest" \
      | grep -Po '"tag_name": "v\K[^"]*')"
    curl -Lo /tmp/bat.deb \
      "https://github.com/sharkdp/bat/releases/download/v${bat_version}/bat_${bat_version}_amd64.deb"
    sudo nala install -y /tmp/bat.deb
    rm /tmp/bat.deb
    log_ok "bat ${bat_version} installed"
  fi

  # bat — catppuccin themes
  local bat_theme_dir
  bat_theme_dir="$(bat --config-dir 2>/dev/null || batcat --config-dir 2>/dev/null)/themes"
  if [[ -f "${bat_theme_dir}/Catppuccin Mocha.tmTheme" ]]; then
    log_skip "bat catppuccin themes"
  else
    log_step "Installing bat catppuccin themes"
    mkdir -p "${bat_theme_dir}"
    local base_url="https://github.com/catppuccin/bat/raw/main/themes"
    wget -qP "${bat_theme_dir}" "${base_url}/Catppuccin%20Latte.tmTheme"
    wget -qP "${bat_theme_dir}" "${base_url}/Catppuccin%20Frappe.tmTheme"
    wget -qP "${bat_theme_dir}" "${base_url}/Catppuccin%20Macchiato.tmTheme"
    wget -qP "${bat_theme_dir}" "${base_url}/Catppuccin%20Mocha.tmTheme"
    bat cache --build 2>/dev/null || batcat cache --build 2>/dev/null || true
    log_ok "bat catppuccin themes installed"
  fi

  # ── eza (modern ls, exa successor) ────────
  if is_installed eza; then
    log_skip "eza"
  else
    log_step "Installing eza"
    # eza is in Ubuntu 23.10+; for older distros use cargo
    if sudo nala install -y eza 2>/dev/null; then
      log_ok "eza installed via nala"
    else
      log_step "eza not in apt — installing via cargo"
      if ! is_installed cargo; then
        log_step "Installing Rust/cargo first"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
        # shellcheck disable=SC1091
        source "${HOME}/.cargo/env"
      fi
      cargo install eza
      log_ok "eza installed via cargo"
    fi
  fi

  # ── gum (TUI helper — used by config-craft) ─
  if is_installed gum; then
    log_skip "gum"
  else
    log_step "Installing gum"
    local gum_version
    gum_version="$(curl -s "https://api.github.com/repos/charmbracelet/gum/releases/latest" \
      | grep -Po '"tag_name": "v\K[^"]*')"
    curl -Lo /tmp/gum.deb \
      "https://github.com/charmbracelet/gum/releases/download/v${gum_version}/gum_${gum_version}_amd64.deb"
    sudo nala install -y /tmp/gum.deb
    rm /tmp/gum.deb
    log_ok "gum ${gum_version} installed"
  fi

  # ── yazi (terminal file manager) ──────────
  if is_installed yazi; then
    log_skip "yazi"
  else
    log_step "Installing yazi"
    local yazi_version
    yazi_version="$(curl -s "https://api.github.com/repos/sxyazi/yazi/releases/latest" \
      | grep -Po '"tag_name": "v\K[^"]*')"
    curl -Lo /tmp/yazi.deb \
      "https://github.com/sxyazi/yazi/releases/download/v${yazi_version}/yazi-x86_64-unknown-linux-gnu.tar.gz"
    # yazi ships as tarball, not deb
    rm /tmp/yazi.deb
    curl -Lo /tmp/yazi.tar.gz \
      "https://github.com/sxyazi/yazi/releases/download/v${yazi_version}/yazi-x86_64-unknown-linux-gnu.tar.gz"
    tar xf /tmp/yazi.tar.gz -C /tmp
    sudo install "/tmp/yazi-x86_64-unknown-linux-gnu/yazi" /usr/local/bin/yazi
    rm -rf /tmp/yazi.tar.gz "/tmp/yazi-x86_64-unknown-linux-gnu"
    log_ok "yazi ${yazi_version} installed"
  fi

  # ── fastfetch ─────────────────────────────
  if is_installed fastfetch; then
    log_skip "fastfetch"
  else
    log_step "Installing fastfetch"
    local ff_version
    ff_version="$(curl -s "https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest" \
      | grep -Po '"tag_name": "\K[^"]*')"
    curl -Lo /tmp/fastfetch.deb \
      "https://github.com/fastfetch-cli/fastfetch/releases/download/${ff_version}/fastfetch-linux-amd64.deb"
    sudo nala install -y /tmp/fastfetch.deb
    rm /tmp/fastfetch.deb
    log_ok "fastfetch ${ff_version} installed"
  fi

  # ── pass + gpg (password manager) ─────────
  nala_install gnupg pass

  # ── opencode ──────────────────────────────
  if is_installed opencode; then
    log_skip "opencode"
  else
    log_step "Installing opencode"
    curl -fsSL https://opencode.ai/install | bash
    log_ok "opencode installed"
    log_warn "Run: opencode auth login — to authenticate"
  fi

  # opencode npm plugin
  if is_installed node; then
    if npm list -g opencode-anthropic-auth &>/dev/null 2>&1; then
      log_skip "opencode-anthropic-auth (npm global)"
    else
      log_step "Installing opencode-anthropic-auth"
      npm install -g opencode-anthropic-auth
      log_ok "opencode-anthropic-auth installed"
    fi
  else
    log_warn "Node not found — skipping opencode-anthropic-auth (install --langs first)"
  fi
}

install_apps() {
  log_section "Terminal Apps"

  # ── Nerd Fonts ────────────────────────────
  local font_dir="/usr/share/fonts"
  log_section "Nerd Fonts"

  if fc-list | grep -qi "Hack Nerd Font"; then
    log_skip "Hack Nerd Font"
  else
    log_step "Installing Hack Nerd Font"
    sudo wget -qP "${font_dir}" \
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Hack.zip"
    sudo unzip -qo "${font_dir}/Hack.zip" -d "${font_dir}"
    sudo rm "${font_dir}/Hack.zip"
    log_ok "Hack Nerd Font installed"
  fi

  if fc-list | grep -qi "CascadiaCode"; then
    log_skip "CascadiaCode Nerd Font"
  else
    log_step "Installing CascadiaCode Nerd Font"
    sudo wget -qP "${font_dir}" \
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip"
    sudo unzip -qo "${font_dir}/CascadiaCode.zip" -d "${font_dir}"
    sudo rm "${font_dir}/CascadiaCode.zip"
    log_ok "CascadiaCode Nerd Font installed"
  fi

  if fc-list | grep -qi "FantasqueSansMono"; then
    log_skip "FantasqueSansMono Nerd Font"
  else
    log_step "Installing FantasqueSansMono Nerd Font"
    sudo wget -qP "${font_dir}" \
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FantasqueSansMono.zip"
    sudo unzip -qo "${font_dir}/FantasqueSansMono.zip" -d "${font_dir}"
    sudo rm "${font_dir}/FantasqueSansMono.zip"
    log_ok "FantasqueSansMono Nerd Font installed"
  fi

  if fc-list | grep -qi "MartianMono"; then
    log_skip "MartianMono Nerd Font"
  else
    log_step "Installing MartianMono Nerd Font"
    sudo wget -qP "${font_dir}" \
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/MartianMono.zip"
    sudo unzip -qo "${font_dir}/MartianMono.zip" -d "${font_dir}"
    sudo rm "${font_dir}/MartianMono.zip"
    log_ok "MartianMono Nerd Font installed"
  fi

  # Rebuild font cache
  log_step "Rebuilding font cache"
  fc-cache -fv &>/dev/null
  log_ok "Font cache rebuilt"

  # ── Neovim (AppImage) ─────────────────────
  log_section "Neovim"
  local nvim_bin="${HOME}/.local/bin/nvim-linux-x86_64.appimage"
  if [[ -f "${nvim_bin}" ]]; then
    log_skip "Neovim AppImage"
  else
    log_step "Downloading latest Neovim AppImage"
    mkdir -p "${HOME}/.local/bin"
    curl -Lo "${nvim_bin}" \
      "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
    chmod +x "${nvim_bin}"
    log_ok "Neovim AppImage installed at ${nvim_bin}"
    log_info "Aliased as 'vi' in your shell (see aliases/utils.sh)"
  fi

  # ── stylua (Lua formatter for nvim config) ─
  if is_installed stylua; then
    log_skip "stylua"
  else
    if is_installed cargo; then
      log_step "Installing stylua via cargo"
      cargo install stylua
      log_ok "stylua installed"
    else
      log_warn "cargo not found — skipping stylua. Install Rust first or install manually."
      log_info "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    fi
  fi

  # ── kitty ─────────────────────────────────
  log_section "Kitty Terminal"
  if is_installed kitty; then
    log_skip "kitty"
  else
    log_step "Installing kitty"
    nala_install kitty
  fi

  # ── ghostty ───────────────────────────────
  log_section "Ghostty Terminal"
  if is_installed ghostty; then
    log_skip "ghostty"
  else
    log_warn "Ghostty requires manual install on Debian/Ubuntu."
    log_info "  Follow: https://github.com/dariogriffo/ghostty-debian"
  fi

  # ── tmux + TPM ────────────────────────────
  log_section "tmux"
  if is_installed tmux; then
    log_skip "tmux"
  else
    log_step "Installing tmux"
    nala_install tmux
  fi

  if [[ -d "${HOME}/.tmux/plugins/tpm" ]]; then
    log_skip "TPM (tmux plugin manager)"
  else
    log_step "Installing TPM"
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
    log_ok "TPM installed"
    log_info "Open tmux and press: <prefix> + I  to install plugins"
  fi
}

# ─────────────────────────────────────────────
#  Entry point
# ─────────────────────────────────────────────

main() {
  parse_args "$@"

  echo ""
  echo "  Dotfiles Bootstrap Installer"
  echo "  user: ${USER}   home: ${HOME}"

  install_nala

  if [[ "${INSTALL_CORE}" == true ]];     then install_core;     fi
  if [[ "${INSTALL_LANGS}" == true ]];    then install_langs;    fi
  if [[ "${INSTALL_DEVTOOLS}" == true ]]; then install_devtools; fi
  if [[ "${INSTALL_APPS}" == true ]];     then install_apps;     fi

  echo ""
  echo "══════════════════════════════════════════"
  echo "  Bootstrap complete!"
  echo ""
  echo "  Next steps:"
  echo "   1. Re-login or run: exec zsh"
  echo "   2. Link your dotfiles:  bash ~/.dotfiles/automation/install/install.sh"
  echo "   3. Open tmux and press <prefix>+I to install plugins"
  echo "   4. Open nvim — plugins install automatically on first launch"
  echo "   5. Run :Mason inside nvim to install LSP servers"
  echo "══════════════════════════════════════════"
  echo ""
}

main "$@"
