# Deployment & Documentation Sub-agent

This sub-agent specializes in deployment instructions and documentation for the dotfiles repository.

## Scope

Work with deployment and documentation:
- `docs/` — Repository documentation
- `*/README.md` — Component-specific deployment instructions
- `AGENTS.md` — Agent guidelines (root level)
- Deployment patterns and installation workflows

## Deployment Philosophy

**No build system.** Configs are deployed by **copying** or **symlinking** files manually.

### Copy vs Symlink

| Method | Pros | Cons | Use Case |
|--------|------|------|----------|
| **Copy** | Stable snapshot, survives repo deletion | No live updates | Production systems, stable configs |
| **Symlink** | Live updates from repo, easy rollback | Breaks if repo moved | Development machines, testing |

### Recommended Pattern by Component

| Component | Method | Reason |
|-----------|--------|--------|
| Shell (.zshrc, .bashrc) | Copy | Sourced on every shell start, stability critical |
| Neovim config | Symlink | Frequent plugin updates, easy to test |
| VSCode settings | Copy | Managed by VSCode, manual sync preferred |
| Tmux config | Copy | Stable config, rarely changes |
| Scripts (automation/) | In-place | Invoked via wrappers, no deployment needed |

## Deployment Commands by Component

### Shell (Zsh)
```bash
# Required files
cp ~/.dotfiles/core/shell/zsh/.zshrc ~/
cp ~/.dotfiles/core/shell/zsh/starship.toml ~/.config/

# Optional (if not using starship)
cp ~/.dotfiles/core/shell/zsh/.p10k.zsh ~/

# Reload
source ~/.zshrc
```

### Shell (Bash)
```bash
cp ~/.dotfiles/core/shell/bash/.bashrc ~/
cp ~/.dotfiles/core/shell/bash/.git-prompt.sh ~/

# Reload
source ~/.bashrc
```

### Neovim
```bash
# Symlink (recommended)
ln -sf ~/.dotfiles/core/editor/nvim ~/.config/nvim

# Or copy (static)
cp -r ~/.dotfiles/core/editor/nvim ~/.config/

# First run will auto-install plugins
nvim
```

### Tmux
```bash
cp ~/.dotfiles/core/multiplexer/tmux/.tmux.conf ~/

# Install TPM plugins
# Inside tmux: prefix + I (capital i)
```

### VSCode
```bash
# Linux
cp ~/.dotfiles/development/vscode/vscode/settings.json ~/.config/Code/User/

# macOS
cp ~/.dotfiles/development/vscode/vscode/settings.json ~/Library/Application\ Support/Code/User/

# Reload VSCode (Cmd/Ctrl + Shift + P → "Reload Window")
```

### Fastfetch (system info)
```bash
cp -r ~/.dotfiles/utilities/system-info/fastfetch ~/.config/
```

### Git Config
```bash
cp ~/.dotfiles/development/git/.gitconfig ~/
cp ~/.dotfiles/development/git/.gitignore_global ~/
```

## README.md Structure

Each component should have a `README.md` with:

1. **Overview** — What this component configures
2. **Dependencies** — Required packages (oh-my-zsh, TPM, etc.)
3. **Deployment** — Copy/symlink commands
4. **Post-Install** — Additional steps (reload, plugin install)
5. **Customization** — How to modify/extend

### README Template

```markdown
# [Component Name]

Brief description of what this configures.

## Dependencies

- Package 1 (install: `sudo pacman -S package1`)
- Package 2 (install: `cargo install package2`)

## Deployment

```bash
# Copy command(s) here
cp ~/.dotfiles/path/to/file ~/destination
```

## Post-Install

Steps to complete after copying files:
1. Step 1
2. Step 2

## Customization

How to modify this config:
- Edit `file.conf` to change X
- Add new settings to `section Y`

## Troubleshooting

Common issues and solutions.
```

## Documentation Maintenance

### When to Update Documentation

- [ ] Adding a new config file → Add deployment command
- [ ] Changing file location → Update all READMEs referencing it
- [ ] Adding a dependency → Update Dependencies section
- [ ] New post-install step → Update Post-Install section

### Where to Document

| What | Where |
|------|-------|
| Component-specific deploy | Component's `README.md` |
| Repository overview | Root `AGENTS.md` |
| General guidelines | Root `docs/` |
| Script usage | Script's own directory README |

## Installation Workflows

### Fresh System Setup

**Order matters** — install base dependencies first:

```bash
# 1. Clone dotfiles
git clone https://github.com/mrp4sten/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Initialize submodules (themes, fonts)
git submodule update --init --recursive

# 3. Install base dependencies
sudo pacman -S zsh tmux neovim git starship bat lsd ripgrep fd gum

# 4. Deploy shell config
cp core/shell/zsh/.zshrc ~/
cp core/shell/zsh/starship.toml ~/.config/

# 5. Change default shell
chsh -s $(which zsh)

# 6. Reload shell
exec zsh

# 7. Deploy other components as needed
cp core/multiplexer/tmux/.tmux.conf ~/
ln -sf ~/.dotfiles/core/editor/nvim ~/.config/nvim
```

### Updating Existing Setup

```bash
cd ~/.dotfiles

# Pull latest changes
git pull origin main

# Update submodules
git submodule update --remote --merge

# Re-deploy changed components
cp core/shell/zsh/.zshrc ~/
source ~/.zshrc

# Sync Neovim plugins (if symlinked)
nvim +Lazy sync
```

## Common Tasks

### Adding a New Config File

1. **Create the file** in appropriate directory
   ```bash
   # Example: new tmux plugin config
   touch ~/.dotfiles/core/multiplexer/tmux/plugins.conf
   ```

2. **Update component README**
   ```bash
   # Edit core/multiplexer/tmux/README.md
   # Add deployment command:
   # cp ~/.dotfiles/core/multiplexer/tmux/plugins.conf ~/.tmux/
   ```

3. **Update root AGENTS.md** if it's a major change
   ```bash
   # Edit AGENTS.md
   # Add to relevant section
   ```

### Documenting a New Script

1. **Create script** in `automation/`
2. **Add usage section** in script header
3. **Create README.md** in script's directory
4. **Update AGENTS.md** → Automation Scripts section
5. **Add shell function wrapper** in `core/shell/zsh/_functions/functions.sh`

### Creating a Release Checklist

Before publishing dotfiles publicly or sharing:

- [ ] Remove sensitive data (.gitconfig with email, etc.)
- [ ] Test fresh install on clean VM
- [ ] Verify all READMEs have accurate deploy commands
- [ ] Check all paths use `~/.dotfiles` not absolute paths
- [ ] Update AGENTS.md with any new conventions

## Testing Deployment

### Manual Test (Recommended)

```bash
# Create test environment
mkdir -p /tmp/dotfiles-test
cd /tmp/dotfiles-test

# Copy/symlink config
cp ~/.dotfiles/core/shell/zsh/.zshrc .zshrc

# Source and test
zsh -c "source .zshrc && type config_craft"
```

### VM Test (Before Major Changes)

1. Spin up Ubuntu VM
2. Clone dotfiles
3. Follow Fresh System Setup
4. Verify all components work

## Related Files

- `AGENTS.md` — Repository-wide guidelines
- `SUBAGENT-shell.md` — Shell config conventions
- `SUBAGENT-editor.md` — Editor config conventions
- `SUBAGENT-automation.md` — Script conventions
- All component `README.md` files
