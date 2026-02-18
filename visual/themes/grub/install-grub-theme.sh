#!/bin/bash
# author: mrp4sten
#
# install-grub-theme.sh — Installs a GRUB theme on Ubuntu
# Usage: sudo bash install-grub-theme.sh [theme-name]
# Default theme: crt-amber-theme

# ─── Constants ────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GRUB_THEMES_DIR="/boot/grub/themes"
GRUB_CONFIG="/etc/default/grub"
GRUB_UPDATE_CMD="update-grub"
DEFAULT_THEME="crt-amber-theme"

# ─── Colors ───────────────────────────────────────────────────────────────────

COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_RED="\033[0;31m"
COLOR_CYAN="\033[0;36m"
COLOR_RESET="\033[0m"

# ─── Helpers ──────────────────────────────────────────────────────────────────

log_info() {
  echo -e "${COLOR_CYAN}[INFO]${COLOR_RESET} $1"
}

log_ok() {
  echo -e "${COLOR_GREEN}[OK]${COLOR_RESET} $1"
}

log_warn() {
  echo -e "${COLOR_YELLOW}[WARN]${COLOR_RESET} $1"
}

log_error() {
  echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $1"
}

# ─── Pre-flight checks ────────────────────────────────────────────────────────

check_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    log_error "This script must be run as root."
    echo "  Run: sudo bash install-grub-theme.sh"
    exit 1
  fi
}

check_grub_installed() {
  if ! command -v update-grub &>/dev/null; then
    log_error "update-grub not found. Is GRUB installed?"
    exit 1
  fi
}

check_theme_exists() {
  local theme_path="$1"
  if [[ ! -d "${theme_path}" ]]; then
    log_error "Theme directory not found: ${theme_path}"
    echo "  Available themes:"
    for d in "${SCRIPT_DIR}"/*/; do
      [[ -f "${d}/theme.txt" ]] && echo "    - $(basename "${d}")"
    done
    exit 1
  fi

  if [[ ! -f "${theme_path}/theme.txt" ]]; then
    log_error "No theme.txt found in ${theme_path}. Not a valid GRUB theme."
    exit 1
  fi
}

# ─── Installation ─────────────────────────────────────────────────────────────

install_theme() {
  local theme_name="$1"
  local theme_src="${SCRIPT_DIR}/${theme_name}"
  local theme_dest="${GRUB_THEMES_DIR}/${theme_name}"
  local grub_theme_line="GRUB_THEME=\"${theme_dest}/theme.txt\""

  log_info "Installing theme: ${theme_name}"
  log_info "Source:      ${theme_src}"
  log_info "Destination: ${theme_dest}"
  echo ""

  # Create themes directory if it doesn't exist
  if [[ ! -d "${GRUB_THEMES_DIR}" ]]; then
    log_info "Creating ${GRUB_THEMES_DIR}..."
    mkdir -p "${GRUB_THEMES_DIR}"
  fi

  # Copy theme files
  log_info "Copying theme files..."
  if cp -r "${theme_src}" "${theme_dest}"; then
    log_ok "Theme files copied to ${theme_dest}"
  else
    log_error "Failed to copy theme files."
    exit 1
  fi

  # Backup GRUB config
  local backup_path="${GRUB_CONFIG}.bak.$(date +%Y%m%d_%H%M%S)"
  log_info "Backing up GRUB config to ${backup_path}..."
  cp "${GRUB_CONFIG}" "${backup_path}"
  log_ok "Backup created at ${backup_path}"

  # Patch GRUB config
  if grep -q "^GRUB_THEME=" "${GRUB_CONFIG}"; then
    log_info "Updating existing GRUB_THEME entry..."
    sed -i "s|^GRUB_THEME=.*|${grub_theme_line}|" "${GRUB_CONFIG}"
  else
    log_info "Adding GRUB_THEME entry..."
    echo "${grub_theme_line}" >> "${GRUB_CONFIG}"
  fi

  log_ok "GRUB config updated."

  # Rebuild GRUB
  log_info "Running update-grub..."
  echo ""
  if ${GRUB_UPDATE_CMD}; then
    echo ""
    log_ok "GRUB updated successfully."
  else
    echo ""
    log_error "update-grub failed. Check the output above."
    log_warn "Your original config is backed up at: ${backup_path}"
    exit 1
  fi
}

# ─── Uninstall ────────────────────────────────────────────────────────────────

uninstall_theme() {
  local theme_name="$1"
  local theme_dest="${GRUB_THEMES_DIR}/${theme_name}"

  log_info "Uninstalling theme: ${theme_name}"

  if [[ ! -d "${theme_dest}" ]]; then
    log_warn "Theme not found at ${theme_dest}. Nothing to remove."
    return
  fi

  # Backup GRUB config
  local backup_path="${GRUB_CONFIG}.bak.$(date +%Y%m%d_%H%M%S)"
  cp "${GRUB_CONFIG}" "${backup_path}"
  log_ok "Backup created at ${backup_path}"

  # Remove GRUB_THEME line
  sed -i "/^GRUB_THEME=/d" "${GRUB_CONFIG}"
  log_ok "GRUB_THEME removed from config."

  # Remove theme files
  rm -rf "${theme_dest}"
  log_ok "Theme directory removed: ${theme_dest}"

  # Rebuild GRUB
  log_info "Running update-grub..."
  ${GRUB_UPDATE_CMD}
  log_ok "GRUB updated."
}

# ─── Usage ────────────────────────────────────────────────────────────────────

print_usage() {
  echo ""
  echo "Usage:"
  echo "  sudo bash install-grub-theme.sh [OPTIONS] [theme-name]"
  echo ""
  echo "Options:"
  echo "  --uninstall    Remove the specified theme and restore plain GRUB"
  echo "  --help         Show this message"
  echo ""
  echo "Arguments:"
  echo "  theme-name     Theme directory name (default: ${DEFAULT_THEME})"
  echo ""
  echo "Examples:"
  echo "  sudo bash install-grub-theme.sh"
  echo "  sudo bash install-grub-theme.sh crt-amber-theme"
  echo "  sudo bash install-grub-theme.sh --uninstall crt-amber-theme"
  echo ""
}

# ─── Entry Point ──────────────────────────────────────────────────────────────

main() {
  local uninstall=false
  local theme_name="${DEFAULT_THEME}"

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --uninstall)
        uninstall=true
        shift
        ;;
      --help|-h)
        print_usage
        exit 0
        ;;
      -*)
        log_error "Unknown option: $1"
        print_usage
        exit 1
        ;;
      *)
        theme_name="$1"
        shift
        ;;
    esac
  done

  check_root
  check_grub_installed

  if [[ "${uninstall}" == true ]]; then
    uninstall_theme "${theme_name}"
  else
    check_theme_exists "${SCRIPT_DIR}/${theme_name}"
    install_theme "${theme_name}"
  fi

  echo ""
  log_ok "Done! Reboot to see your new GRUB theme."
  echo ""
}

main "$@"
