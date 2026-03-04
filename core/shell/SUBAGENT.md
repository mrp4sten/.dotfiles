# Shell Configuration Sub-agent

This sub-agent specializes in shell configurations for the dotfiles repository.

## Scope

Work with shell configurations in:
- `core/shell/zsh/` — Zsh configs (.zshrc, starship.toml, oh-my-zsh)
- `core/shell/bash/` — Bash configs (.bashrc, .git-prompt.sh, oh-my-bash)
- `core/shell/zsh/_aliases/` — Shell aliases
- `core/shell/zsh/_functions/` — Shell functions
- `core/shell/zsh/_exports/` — Environment variables and PATH modifications

## Key Conventions

### File Organization
```
core/shell/zsh/
├── .zshrc              # Main config, sources other files
├── .p10k.zsh           # Powerlevel10k prompt (LEGACY - use starship)
├── starship.toml       # Starship prompt config (CURRENT)
├── _aliases/
│   └── utils.sh        # Aliases (lsd, bat, fastfetch variants)
├── _functions/
│   └── functions.sh    # Shell functions
└── _exports/
    └── exports.sh      # PATH, env vars, pyenv, kubeconfig
```

### Shell Script Style
- **Shebang:** `#!/bin/bash` or `#!/usr/bin/env bash`
- **Author header:** `# author: mrp4sten`
- **Variables:** `UPPER_SNAKE_CASE` for globals, `lower_snake_case` for locals
- **Functions:** `lower_snake_case` naming
- **Quoting:** Always use `"${VAR}"` not `$VAR`
- **Error handling:** Validate inputs early, exit with clear messages
- **Command substitution:** Use `$()` not backticks

### Modern CLI Tools (Required)
Use modern alternatives over legacy tools:
- `bat` instead of `cat`
- `rg` (ripgrep) instead of `grep`
- `fd` instead of `find`
- `sd` instead of `sed`
- `eza` instead of `ls`
- `lsd` instead of `ls` (also acceptable)

### Starship Prompt Config
Located at `core/shell/zsh/starship.toml`:
- Shows: username, directory, git info, language versions (Java/Node/Python)
- Includes: memory, battery, time, exit status
- Format is modular (each component can be toggled)

### Key Functions (core/shell/zsh/_functions/functions.sh)
- `clean` — Remove build artifacts (node_modules, .next, dist, etc.)
- `clean_kernels` — Remove old Linux kernels (Ubuntu-specific)
- `config_craft` — Wrapper for config-craft.sh script
- `desktop_craft` — Wrapper for desktop-craft.sh script
- `skills_setup` — Wrapper for AI skills setup
- `skills_sync` — Wrapper for AI skills sync

### Key Aliases (core/shell/zsh/_aliases/utils.sh)
- `c` → `clear`
- `..`, `...`, `....` → Navigate up directories
- `ls` → `lsd`
- `cat` → `bat`
- `fetch` → `fastfetch`

### Key Exports (core/shell/zsh/_exports/exports.sh)
- PATH modifications for local bins
- `PYENV_ROOT` and pyenv init
- `KUBECONFIG` management
- Editor preferences (`VISUAL`, `EDITOR`)

## Common Tasks

### Adding a new alias
1. Open `core/shell/zsh/_aliases/utils.sh`
2. Add alias in format: `alias name='command'`
3. Group with related aliases (navigation, file ops, etc.)

### Adding a new function
1. Open `core/shell/zsh/_functions/functions.sh`
2. Add function with comment header explaining purpose
3. Use `local` for function-scoped variables
4. Add usage comment if function takes arguments

### Adding a PATH entry
1. Open `core/shell/zsh/_exports/exports.sh`
2. Add to PATH: `export PATH="$HOME/.local/bin:$PATH"`
3. Place higher-priority paths earlier in the chain

### Updating Starship config
1. Open `core/shell/zsh/starship.toml`
2. Modify relevant module (e.g., `[directory]`, `[git_branch]`)
3. Test with `starship config` to validate TOML syntax

## Deployment

Shell configs are deployed by copying to home directory:

```bash
# Zsh
cp ~/.dotfiles/core/shell/zsh/.zshrc ~/
cp ~/.dotfiles/core/shell/zsh/starship.toml ~/.config/

# Bash
cp ~/.dotfiles/core/shell/bash/.bashrc ~/
cp ~/.dotfiles/core/shell/bash/.git-prompt.sh ~/
```

After copying, reload shell:
```bash
source ~/.zshrc  # or source ~/.bashrc
```

## Testing

- **Syntax check:** `bash -n script.sh` or `zsh -n script.sh`
- **Lint:** `shellcheck script.sh` (install: `sudo pacman -S shellcheck`)
- **Manual test:** Source the file and test functions/aliases interactively

## Related Files

- `AGENTS.md` — Repository-wide guidelines
- `core/shell/zsh/README.md` — Zsh-specific deployment docs
- `core/shell/bash/README.md` — Bash-specific deployment docs
