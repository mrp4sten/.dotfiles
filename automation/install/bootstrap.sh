#!/usr/bin/env bash
# author: mrp4sten
#
# bootstrap.sh — Full dev environment installer
#
# Supports: Debian/Ubuntu (apt/nala), Arch Linux (pacman + paru/yay AUR)
# Safe to re-run: each installer checks if the tool already exists before acting.
#
# Usage:
#   bootstrap.sh              # Install everything
#   bootstrap.sh --core       # Shell + terminal tools only
#   bootstrap.sh --langs      # Language runtimes only (nvm, pyenv, sdkman)
#   bootstrap.sh --devtools   # Dev CLI tools (lazygit, fzf, atuin, etc.)
#   bootstrap.sh --apps       # Terminal apps (nvim, kitty, ghostty)
#   bootstrap.sh --desktop    # Hyprland desktop environment (Arch only / Ubuntu experimental)
#   bootstrap.sh --help       # Show this help

set -euo pipefail

# ─────────────────────────────────────────────
#  Flags
# ─────────────────────────────────────────────

INSTALL_CORE=false
INSTALL_LANGS=false
INSTALL_DEVTOOLS=false
INSTALL_APPS=false
INSTALL_DESKTOP=false

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
      --desktop)  INSTALL_DESKTOP=true ;;
      --help|-h)
        echo ""
        echo "  Usage: bash bootstrap.sh [--core] [--langs] [--devtools] [--apps] [--desktop]"
        echo ""
        echo "  --core       Shell (zsh/bash), oh-my-zsh, oh-my-bash, starship"
        echo "  --langs      Language runtimes: nvm (Node), pyenv (Python), sdkman (Java)"
        echo "  --devtools   CLI dev tools: lazygit, fzf, atuin, lsd, bat, eza, yazi, gum, opencode, Homebrew, engram"
        echo "  --apps       Terminal apps: Neovim AppImage, kitty, ghostty, pass, tmux"
        echo "  --desktop    Hyprland DE: hyprland, waybar, rofi, hyprpaper, hyprlock, hypridle,"
        echo "               grim, slurp, pipewire, xdg-desktop-portal-hyprland, nwg-look,"
        echo "               pavucontrol, dolphin, dunst — Arch native; Ubuntu experimental"
        echo ""
        echo "  No flags = install everything (except --desktop, always opt-in)"
        echo ""
        echo "  Distros supported: Debian/Ubuntu (nala/apt), Arch Linux (pacman + paru/yay)"
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

# ─────────────────────────────────────────────
#  Distro Detection
# ─────────────────────────────────────────────

DISTRO=""
AUR_HELPER=""

detect_distro() {
  if [[ -f /etc/arch-release ]]; then
    DISTRO="arch"
  elif [[ -f /etc/debian_version ]] || grep -qi "ubuntu\|debian" /etc/os-release 2>/dev/null; then
    DISTRO="debian"
  else
    local distro_name
    distro_name="$(grep '^NAME=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')"
    log_warn "Unsupported distro: ${distro_name:-unknown}"
    log_info "  Supported: Debian/Ubuntu, Arch Linux"
    exit 1
  fi
  log_info "Detected distro: ${DISTRO}"
}

detect_aur_helper() {
  if [[ "${DISTRO}" != "arch" ]]; then
    return
  fi

  if is_installed paru; then
    AUR_HELPER="paru"
  elif is_installed yay; then
    AUR_HELPER="yay"
  else
    AUR_HELPER=""
    log_warn "No AUR helper found (paru or yay). AUR packages may require manual installation."
    log_info "  Install paru: https://aur.archlinux.org/packages/paru"
    log_info "  Or yay:       https://aur.archlinux.org/packages/yay"
    return
  fi

  log_info "AUR helper: ${AUR_HELPER}"
}

# ─────────────────────────────────────────────
#  Package Managers
# ─────────────────────────────────────────────

