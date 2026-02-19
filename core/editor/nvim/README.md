# Neovim Configuration

LazyVim-based Neovim setup. Minimal by design — the base is LazyVim, customizations are layered on top.

## Stack

| Layer | Tool |
|---|---|
| Plugin manager | [lazy.nvim](https://github.com/folke/lazy.nvim) |
| Distribution | [LazyVim](https://www.lazyvim.org) |
| Colorscheme | [gruvbox](https://github.com/ellisonleao/gruvbox.nvim) |
| Dashboard | [snacks.nvim](https://github.com/folke/snacks.nvim) |
| LSP / Treesitter | nvim-lspconfig + nvim-treesitter |
| Formatter | [stylua](https://github.com/JohnnyMorganz/StyLua) (Lua only) |

## Dependencies

- **Neovim** >= 0.9 (0.10+ recommended)
- **git** — lazy.nvim uses it to fetch plugins
- **Node.js** — required by several LSP servers
- **A Nerd Font** — for icons (Hack NF recommended)
- **stylua** — Lua formatter used by the config

### Install Neovim (Ubuntu)

```shell
# Option 1: via apt (may be outdated)
sudo apt install neovim

# Option 2: latest stable via snap
sudo snap install nvim --classic

# Option 3: download AppImage from releases (always latest)
# https://github.com/neovim/neovim/releases
```

### Install stylua

```shell
# via cargo
cargo install stylua

# or via Mason (inside Neovim, after setup)
# :MasonInstall stylua
```

## Installation

### 1. Link the config

```shell
ln -sf ~/.dotfiles/core/editor/nvim ~/.config/nvim
```

Or just run the global installer from the repo root:

```shell
bash ~/.dotfiles/automation/install/install.sh
```

### 2. Open Neovim — plugins install automatically

```shell
nvim
```

lazy.nvim bootstraps itself on first launch and installs all plugins. Wait for it to finish, then restart.

### 3. Install LSP servers, formatters and linters

Inside Neovim, use Mason:

```
:Mason
```

Recommended installs for this setup:

| Tool | Language |
|---|---|
| `lua-language-server` | Lua |
| `bash-language-server` | Bash |
| `pyright` | Python |
| `typescript-language-server` | JS / TS |
| `stylua` | Lua formatter |
| `shfmt` | Shell formatter |

## Structure

```
nvim/
├── init.lua              # Entry point — bootstraps lazy.nvim
├── lazyvim.json          # LazyVim extras and version tracking
├── stylua.toml           # Lua formatter config (2-space indent, 120 col)
├── lazy-lock.json        # Plugin lockfile (auto-generated)
└── lua/
    ├── config/
    │   ├── lazy.lua      # lazy.nvim bootstrap and setup
    │   ├── options.lua   # Custom Neovim options
    │   ├── keymaps.lua   # Custom keymaps
    │   └── autocmds.lua  # Custom autocommands
    └── plugins/
        ├── colorscheme.lua  # Gruvbox + LazyVim theme config
        ├── dashboard.lua    # Custom ASCII dashboard (snacks.nvim)
        ├── lsp.lua          # Treesitter language installs
        └── example.lua      # LazyVim plugin spec example
```

## Customization

All customizations live in `lua/plugins/`. Each file returns a table of plugin specs following the [lazy.nvim spec format](https://lazy.folke.io/spec).

**Adding a plugin:**

```lua
-- lua/plugins/my-plugin.lua
return {
  "author/plugin-name",
  opts = {
    -- your options
  },
}
```

**Overriding a LazyVim plugin:**

```lua
return {
  "existing/plugin",
  opts = function(_, opts)
    opts.some_key = "new_value"
    return opts
  end,
}
```

## Useful Commands

| Command | Action |
|---|---|
| `:Lazy` | Open plugin manager UI |
| `:Lazy sync` | Update all plugins |
| `:Lazy clean` | Remove unused plugins |
| `:Mason` | Open LSP/formatter installer |
| `:LazyExtras` | Browse LazyVim extras |
| `:checkhealth` | Diagnose config issues |

## Key Bindings (LazyVim defaults)

| Key | Action |
|---|---|
| `Space` | Leader key |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep |
| `<leader>e` | File explorer (neo-tree) |
| `<leader>gg` | Open lazygit |
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>cf` | Format file |

## References

- [LazyVim docs](https://www.lazyvim.org)
- [lazy.nvim docs](https://lazy.folke.io)
- [Neovim docs](https://neovim.io/doc/user/)
