#!/bin/bash
# author: mrp4sten

# ─────────────────────────────────────────────
# desktop-craft — .desktop entry generator
# Modes:
#   --appimage  : extract .desktop from an AppImage and install it
#   (no args)   : manually craft a .desktop entry via gum prompts
# ─────────────────────────────────────────────

LOCAL_BIN="${HOME}/.local/bin"
LOCAL_APPS="${HOME}/.local/share/applications"
LOCAL_ICONS="${HOME}/.local/share/icons"

# ─── Helpers ──────────────────────────────────

check_deps() {
  local missing=()
  for dep in "$@"; do
    if ! command -v "${dep}" &>/dev/null; then
      missing+=("${dep}")
    fi
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "Error: missing required tools: ${missing[*]}"
    exit 1
  fi
}

ensure_dirs() {
  mkdir -p "${LOCAL_BIN}" "${LOCAL_APPS}" "${LOCAL_ICONS}"
}

# ─── Mode: AppImage ───────────────────────────

mode_appimage() {
  check_deps gum

  gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1 2" \
    "AppImage → .desktop installer"

  # 1. Pick AppImage file
  local appimage_path
  appimage_path=$(gum file --file --height 15 .)
  if [[ -z "${appimage_path}" ]]; then
    echo "Error: no AppImage selected."
    exit 1
  fi

  if [[ "${appimage_path}" != *.AppImage && "${appimage_path}" != *.appimage ]]; then
    gum confirm "That file doesn't look like an AppImage. Continue anyway?" || exit 1
  fi

  local appimage_name
  appimage_name=$(basename "${appimage_path}")

  # 2. Destination inside ~/.local/bin
  local dest_path="${LOCAL_BIN}/${appimage_name}"

  gum style --foreground 99 "Step 1/5 — Make executable + move to ${LOCAL_BIN}"

  chmod +x "${appimage_path}"
  if [[ "$(realpath "${appimage_path}")" != "$(realpath "${dest_path}")" ]]; then
    cp "${appimage_path}" "${dest_path}"
    echo "  Copied → ${dest_path}"
  else
    echo "  Already in ${LOCAL_BIN}, skipping copy."
  fi

  # 3. Extract AppImage into a temp dir
  gum style --foreground 99 "Step 2/5 — Extracting AppImage..."
  local tmp_dir
  tmp_dir=$(mktemp -d)
  local squash_dir="${tmp_dir}/squashfs-root"

  (cd "${tmp_dir}" && "${dest_path}" --appimage-extract > /dev/null 2>&1)

  if [[ ! -d "${squash_dir}" ]]; then
    echo "Error: extraction failed — squashfs-root not found."
    rm -rf "${tmp_dir}"
    exit 1
  fi

  # 4. Find the .desktop file inside squashfs-root
  gum style --foreground 99 "Step 3/5 — Locating .desktop file..."
  local desktop_src
  desktop_src=$(find "${squash_dir}" -maxdepth 2 -name "*.desktop" | head -n 1)

  if [[ -z "${desktop_src}" ]]; then
    echo "Error: no .desktop file found inside AppImage."
    rm -rf "${tmp_dir}"
    exit 1
  fi

  echo "  Found: $(basename "${desktop_src}")"
  local desktop_name
  desktop_name=$(basename "${desktop_src}")
  local desktop_dest="${LOCAL_APPS}/${desktop_name}"

  # 5. Copy and patch Exec= line
  gum style --foreground 99 "Step 4/5 — Patching Exec= and installing .desktop..."
  cp "${desktop_src}" "${desktop_dest}"

  # Ask for exec arguments (%F, %U, %u, or none)
  local exec_arg
  exec_arg=$(gum choose --header "Select Exec argument" "%F" "%U" "%u" "(none)")
  [[ "${exec_arg}" == "(none)" ]] && exec_arg=""

  # Patch Exec= line — replace whatever was there with our AppImage path
  local exec_line="Exec=${dest_path}"
  [[ -n "${exec_arg}" ]] && exec_line="Exec=${dest_path} ${exec_arg}"

  sed -i "s|^Exec=.*|${exec_line}|" "${desktop_dest}"

  # Also patch TryExec= if present
  sed -i "s|^TryExec=.*|TryExec=${dest_path}|" "${desktop_dest}"

  # 6. Copy icons if they exist inside squashfs-root
  gum style --foreground 99 "Step 5/5 — Installing icons (if any)..."
  local icons_src="${squash_dir}/usr/share/icons"
  if [[ -d "${icons_src}" ]]; then
    cp -r "${icons_src}/." "${LOCAL_ICONS}/"
    echo "  Icons installed → ${LOCAL_ICONS}"
  else
    # fallback: grab any .png/.svg at root level
    local root_icon
    root_icon=$(find "${squash_dir}" -maxdepth 1 \( -name "*.png" -o -name "*.svg" \) | head -n 1)
    if [[ -n "${root_icon}" ]]; then
      cp "${root_icon}" "${LOCAL_ICONS}/"
      echo "  Fallback icon installed: $(basename "${root_icon}")"
    else
      echo "  No icons found, skipping."
    fi
  fi

  # 7. Set permissions and cleanup
  chmod +x "${desktop_dest}"
  rm -rf "${tmp_dir}"

  # Update icon cache if gtk-update-icon-cache is available
  if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -t "${LOCAL_ICONS}" 2>/dev/null || true
  fi

  gum style \
    --foreground 82 --border-foreground 82 --border rounded \
    --align center --width 60 --margin "1 2" \
    "Done! ${desktop_name} installed." \
    "" \
    "AppImage  → ${dest_path}" \
    ".desktop  → ${desktop_dest}"
}

