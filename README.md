# mrp4sten's Dotfiles

Personal dotfiles for **Ubuntu Linux**, organized by domain. Targets a
**Zsh + Neovim + tmux** development environment with a modern terminal setup.

Configs are managed via **symbolic links** — edit once in this repo, changes reflect everywhere instantly.

---

## Quick Start

```shell
# 1. Clone the repo
git clone https://github.com/mrp4sten/.dotfiles.git ~/.dotfiles
git submodule update --init --recursive

# 2. Install all tools
bash ~/.dotfiles/automation/install/bootstrap.sh

# 3. Link all configs
bash ~/.dotfiles/automation/install/install.sh

# 4. Reload your shell
exec zsh
```

That's it. Two scripts, done.

---

## Repository Structure

```
.dotfiles/
├── automation/
│   ├── generators/config-craft/   # Scaffold JS/Webpack config files
│   └── install/
│       ├── bootstrap.sh           # Install all tools (nvm, pyenv, lazygit, nvim, etc.)
│       ├── install.sh             # Create all symlinks (~/.config → dotfiles)
│       └── desktop-craft.sh       # Create .desktop launcher entries
├── core/
│   ├── editor/nvim/               # LazyVim-based Neovim setup
│   ├── multiplexer/tmux/          # tmux config + TPM plugins
│   ├── shell/bash/                # .bashrc + oh-my-bash
│   ├── shell/zsh/                 # .zshrc + oh-my-zsh + starship prompt
│   └── terminal/
│       ├── ghostty/               # Ghostty terminal config
│       └── kitty/                 # Kitty terminal config + color schemes
├── development/
│   ├── git/lazygit/               # Lazygit config
│   ├── IA/opencode/               # opencode AI assistant config + skills
│   ├── languages/{java,node,python}/  # Language tooling guides
│   └── vscode/                    # VSCode settings.json
├── docs/                          # Documentation
├── system/                        # Boot, desktop, service configs
├── utilities/
│   └── system-info/fastfetch/     # fastfetch config (sm / md / lg layouts)
└── visual/                        # Fonts, icons, themes, wallpapers (git submodules)
```

---

## Automation Scripts

### `bootstrap.sh` — Install tools

Installs every tool this setup depends on. Safe to re-run — skips anything already installed.

```shell
bash ~/.dotfiles/automation/install/bootstrap.sh           # Install everything
bash ~/.dotfiles/automation/install/bootstrap.sh --core    # Shell: zsh, oh-my-zsh, starship
bash ~/.dotfiles/automation/install/bootstrap.sh --langs   # Runtimes: nvm, pyenv, sdkman
bash ~/.dotfiles/automation/install/bootstrap.sh --devtools  # CLI: lazygit, fzf, bat, lsd, atuin...
bash ~/.dotfiles/automation/install/bootstrap.sh --apps    # Apps: nvim, kitty, tmux+TPM, fonts
```

What each flag installs:

| Flag | Tools |
|---|---|
| `--core` | zsh, oh-my-zsh + plugins, oh-my-bash, starship |
| `--langs` | nvm + Node LTS, pyenv + build deps, sdkman + Java 21 |
| `--devtools` | lazygit, fzf, atuin, lsd, bat + catppuccin themes, eza, gum, yazi, fastfetch, opencode |
| `--apps` | Neovim AppImage, stylua, kitty, tmux + TPM, Nerd Fonts (Hack, Cascadia, Fantasque, Martian) |

### `install.sh` — Link configs

Creates symbolic links from `~/.config` and `~/` into this repo. Backs up anything it replaces.

```shell
bash ~/.dotfiles/automation/install/install.sh
```

Symlinks created:

| Link | Source in dotfiles |
|---|---|
| `~/.config/nvim` | `core/editor/nvim/` |
| `~/.config/tmux` | `core/multiplexer/tmux/` |
| `~/.config/kitty` | `core/terminal/kitty/` |
| `~/.config/ghostty/config` | `core/terminal/ghostty/config` |
| `~/.config/lazygit` | `development/git/lazygit/` |
| `~/.config/opencode` | `development/IA/opencode/` |
| `~/.config/fastfetch` | `utilities/system-info/fastfetch/` |
| `~/.config/starship.toml` | `core/shell/zsh/starship.toml` |
| `~/.config/Code/User/settings.json` | `development/vscode/vscode/settings.json` |
| `~/.zshrc` | `core/shell/zsh/.zshrc` |
| `~/.p10k.zsh` | `core/shell/zsh/.p10k.zsh` |
| `~/.bashrc` | `core/shell/bash/.bashrc` |
| `~/.git-prompt.sh` | `core/shell/bash/.git-prompt.sh` |