# nala_install <pkg> [<pkg> ...] — Debian/Ubuntu only
nala_install() {
  local pkgs=("$@")
  local to_install=()

  for pkg in "${pkgs[@]}"; do
    if dpkg -s "${pkg}" &>/dev/null 2>&1; then
      log_skip "${pkg} (apt)"
    else
      to_install+=("${pkg}")
    fi
  done

  if [[ ${#to_install[@]} -gt 0 ]]; then
    log_step "Installing via nala: ${to_install[*]}"
    if sudo -n nala install -y "${to_install[@]}" 2>/dev/null; then
      log_ok "Installed: ${to_install[*]}"
    else
      log_warn "sudo requires password — skipping: ${to_install[*]}"
      log_info "  Install manually: sudo apt install ${to_install[*]}"
    fi
  fi
}

# pacman_install <pkg> [<pkg> ...] — Arch Linux only (official repos)
pacman_install() {
  local pkgs=("$@")
  local to_install=()

  for pkg in "${pkgs[@]}"; do
    if pacman -Q "${pkg}" &>/dev/null 2>&1; then
      log_skip "${pkg} (pacman)"
    else
      to_install+=("${pkg}")
    fi
  done

  if [[ ${#to_install[@]} -gt 0 ]]; then
    log_step "Installing via pacman: ${to_install[*]}"
    if sudo pacman -S --noconfirm --needed "${to_install[@]}"; then
      log_ok "Installed: ${to_install[*]}"
    else
      log_warn "pacman install failed: ${to_install[*]}"
      log_info "  Install manually: sudo pacman -S ${to_install[*]}"
    fi
  fi
}

# aur_install <pkg> [<pkg> ...] — Arch Linux only (AUR via paru/yay)
aur_install() {
  local pkgs=("$@")

  if [[ -z "${AUR_HELPER}" ]]; then
    log_warn "No AUR helper available — skipping: ${pkgs[*]}"
    log_info "  Install manually with paru or yay: ${pkgs[*]}"
    return
  fi

  local to_install=()
  for pkg in "${pkgs[@]}"; do
    if pacman -Q "${pkg}" &>/dev/null 2>&1; then
      log_skip "${pkg} (AUR)"
    else
      to_install+=("${pkg}")
    fi
  done

  if [[ ${#to_install[@]} -gt 0 ]]; then
    log_step "Installing via ${AUR_HELPER} (AUR): ${to_install[*]}"
    if "${AUR_HELPER}" -S --noconfirm --needed "${to_install[@]}"; then
      log_ok "Installed: ${to_install[*]}"
    else
      log_warn "${AUR_HELPER} install failed: ${to_install[*]}"
      log_info "  Install manually: ${AUR_HELPER} -S ${to_install[*]}"
    fi
  fi
}

# ─────────────────────────────────────────────
#  Sections
# ─────────────────────────────────────────────

install_nala() {
  if [[ "${DISTRO}" == "arch" ]]; then
    log_section "Package Manager"
    log_info "Arch Linux — using pacman${AUR_HELPER:+ + ${AUR_HELPER} (AUR)}"
    return
  fi

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
  if [[ "${DISTRO}" == "arch" ]]; then
    pacman_install zsh curl wget git unzip base-devel
  else
    nala_install zsh curl wget git unzip build-essential
  fi

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
  # set +u: nvm.sh uses unbound variables internally
  set +u
  [[ -s "${NVM_DIR}/nvm.sh" ]] && source "${NVM_DIR}/nvm.sh"
  set -u

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
    if [[ "${DISTRO}" == "arch" ]]; then
      pacman_install \
        openssl \
        zlib \
        bzip2 \
        readline \
        sqlite \
        ncurses \
        xz \
        tk \
        libxml2 \
        libxmlsec \
        libffi
    else
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
    fi

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
  # set +u: sdkman scripts use unbound positional params ($3) and vars internally
  set +u
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
  set -u
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
    if [[ "${DISTRO}" == "arch" ]]; then
      pacman_install lazygit
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
  fi

  # ── lsd (modern ls) ───────────────────────
  if is_installed lsd; then
    log_skip "lsd"
  else
    log_step "Installing lsd"
    if [[ "${DISTRO}" == "arch" ]]; then
      pacman_install lsd
    else
      nala_install lsd
    fi
  fi

  # ── bat / batcat ──────────────────────────
  if is_installed bat || is_installed batcat; then
    log_skip "bat"
  else
    log_step "Installing bat"
    if [[ "${DISTRO}" == "arch" ]]; then
      # On Arch the binary is 'bat' (no batcat alias needed)
      pacman_install bat
    else
      local bat_version
      bat_version="$(curl -s "https://api.github.com/repos/sharkdp/bat/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*')"
      curl -Lo /tmp/bat.deb \
        "https://github.com/sharkdp/bat/releases/download/v${bat_version}/bat_${bat_version}_amd64.deb"
      sudo nala install -y /tmp/bat.deb
      rm /tmp/bat.deb
      log_ok "bat ${bat_version} installed"
    fi
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
    if [[ "${DISTRO}" == "arch" ]]; then
      pacman_install eza
    else
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
  fi

  # ── gum (TUI helper — used by config-craft) ─
  if is_installed gum; then
    log_skip "gum"
  else
    log_step "Installing gum"
    if [[ "${DISTRO}" == "arch" ]]; then
      pacman_install gum
    else
      local gum_version
      gum_version="$(curl -s "https://api.github.com/repos/charmbracelet/gum/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*')"
      curl -Lo /tmp/gum.deb \
        "https://github.com/charmbracelet/gum/releases/download/v${gum_version}/gum_${gum_version}_amd64.deb"
      sudo nala install -y /tmp/gum.deb
      rm /tmp/gum.deb
      log_ok "gum ${gum_version} installed"
    fi
  fi

  # ── yazi (terminal file manager) ──────────
  if is_installed yazi; then
    log_skip "yazi"
  else
    log_step "Installing yazi"
    if [[ "${DISTRO}" == "arch" ]]; then
      pacman_install yazi
    else
      local yazi_version
      yazi_version="$(curl -s "https://api.github.com/repos/sxyazi/yazi/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*')"
      curl -Lo /tmp/yazi.deb \
        "https://github.com/sxyazi/yazi/releases/download/v${yazi_version}/yazi-x86_64-unknown-linux-gnu.deb"
      sudo nala install -y /tmp/yazi.deb
      rm /tmp/yazi.deb
      log_ok "yazi ${yazi_version} installed"
    fi
  fi

  # ── fastfetch ─────────────────────────────
  if is_installed fastfetch; then
    log_skip "fastfetch"
  else
    log_step "Installing fastfetch"
    if [[ "${DISTRO}" == "arch" ]]; then
      pacman_install fastfetch
    else
      local ff_version
      ff_version="$(curl -s "https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest" \
        | grep -Po '"tag_name": "\K[^"]*')"
      curl -Lo /tmp/fastfetch.deb \
        "https://github.com/fastfetch-cli/fastfetch/releases/download/${ff_version}/fastfetch-linux-amd64.deb"
      sudo nala install -y /tmp/fastfetch.deb
      rm /tmp/fastfetch.deb
      log_ok "fastfetch ${ff_version} installed"
    fi
  fi

  # ── pass + gpg (password manager) ─────────
  if [[ "${DISTRO}" == "arch" ]]; then
    pacman_install gnupg pass
  else
    nala_install gnupg pass
  fi

  # ── opencode ──────────────────────────────
  if is_installed opencode; then
    log_skip "opencode"
  else
    log_step "Installing opencode"
    curl -fsSL https://opencode.ai/install | bash
    log_ok "opencode installed"
    log_warn "Run: opencode auth login — to authenticate"
  fi

  # opencode npm plugin — ensure nvm is sourced before any npm call
  export NVM_DIR="${HOME}/.nvm"
  # shellcheck disable=SC1091
  # set +u: nvm.sh uses unbound variables internally
  set +u
  [[ -s "${NVM_DIR}/nvm.sh" ]] && source "${NVM_DIR}/nvm.sh"
  set -u

  if is_installed npm; then
    if npm list -g opencode-anthropic-auth &>/dev/null 2>&1; then
      log_skip "opencode-anthropic-auth (npm global)"
    else
      log_step "Installing opencode-anthropic-auth"
      npm install -g opencode-anthropic-auth
      log_ok "opencode-anthropic-auth installed"
    fi
  else
    log_warn "npm not found — skipping opencode-anthropic-auth"
    log_info "  Install Node.js first: bash bootstrap.sh --langs"
  fi

  # ── Homebrew ──────────────────────────────
  if is_installed brew; then
    log_skip "Homebrew"
  else
    log_step "Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for current session
    if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    log_ok "Homebrew installed"
    log_warn "Add Homebrew to PATH: eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""
  fi

  # ── Engram ────────────────────────────────
  if is_installed engram; then
    log_skip "Engram"
  else
    if is_installed brew; then
      log_step "Installing Engram via Homebrew"
      brew install gentleman-programming/tap/engram
      log_ok "Engram installed"
    else
      log_warn "Homebrew not found — skipping Engram (install Homebrew first)"
    fi
  fi
}

install_apps() {
  log_section "Terminal Apps"

  # ── Nerd Fonts (user-space, no sudo needed) ─
  local font_dir="${HOME}/.local/share/fonts"
  log_section "Nerd Fonts"

  # Create font directory if needed
  mkdir -p "${font_dir}"

  if fc-list | grep -qi "Hack Nerd Font"; then
    log_skip "Hack Nerd Font"
  else
    log_step "Installing Hack Nerd Font"
    wget -qP "${font_dir}" \
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Hack.zip"
    unzip -qo "${font_dir}/Hack.zip" -d "${font_dir}"
    rm "${font_dir}/Hack.zip"
    log_ok "Hack Nerd Font installed"
  fi

  if fc-list | grep -qi "CascadiaCode"; then
    log_skip "CascadiaCode Nerd Font"
  else
    log_step "Installing CascadiaCode Nerd Font"
    wget -qP "${font_dir}" \
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip"
    unzip -qo "${font_dir}/CascadiaCode.zip" -d "${font_dir}"
    rm "${font_dir}/CascadiaCode.zip"
    log_ok "CascadiaCode Nerd Font installed"
  fi

  if fc-list | grep -qi "FantasqueSansMono"; then
    log_skip "FantasqueSansMono Nerd Font"
  else
    log_step "Installing FantasqueSansMono Nerd Font"
    wget -qP "${font_dir}" \
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FantasqueSansMono.zip"
    unzip -qo "${font_dir}/FantasqueSansMono.zip" -d "${font_dir}"
    rm "${font_dir}/FantasqueSansMono.zip"
    log_ok "FantasqueSansMono Nerd Font installed"
  fi

  if fc-list | grep -qi "MartianMono"; then
    log_skip "MartianMono Nerd Font"
  else
    log_step "Installing MartianMono Nerd Font"
    wget -qP "${font_dir}" \
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/MartianMono.zip"
    unzip -qo "${font_dir}/MartianMono.zip" -d "${font_dir}"
    rm "${font_dir}/MartianMono.zip"
    log_ok "MartianMono Nerd Font installed"
  fi

  # Rebuild font cache
  log_step "Rebuilding font cache"
  fc-cache -fv &>/dev/null
  log_ok "Font cache rebuilt"

  # ── Neovim ────────────────────────────────
  log_section "Neovim"
  if [[ "${DISTRO}" == "arch" ]]; then
    # On Arch, neovim is in the official repos and always up-to-date
    pacman_install neovim
    # Ensure nvim is available as vi for alias compatibility
    if is_installed nvim && [[ ! -f "${HOME}/.local/bin/vi" ]]; then
      mkdir -p "${HOME}/.local/bin"
      ln -sf "$(command -v nvim)" "${HOME}/.local/bin/vi"
      log_ok "Symlinked nvim → ~/.local/bin/vi"
    fi
  else
    # On Debian/Ubuntu use the AppImage (apt repos ship outdated versions)
    local nvim_appimage="${HOME}/.local/bin/nvim-linux-x86_64.appimage"
    local nvim_link="${HOME}/.local/bin/nvim"
    mkdir -p "${HOME}/.local/bin"
    if [[ -f "${nvim_appimage}" ]]; then
      log_skip "Neovim AppImage"
    else
      log_step "Downloading latest Neovim AppImage"
      curl -Lo "${nvim_appimage}" \
        "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
      chmod +x "${nvim_appimage}"
      log_ok "Neovim AppImage installed at ${nvim_appimage}"
    fi
    # Create nvim symlink so 'nvim' works from PATH
    if [[ ! -L "${nvim_link}" ]]; then
      ln -sf "${nvim_appimage}" "${nvim_link}"
      log_ok "Symlinked nvim AppImage → ~/.local/bin/nvim"
    fi
  fi

  # ── stylua (Lua formatter for nvim config) ─
  if is_installed stylua; then
    log_skip "stylua"
  else
    if is_installed cargo; then
      log_step "Installing stylua via cargo"
      if cargo install stylua 2>/dev/null; then
        log_ok "stylua installed"
      else
        log_warn "stylua install failed (Rust version mismatch). Update Rust with: rustup update"
        log_info "  Or install manually: cargo install stylua"
      fi
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
    if [[ "${DISTRO}" == "arch" ]]; then
      pacman_install kitty
    else
      nala_install kitty
    fi
  fi

  # ── ghostty ───────────────────────────────
  log_section "Ghostty Terminal"
  if is_installed ghostty; then
    log_skip "ghostty"
  else
    if [[ "${DISTRO}" == "arch" ]]; then
      log_step "Installing ghostty via AUR"
      aur_install ghostty
    else
      log_warn "Ghostty requires manual install on Debian/Ubuntu."
      log_info "  Follow: https://github.com/dariogriffo/ghostty-debian"
    fi
  fi

  # ── tmux + TPM ────────────────────────────
  log_section "tmux"
  if is_installed tmux; then
    log_skip "tmux"
  else
    log_step "Installing tmux"
    if [[ "${DISTRO}" == "arch" ]]; then
      pacman_install tmux
    else
      nala_install tmux
    fi
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

install_desktop() {
  log_section "Desktop Environment — Hyprland"

  if [[ "${DISTRO}" == "debian" ]]; then
    log_warn "Hyprland on Debian/Ubuntu requires manual compilation or third-party repos."
    log_info "  Reference: https://wiki.hyprland.org/Getting-Started/Installation/"
    log_info "  Continuing with best-effort apt installs for available packages..."
    log_info ""
  fi

  # ── Hyprland ──────────────────────────────
  if [[ "${DISTRO}" == "arch" ]]; then
    pacman_install hyprland
  else
    log_warn "Hyprland is not in standard Ubuntu/Debian repos — skipping pacman install."
    log_info "  Build from source: https://wiki.hyprland.org/Getting-Started/Installation/"
  fi

  # ── Kitty (default terminal for Hyprland) ─
  if [[ "${DISTRO}" == "arch" ]]; then
    pacman_install kitty
  else
    nala_install kitty
  fi

  # ── NVIDIA detection & config hint ────────
  log_section "GPU Detection"
  if lspci 2>/dev/null | grep -qi "nvidia"; then
    log_info "NVIDIA GPU detected."
    if [[ "${DISTRO}" == "arch" ]]; then
      log_step "Installing nvidia-dkms and nvidia-utils"
      aur_install nvidia-dkms nvidia-utils
    else
      log_warn "Install NVIDIA drivers manually for your Ubuntu/Debian version."
      log_info "  https://wiki.ubuntu.com/NvidiaMultimediaDrivers"
    fi
    log_info ""
    log_warn "Add these env vars to your Hyprland config (environment_variables.conf):"
    log_info "  env = LIBVA_DRIVER_NAME,nvidia"
    log_info "  env = __GLX_VENDOR_LIBRARY_NAME,nvidia"
    log_info "  env = NVD_BACKEND,direct"
    log_info "  env = ELECTRON_OZONE_PLATFORM_HINT,auto"
  else
    log_info "No NVIDIA GPU detected — skipping NVIDIA driver install."
  fi

  # ── Waybar ────────────────────────────────
  log_section "Waybar"
  if [[ "${DISTRO}" == "arch" ]]; then
    aur_install waybar
  else
    nala_install waybar
  fi

  # ── Hyprpaper (wallpaper daemon) ──────────
  log_section "Hyprpaper"
  if is_installed hyprpaper; then
    log_skip "hyprpaper"
  else
    if [[ "${DISTRO}" == "arch" ]]; then
      aur_install hyprpaper
    else
      log_warn "hyprpaper is Arch-specific. On Ubuntu, consider feh or swaybg."
      log_info "  sudo apt install swaybg"
    fi
  fi

  # ── Rofi (app launcher) ───────────────────
  log_section "Rofi"
  if [[ "${DISTRO}" == "arch" ]]; then
    aur_install rofi-wayland
  else
    nala_install rofi
  fi

  # ── hyprlock (lock screen) ────────────────
  log_section "hyprlock"
  if is_installed hyprlock; then
    log_skip "hyprlock"
  else
    if [[ "${DISTRO}" == "arch" ]]; then
      aur_install hyprlock
    else
      log_warn "hyprlock is Hyprland-native (AUR). On Ubuntu, install from source."
      log_info "  https://github.com/hyprwm/hyprlock"
    fi
  fi

  # ── hypridle (idle daemon) ────────────────
  log_section "hypridle"
  if is_installed hypridle; then
    log_skip "hypridle"
  else
    if [[ "${DISTRO}" == "arch" ]]; then
      aur_install hypridle
    else
      log_warn "hypridle is Hyprland-native (AUR). On Ubuntu, install from source."
      log_info "  https://github.com/hyprwm/hypridle"
    fi
  fi

  # ── nwg-look (GTK theme manager for Wayland) ─
  log_section "nwg-look"
  if [[ "${DISTRO}" == "arch" ]]; then
    pacman_install nwg-look
  else
    log_warn "nwg-look is Arch-specific. On Ubuntu, use lxappearance instead."
    nala_install lxappearance
  fi

  # ── Screenshot tools: grim + slurp ────────
  log_section "Screenshot — grim + slurp"
  if [[ "${DISTRO}" == "arch" ]]; then
    pacman_install grim slurp
  else
    nala_install grim slurp
  fi

  # Create Screenshots directory
  if [[ ! -d "${HOME}/Pictures/Screenshots" ]]; then
    mkdir -p "${HOME}/Pictures/Screenshots"
    log_ok "Created ~/Pictures/Screenshots"
  else
    log_skip "~/Pictures/Screenshots already exists"
  fi

  # ── Audio: pipewire + wireplumber ─────────
  log_section "Audio — PipeWire"
  if [[ "${DISTRO}" == "arch" ]]; then
    pacman_install pipewire wireplumber pipewire-alsa pipewire-pulse
  else
    nala_install pipewire wireplumber pipewire-alsa pipewire-pulse gstreamer1.0-pipewire
  fi

  # ── Screen sharing: xdg-desktop-portal ────
  log_section "Screen Sharing — xdg-desktop-portal-hyprland"
  if [[ "${DISTRO}" == "arch" ]]; then
    aur_install xdg-desktop-portal-hyprland
    pacman_install xdg-desktop-portal-gtk
  else
    nala_install xdg-desktop-portal-wlr xdg-desktop-portal-gtk
    log_warn "xdg-desktop-portal-hyprland is AUR-only. Using xdg-desktop-portal-wlr on Ubuntu."
  fi

  # ── pavucontrol (audio volume GUI) ────────
  log_section "pavucontrol"
  if [[ "${DISTRO}" == "arch" ]]; then
    pacman_install pavucontrol
  else
    nala_install pavucontrol
  fi

  # ── Dolphin (file manager) ────────────────
  log_section "Dolphin — File Manager"
  if [[ "${DISTRO}" == "arch" ]]; then
    pacman_install dolphin
  else
    nala_install dolphin
  fi

  # ── Notification daemon: dunst ────────────
  log_section "Notification Daemon — dunst"
  if [[ "${DISTRO}" == "arch" ]]; then
    pacman_install dunst
  else
    nala_install dunst
  fi

  # ── wev (Wayland event debug tool) ────────
  log_section "wev — Wayland event viewer"
  if [[ "${DISTRO}" == "arch" ]]; then
    pacman_install wev
  else
    log_warn "wev is Arch-specific. On Ubuntu, use wev from source or omit."
    log_info "  https://git.sr.ht/~sircmpwn/wev"
  fi

  # ── Polkit agent (GUI privilege escalation) ─
  log_section "Polkit Agent — hyprpolkitagent"
  if [[ "${DISTRO}" == "arch" ]]; then
    aur_install hyprpolkitagent
  else
    nala_install policykit-1-gnome
    log_warn "Using gnome-polkit on Ubuntu instead of hyprpolkitagent."
  fi

  log_section "Desktop — Done"
  log_info "Don't forget to run: bash ~/.dotfiles/automation/install/install.sh"
  log_info "to symlink your hypr, waybar and rofi configs."
}

# ─────────────────────────────────────────────
#  Entry point
# ─────────────────────────────────────────────

main() {
  parse_args "$@"

  echo ""
  echo "  Dotfiles Bootstrap Installer"
  echo "  user: ${USER}   home: ${HOME}"

  detect_distro
  detect_aur_helper

  install_nala

  if [[ "${INSTALL_CORE}" == true ]];     then install_core;     fi
  if [[ "${INSTALL_LANGS}" == true ]];    then install_langs;    fi
  if [[ "${INSTALL_DEVTOOLS}" == true ]]; then install_devtools; fi
  if [[ "${INSTALL_APPS}" == true ]];     then install_apps;     fi
  if [[ "${INSTALL_DESKTOP}" == true ]];  then install_desktop;  fi

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
  if [[ "${INSTALL_DESKTOP}" == true ]]; then
  echo "   6. Reboot to switch to SDDM / Hyprland"
  fi
  echo "══════════════════════════════════════════"
  echo ""
}

main "$@"
