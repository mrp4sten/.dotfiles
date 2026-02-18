# AGENTS.md — Dotfiles Repository Guide

This file provides guidance for agentic coding agents working in this repository.

## Repository Overview

A personal dotfiles repository for Ubuntu Linux, targeting a Zsh + Neovim + tmux
development environment. Configs are organized by domain rather than by symlink destination.

```shell
.dotfiles/
├── automation/        # Install scripts, generators, maintenance scripts
│   ├── generators/    # config-craft: scaffolds JS/Webpack project config files
│   ├── install/       # desktop-craft: creates .desktop launcher entries
│   └── maintenance/   # system maintenance scripts
├── core/              # Shell, editor, terminal, multiplexer configs
│   ├── editor/nvim/   # LazyVim-based Neovim setup
│   ├── multiplexer/tmux/
│   ├── shell/bash/    # Bashrc + oh-my-bash
│   └── shell/zsh/     # Zshrc + oh-my-zsh + starship prompt
├── development/       # Language tooling, Git config, VSCode settings
│   ├── languages/{java,node,python}/
│   └── vscode/        # VSCode settings.json
|   └── IA/{opencode,claude,codex}/ # Config for LLMs
├── docs/              # Documentation
├── system/            # Boot, desktop, service configs
├── utilities/         # fastfetch, file management, security, text processing
└── visual/            # Fonts, icons, themes, wallpapers (includes git submodules)
```

## Installation / Deployment

There is no build system. Configs are deployed by copying or symlinking files manually.
Each subdirectory contains a README.md with its own copy instructions.

**General pattern:**

```shell
cp ~/.dotfiles/core/shell/zsh/.zshrc ~/
cp ~/.dotfiles/core/shell/zsh/.p10k.zsh ~/
cp ~/.dotfiles/core/shell/bash/.bashrc ~/
cp ~/.dotfiles/core/shell/bash/.git-prompt.sh ~/
cp -r ~/.dotfiles/utilities/system-info/fastfetch ~/.config/
```

**Tmux:**

```shell
cp ~/.dotfiles/core/multiplexer/tmux/.tmux.conf ~/
# Install plugins via TPM: prefix + I inside a tmux session
```

**Git submodules** (visual themes):

```shell
git submodule update --init --recursive
```

## Automation Scripts

### config-craft — project config file generator

Interactive script using `gum` to scaffold config files for JS/Webpack projects.

```shell
bash ~/.dotfiles/automation/generators/config-craft/config-craft.sh
# Or via zsh function alias:
config_craft
```

Copies one of: `.gitignore`, `.prettierrc`, `.htmlhintrc`, `.stylelintrc.json`, `webpack.config.js`

### desktop-craft — .desktop entry creator

```shell
bash ~/.dotfiles/automation/install/desktop-craft.sh
# Or via zsh function alias:
desktop_craft
```

## No Test Suite

This repository has no automated test suite, linter CI, or build pipeline.
Shell scripts can be syntax-checked locally:

```shell
bash -n <script.sh>          # Dry-run syntax check
shellcheck <script.sh>       # Static analysis (install: sudo pacman -S shellcheck)
```

## Shell Script Style Guide

All shell scripts in this repo follow these conventions:

### Shebang and Header

```bash
#!/bin/bash
# author: mrp4sten
```

Use `#!/bin/bash` for scripts requiring bashisms; `#!/bin/sh` for POSIX-portable scripts.

### Variables

- Use `UPPER_SNAKE_CASE` for global/environment variables and script-level constants.
- Use `lower_snake_case` for local variables inside functions.
- Always declare function-local variables with `local`.
- Quote all variable expansions: `"${VAR}"` not `$VAR`.

```bash
MY_VAR="value"

my_function() {
  local result
  result="$(some_command)"
  echo "${result}"
}
```

### Functions

- Use `lower_snake_case` for function names.
- Keep functions focused and single-purpose.
- Place functions before the code that calls them.

