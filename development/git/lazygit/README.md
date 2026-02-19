# Lazygit

Terminal UI for git. Fast, visual, keyboard-driven. If you're still typing raw git commands for everything, you're leaving speed on the table.

## Install

### Ubuntu / Debian

```shell
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz
```

### Arch Linux

```shell
sudo pacman -S lazygit
```

### Via go

```shell
go install github.com/jesseduffield/lazygit@latest
```

## Link Config

Lazygit config lives at `~/.config/lazygit/config.yml` on Linux.

```shell
ln -sf ~/.dotfiles/development/git/lazygit ~/.config/lazygit
```

> Or just run `bash ~/.dotfiles/automation/install/install.sh` to set up everything at once.

## Config Highlights

Key settings in this config worth knowing about:

| Setting | Value | Why |
|---|---|---|
| `nerdFontsVersion` | `'3'` | Nerd Fonts v3 icons in file views |
| `border` | `rounded` | Rounded window borders |
| `gui.tabWidth` | `4` | 4-space tab width in diffs |
| `gui.filterMode` | `substring` | Substring filtering on `/` search |
| `git.log.showGraph` | `always` | Always render the git graph |
| `git.log.order` | `topo-order` | Topological order for cleaner graph |
| `git.autoForwardBranches` | `onlyMainBranches` | Auto fast-forward main/master after fetch |
| `git.fetchAll` | `true` | Fetch all remotes |
| `gui.sidePanelWidth` | `0.3333` | Side panel takes 1/3 of screen |

## Usage

```shell
# Open lazygit in current repo
lazygit

# Open lazygit in a specific path
lazygit -p /path/to/repo
```

### Key Bindings (defaults)

| Key | Action |
|---|---|
| `c` | Commit changes |
| `P` | Push |
| `p` | Pull |
| `s` | Stash all changes |
| `b` | Branches panel |
| `z` | Undo |
| `Z` | Redo |
| `R` | Refresh |
| `?` | Help / option menu |
| `/` | Search/filter |
| `q` | Quit |

## References

- [Lazygit GitHub](https://github.com/jesseduffield/lazygit)
- [Full Config Reference](https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md)
- [Custom Pagers](https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md)
- [Custom Keybindings](https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Command_Keybindings.md)
