#!/bin/bash
# author: mrp4sten
#
# install.sh — Dotfiles symlink installer
#
# Creates symbolic links from ~/.config and ~/ to the dotfiles repo.
# Safe to re-run: backs up existing files/dirs before replacing them.

set -euo pipefail

DOTFILES_DIR="${HOME}/.dotfiles"
CONFIG_DIR="${HOME}/.config"
BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# ─────────────────────────────────────────────
#  Helpers
# ─────────────────────────────────────────────

log_info() {
  echo "  [INFO]  $1"
}

log_ok() {
  echo "  [ OK ]  $1"
}

log_skip() {
  echo "  [SKIP]  $1"
}

log_warn() {
  echo "  [WARN]  $1"
}

log_section() {
  echo ""
  echo "──────────────────────────────────────────"
  echo "  $1"
  echo "──────────────────────────────────────────"
}

# backup_and_remove <path>
# If <path> exists and is NOT already a symlink pointing to dotfiles,
# move it to the backup dir and remove the original.
backup_and_remove() {
  local target="$1"

  if [ ! -e "${target}" ] && [ ! -L "${target}" ]; then
    return 0
  fi

  if [ -L "${target}" ]; then
    local link_dest
    link_dest="$(readlink -f "${target}" 2>/dev/null || true)"
    if [[ "${link_dest}" == "${DOTFILES_DIR}"* ]]; then
      log_skip "Already linked → ${target}"
      return 1  # signal: skip, already correct
    fi
    log_warn "Removing stale symlink: ${target}"
    rm "${target}"
    return 0
  fi

  mkdir -p "${BACKUP_DIR}"
  local backup_path="${BACKUP_DIR}/$(basename "${target}")"
  log_info "Backing up: ${target} → ${backup_path}"
  mv "${target}" "${backup_path}"
}

# symlink <source_in_dotfiles> <link_path>
symlink() {
  local src="$1"
  local dest="$2"

  if ! backup_and_remove "${dest}"; then
    return 0
  fi

  mkdir -p "$(dirname "${dest}")"
  ln -s "${src}" "${dest}"
  log_ok "Linked: ${dest} → ${src}"
}

# ─────────────────────────────────────────────
#  Main
# ─────────────────────────────────────────────

main() {
  echo ""
  echo "  Dotfiles Symlink Installer"
  echo "  dotfiles dir : ${DOTFILES_DIR}"
  echo "  config dir   : ${CONFIG_DIR}"

  # ── Core: Editor ──────────────────────────
  log_section "Editor — Neovim"
  symlink "${DOTFILES_DIR}/core/editor/nvim" \
          "${CONFIG_DIR}/nvim"

  # ── Core: Multiplexer ─────────────────────
  log_section "Multiplexer — tmux"
  symlink "${DOTFILES_DIR}/core/multiplexer/tmux" \
          "${CONFIG_DIR}/tmux"
  # tmux also needs ~/.tmux.conf → .config/tmux/.tmux.conf
  symlink "${CONFIG_DIR}/tmux/.tmux.conf" \
          "${HOME}/.tmux.conf"

  # ── Core: Terminal emulators ──────────────
  log_section "Terminal — Kitty"
  symlink "${DOTFILES_DIR}/core/terminal/kitty" \
          "${CONFIG_DIR}/kitty"

  log_section "Terminal — Ghostty"
  # Ghostty only has one config file, not a whole dir managed by us
  mkdir -p "${CONFIG_DIR}/ghostty"
  symlink "${DOTFILES_DIR}/core/terminal/ghostty/config" \
          "${CONFIG_DIR}/ghostty/config"

  # ── Core: Shell — Zsh ─────────────────────
  log_section "Shell — Zsh"
  symlink "${DOTFILES_DIR}/core/shell/zsh/.zshrc" \
          "${HOME}/.zshrc"
  symlink "${DOTFILES_DIR}/core/shell/zsh/.p10k.zsh" \
          "${HOME}/.p10k.zsh"
  symlink "${DOTFILES_DIR}/core/shell/zsh/starship.toml" \
          "${CONFIG_DIR}/starship.toml"

  # ── Core: Shell — Bash ────────────────────
  log_section "Shell — Bash"
  symlink "${DOTFILES_DIR}/core/shell/bash/.bashrc" \
          "${HOME}/.bashrc"
  symlink "${DOTFILES_DIR}/core/shell/bash/.git-prompt.sh" \
          "${HOME}/.git-prompt.sh"

  # ── Development: Git tools ────────────────
  log_section "Development — Lazygit"
  symlink "${DOTFILES_DIR}/development/git/lazygit" \
          "${CONFIG_DIR}/lazygit"

  # ── Development: VS Code ──────────────────
  log_section "Development — VS Code"
  symlink "${DOTFILES_DIR}/development/vscode/vscode/settings.json" \
          "${CONFIG_DIR}/Code/User/settings.json"

  # ── Development: AI — opencode ────────────
  log_section "Development — opencode"
  symlink "${DOTFILES_DIR}/development/IA/opencode" \
          "${CONFIG_DIR}/opencode"

  # ── Utilities: fastfetch ──────────────────
  log_section "Utilities — fastfetch"
  symlink "${DOTFILES_DIR}/utilities/system-info/fastfetch" \
          "${CONFIG_DIR}/fastfetch"

  # ── Done ──────────────────────────────────
  echo ""
  echo "  All done!"
  if [ -d "${BACKUP_DIR}" ]; then
    echo "  Backups saved to: ${BACKUP_DIR}"
  fi
  echo ""
}

main "$@"