### Error Handling

- Validate required inputs early and exit with a clear message:

  ```bash
  if [ -z "$REQUIRED_VAR" ]; then
      echo "Error: REQUIRED_VAR is required."
      exit 1
  fi
  ```

- Prefer `[[ ... ]]` over `[ ... ]` in bash scripts for string tests.
- Use `(( count++ ))` for arithmetic; avoid `let` or `expr`.

### Command Substitution

- Always use `$()` syntax, never backticks.
- Capture output before using it:

  ```bash
  local current
  current="$(uname -r)"
  ```

### Control Flow

- Use `case` statements for multi-branch string matching (preferred over long `if/elif` chains).
- Always include a `*` catch-all in `case` blocks with a user-facing message.

### Paths

- Reference dotfiles via `~/.dotfiles/...` (not relative paths).
- Avoid hardcoding absolute user paths; use `$HOME` when needed.

## JavaScript / Frontend Style (config-craft templates)

The `.prettierrc` template defines the JS/TS formatting standard:

| Rule | Value |
|------|-------|
| Semicolons | `false` (no semicolons) |
| Quotes | Single quotes |
| Trailing commas | None |
| Bracket spacing | `true` |
| Arrow parens | `avoid` (omit when single arg) |
| Print width | 80 |
| Tab width | 2 spaces |

CSS/SCSS linting follows `stylelint-config-standard-scss`.

## VSCode Settings Highlights

Editor is configured at `development/vscode/vscode/settings.json`:

- **Tab size:** 2 spaces for all languages
- **Font:** `'Dank Mono', 'Hack Nerd Font Mono'`
- **Theme:** Andromeda Italic
- **On-save actions:** fix-all, organize imports, remove unused imports
- **Formatters by language:**
  - Shell → `shfmt`
  - Python → `black`
  - Java → `redhat.java`
  - CSS/SCSS → `stylelint` / `prettier`
  - Markdown → `markdown-all-in-one`
  - YAML → `redhat.vscode-yaml`
  - JSON → built-in
  - HTML → built-in

## Zsh Configuration

Config lives in `core/shell/zsh/`:

- `.zshrc` — main config, loads oh-my-zsh, starship, and sources the three files below
- `_aliases/utils.sh` — shell aliases (lsd, bat, fastfetch variants, etc.)
- `_exports/exports.sh` — PATH modifications, pyenv, kubeconfig exports
- `_functions/functions.sh` — shell functions (clean, clean_kernels, config_craft, desktop_craft)

**Shell prompt:** Starship (`starship.toml` in zsh dir), displaying username, directory,
git info, Java/Node/Python versions, memory, battery, time, exit status.

## Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Shell scripts | `kebab-case.sh` | `config-craft.sh` |
| Shell functions | `snake_case` | `clean_kernels()` |
| Shell globals | `UPPER_SNAKE_CASE` | `PROJECT_TYPE_SELECTED` |
| Config files | dotfile or standard | `.zshrc`, `starship.toml` |
| Directories | `kebab-case` | `js-project-settings/` |

## Adding New Configurations

1. Place the config under the appropriate top-level domain directory.
2. Add a `README.md` in the subdirectory with copy/symlink instructions.
3. If a shell function/alias is useful, add it to:
   - `core/shell/zsh/_functions/functions.sh` (functions)
   - `core/shell/zsh/_aliases/utils.sh` (aliases)
4. Update `docs/README.md` if the addition is significant.
5. Do not add `.vscode/` directories — they are git-ignored.

## Key Tool Versions / Runtime Management

- **Java:** managed via `sdkman` (8, 11, 17, 21 configured in VSCode)
- **Python:** managed via `pyenv`
- **Node/npm/yarn:** managed via `asdf` or `nodenv`
- **Gradle:** `~/.sdkman/candidates/gradle/8.11.1`
- **Maven:** `~/.sdkman/candidates/maven/current/bin/mvn`
