# mrp4sten's Dotfiles

Personal dotfiles for **Ubuntu Linux**, organized by domain. Targets a
**Zsh + Neovim + tmux** development environment with a modern terminal setup.

> Read the README in each subdirectory for component-specific install instructions.

---

## Repository Structure

```
.dotfiles/
├── automation/        # Scripts: config-craft, desktop-craft
├── core/              # Shell, editor, terminal, multiplexer configs
│   ├── editor/nvim/   # LazyVim-based Neovim setup
│   ├── multiplexer/tmux/
│   ├── shell/bash/    # Bashrc + oh-my-bash
│   ├── shell/zsh/     # Zshrc + oh-my-zsh + starship prompt
│   └── terminal/      # Kitty & Ghostty configs
├── development/       # Language tooling, Git config, VSCode settings
├── docs/              # Documentation
├── system/            # Boot, desktop, service configs
├── utilities/         # fastfetch, file management, security, text processing
└── visual/            # Fonts, icons, themes, wallpapers (git submodules)
```

---

## Ubuntu Initial Setup

Fresh Ubuntu install? Run these steps in order before doing anything else.

### 1. Update & upgrade with nala

[nala](https://gitlab.com/volian/nala) is a prettier, faster front-end for `apt` with
parallel downloads and a cleaner output.

```shell
sudo apt-get install nala
sudo nala update && sudo nala upgrade
```

### 2. Install preload

`preload` runs as a daemon and learns which apps you use most. It pre-loads them into RAM
so they open faster over time.

```shell
sudo nala install preload
```

### 3. Firefox tweaks (hardware acceleration)

Open `about:config` in Firefox and set these two flags to `true`:

| Preference | Value |
|---|---|
| `layers.acceleration.force-enabled` | `true` |
| `gfx.webrender.all` | `true` |

Restart Firefox. This enables GPU-accelerated compositing and WebRender, which noticeably
reduces CPU usage during video playback and scrolling.

### 4. Change DNS (Google)

In **Settings → Network → (your connection) → IPv4 / IPv6**, set:

| Protocol | DNS servers |
|---|---|
| IPv4 | `8.8.8.8, 8.8.4.4` |
| IPv6 | `2001:4860:4860::8888, 2001:4860:4860::8844` |

Or apply it via `nmcli` (replace `"Wired connection 1"` with your connection name):

```shell
nmcli con mod "Wired connection 1" ipv4.dns "8.8.8.8 8.8.4.4"
nmcli con mod "Wired connection 1" ipv6.dns "2001:4860:4860::8888 2001:4860:4860::8844"
nmcli con up "Wired connection 1"
```

### 5. Restricted extras (codecs, fonts, flash)

Installs MP3/MP4 codecs, Microsoft fonts, and other commonly needed proprietary bits that
Ubuntu cannot ship by default.

```shell
sudo nala install ubuntu-restricted-extras
```

### 6. GNOME Tweaks & browser connector

**GNOME Tweaks** gives you fine-grained control over fonts, window buttons, extensions,
and startup apps. **gnome-browser-connector** lets you install GNOME Shell extensions
directly from [extensions.gnome.org](https://extensions.gnome.org).

```shell
sudo nala install gnome-tweaks gnome-browser-connector
```

### 7. Firewall (gufw)

`gufw` is a graphical front-end for `ufw`. Enable it after install to block unwanted
incoming connections.

```shell
sudo nala install gufw
# Then open "Firewall Configuration" from the app menu and toggle the firewall ON
```

### 8. Synaptic Package Manager

A GUI package manager that gives you more control than the Software Center, including the
ability to lock package versions.

```shell
sudo nala install synaptic
```

### 9. BleachBit (system cleaner)

Clears caches, logs, browser history, and other junk to free up disk space.

```shell
sudo nala install bleachbit
```

> Run BleachBit as **root only when necessary** (e.g. cleaning system logs).
> For user-level caches, run it as your normal user to avoid permission issues.

---

## Quick Start

```shell
git clone https://github.com/mrp4sten/.dotfiles.git ~/.dotfiles
git submodule update --init --recursive
```

Then follow the README in each component directory to copy or symlink files.

---

## Core Components

### Zsh

Files live in `core/shell/zsh/`. Requires **oh-my-zsh** and **starship**.

```shell
cp ~/.dotfiles/core/shell/zsh/.zshrc ~/
cp ~/.dotfiles/core/shell/zsh/.p10k.zsh ~/
cp ~/.dotfiles/core/shell/zsh/starship.toml ~/.config/
```

Key files sourced by `.zshrc`:

| File | Purpose |
|------|---------|
| `_aliases/utils.sh` | Aliases for lsd, bat, fastfetch, etc. |
| `_exports/exports.sh` | PATH, pyenv, kubeconfig exports |
| `_functions/functions.sh` | Shell functions (clean, clean_kernels, config_craft, desktop_craft) |

### Bash

Files live in `core/shell/bash/`. Requires **oh-my-bash**.

```shell
cp ~/.dotfiles/core/shell/bash/.bashrc ~/
cp ~/.dotfiles/core/shell/bash/.git-prompt.sh ~/
```

### Tmux

Files live in `core/multiplexer/tmux/`. Requires **TPM** (Tmux Plugin Manager).

```shell
cp -r ~/.dotfiles/core/multiplexer/tmux ~/.config
ln -sf ~/.config/tmux/.tmux.conf ~/
# Install plugins: open tmux, then press Ctrl+Space, then Shift+I
```

Plugins used: `tmux-sensible`, `vim-tmux-navigator`, `tmux-resurrect`,
`tmux-continuum`, `tmux-gruvbox`, `tmux-yank`.

### Neovim

LazyVim-based setup lives in `core/editor/nvim/`. Install manually when ready.

### Terminals

- **Kitty** — `core/terminal/kitty/` → `cp -r ~/.dotfiles/core/terminal/kitty ~/.config`
- **Ghostty** — `core/terminal/ghostty/` → follow [ghostty-debian](https://github.com/dariogriffo/ghostty-debian)

---

## Development Tools

### VSCode

Settings live in `development/vscode/vscode/settings.json`.

```shell
cp ~/.dotfiles/development/vscode/vscode/settings.json ~/.config/Code/User/
```

Highlights: 2-space indentation, `Dank Mono` / `Hack Nerd Font Mono`, Andromeda
Italic theme, on-save fix-all + organize-imports, SonarLint enabled.

### Runtime Version Managers

| Language | Manager | Notes |
|----------|---------|-------|
| Java | sdkman | JDK 8, 11, 17, 21 configured |
| Python | pyenv | Init in `_exports/exports.sh` |
| Node / npm / yarn | asdf or nodenv | |
| Gradle | sdkman | `~/.sdkman/candidates/gradle/8.11.1` |
| Maven | sdkman | `~/.sdkman/candidates/maven/current/bin/mvn` |

---

## Automation Scripts

### config-craft

Interactively scaffold config files (`.gitignore`, `.prettierrc`, `.htmlhintrc`,
`.stylelintrc.json`, `webpack.config.js`) for JS or Webpack projects.

```shell
bash ~/.dotfiles/automation/generators/config-craft/config-craft.sh
# or via zsh function:
config_craft
```

### desktop-craft

Create a `.desktop` launcher entry for any application.

```shell
bash ~/.dotfiles/automation/install/desktop-craft.sh
# or via zsh function:
desktop_craft
```

---

## Utilities

### fastfetch

```shell
cp -r ~/.dotfiles/utilities/system-info/fastfetch ~/.config/
# aliases: fastfetchsm | fastfetchmd | fastfetchlg
```

---

## Favorite Applications

### GUI

- Google Chrome, Firefox
- Kitty Terminal, Ghostty
- Visual Studio Code
- YouTube Music, Discord, OBS, Kdenlive
- Bruno, Postman
- LibreOffice, Thunderbird
- Bitwarden, Stacer, Timeshift, Ulauncher

### Terminal (Zsh)

- `pass` — GPG-based password manager
- `bpytop` — resource monitor
- `sdkman` / `asdf` — version managers
- `tmux` — terminal multiplexer
- `ranger` / `yazi` — terminal file managers
- `ncdu` — disk usage analyzer
- `fzf` — fuzzy finder (history, file search)
- `lsd` — modern `ls` replacement
- `bat` — modern `cat` replacement

---

## Fonts

Nerd Fonts used across terminal and editor:

- Hack Nerd Font Mono
- Dank Mono
- CascadiaCode NF
- FantasqueSansMono NF
- MartianMono NF

```shell
cd /usr/share/fonts
sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Hack.zip
sudo unzip Hack.zip && sudo rm Hack.zip
fc-cache -fv
```

---

## Notes

- Primary distro: **Ubuntu** (this branch)
- No build system or CI pipeline — all config is deploy-by-copy
- See `AGENTS.md` for coding conventions and style guidelines