# ─── Mode: Manual ────────────────────────────

mode_manual() {
  check_deps gum

  gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1 2" \
    "Manual .desktop entry creator"

  local desktop_name display_name description version exec icon install_scope

  desktop_name=$(gum input --placeholder "Desktop entry filename (no extension)")
  display_name=$(gum input --placeholder "Application display name")
  description=$(gum input --placeholder "Short description (optional)")
  version=$(gum input --placeholder "Version (e.g. 1.0)")
  exec=$(gum input --placeholder "Exec command or path to binary")
  icon=$(gum input --placeholder "Icon name or full path (optional)")

  if [[ -z "${desktop_name}" || -z "${display_name}" || -z "${version}" || -z "${exec}" ]]; then
    echo "Error: desktop name, display name, version and exec are required."
    exit 1
  fi

  install_scope=$(gum choose --header "Install for:" "Current user (~/.local/share/applications)" "System-wide (/usr/share/applications)")

  local file="${desktop_name}.desktop"
  local tmp_file
  tmp_file=$(mktemp)

  cat > "${tmp_file}" << EOF
[Desktop Entry]
Version=${version}
Encoding=UTF-8
Name=${display_name}
Comment=${description}
Exec=${exec}
Icon=${icon}
Terminal=false
Type=Application
EOF

  if [[ "${install_scope}" == *"System-wide"* ]]; then
    sudo install -D -m 0644 "${tmp_file}" "/usr/share/applications/${file}"
    rm -f "${tmp_file}"
    echo "Installed → /usr/share/applications/${file}"
  else
    ensure_dirs
    install -D -m 0644 "${tmp_file}" "${LOCAL_APPS}/${file}"
    rm -f "${tmp_file}"
    echo "Installed → ${LOCAL_APPS}/${file}"
  fi

  gum style \
    --foreground 82 --border-foreground 82 --border rounded \
    --align center --width 50 --margin "1 2" \
    "Done! ${file} created."
}

# ─── Entry point ──────────────────────────────

main() {
  ensure_dirs

  case "${1:-}" in
    --appimage|-a)
      mode_appimage
      ;;
    --manual|-m|"")
      mode_manual
      ;;
    --help|-h)
      echo "Usage: desktop-craft [--appimage | --manual]"
      echo ""
      echo "  --appimage, -a   Extract .desktop from an AppImage and install it"
      echo "  --manual,   -m   Manually create a .desktop entry (default)"
      ;;
    *)
      echo "Unknown option: ${1}"
      echo "Run with --help for usage."
      exit 1
      ;;
  esac
}

main "$@"