### `config-craft` — Project config scaffolder

Interactively generates config files (`.gitignore`, `.prettierrc`, `.htmlhintrc`,
`.stylelintrc.json`, `webpack.config.js`) for JS/Webpack projects.

```shell
bash ~/.dotfiles/automation/generators/config-craft/config-craft.sh
# or via zsh function:
config_craft
```

### `desktop-craft` — .desktop entry creator

Creates `.desktop` launcher entries for AppImage or manually installed apps.

```shell
bash ~/.dotfiles/automation/install/desktop-craft.sh
# or via zsh function:
desktop_craft
```

---

## Core Components

### Neovim

LazyVim-based setup. Plugins install automatically on first launch.

See [`core/editor/nvim/README.md`](core/editor/nvim/README.md) for full setup guide.

### Zsh

oh-my-zsh + starship prompt. Config split across three files sourced by `.zshrc`:

| File | Purpose |
|---|---|
| `_aliases/utils.sh` | Aliases for lsd, bat, fastfetch, etc. |
| `_exports/exports.sh` | PATH, pyenv, nvm, sdkman, atuin exports |
| `_functions/functions.sh` | Shell functions: config_craft, desktop_craft |

See [`core/shell/zsh/README.md`](core/shell/zsh/README.md) for full setup guide.

### Bash

oh-my-bash + manual git prompt config.

See [`core/shell/bash/README.md`](core/shell/bash/README.md) for full setup guide.

### tmux

TPM-managed plugins: `tmux-sensible`, `vim-tmux-navigator`, `tmux-resurrect`,
`tmux-continuum`, `tmux-gruvbox`, `tmux-yank`.

See [`core/multiplexer/tmux/README.md`](core/multiplexer/tmux/README.md) for full setup guide.

---

## Development Tools

### Language Runtimes

| Language | Manager | Config |
|---|---|---|
| Node.js | nvm | `exports.sh` — NVM_DIR |
| Python | pyenv | `exports.sh` — PYENV_ROOT |
| Java | sdkman | `exports.sh` — SDKMAN_DIR |
| Gradle / Maven | sdkman | via `sdk install` |

Detailed setup guides:
- [`development/languages/node/README.md`](development/languages/node/README.md)
- [`development/languages/python/README.md`](development/languages/python/README.md)

### Lazygit

See [`development/git/lazygit/README.md`](development/git/lazygit/README.md)

### opencode (AI assistant)

Custom agent config + skills. See [`development/IA/opencode/README.md`](development/IA/opencode/README.md)

### VSCode

Settings: `development/vscode/vscode/settings.json`

Highlights: 2-space indent, `Hack Nerd Font Mono`, Andromeda Italic theme,
format-on-save + organize-imports for JS/TS/Python/Shell.

---

## Ubuntu Initial Setup

Fresh install? Run these before anything else.

```shell
# 1. Update & upgrade
sudo apt-get install nala
sudo nala update && sudo nala upgrade

# 2. Common system packages
sudo nala install preload ubuntu-restricted-extras gnome-tweaks gnome-browser-connector gufw bleachbit
```

**Firefox** — hardware acceleration: open `about:config` and set:
- `layers.acceleration.force-enabled` → `true`
- `gfx.webrender.all` → `true`

**DNS** — switch to Google DNS via nmcli:

```shell
nmcli con mod "Wired connection 1" ipv4.dns "8.8.8.8 8.8.4.4"
nmcli con mod "Wired connection 1" ipv6.dns "2001:4860:4860::8888 2001:4860:4860::8844"
nmcli con up "Wired connection 1"
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

### Terminal

- `lazygit` — terminal UI for git
- `yazi` / `ranger` — terminal file managers
- `atuin` — shell history sync + search
- `fzf` — fuzzy finder (history, file search)
- `lsd` — modern `ls`
- `bat` — modern `cat`
- `eza` — modern `ls` (eza successor)
- `pass` — GPG-based password manager
- `tmux` — terminal multiplexer
- `ncdu` — disk usage analyzer
- `opencode` — AI coding assistant in the terminal

---

## Notes

- Primary distro: **Ubuntu** (this branch)
- Configs are deployed via **symlinks**, not copies — edit in the repo, changes apply instantly
- See [`AGENTS.md`](AGENTS.md) for coding conventions and script style guidelines
- Git submodules live in `visual/` — run `git submodule update --init --recursive` after cloning
