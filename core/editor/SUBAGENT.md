# Editor Configuration Sub-agent

This sub-agent specializes in editor configurations for the dotfiles repository.

## Scope

Work with editor configurations in:
- `core/editor/nvim/` — Neovim LazyVim configuration
- `development/vscode/` — VSCode settings.json and extensions

## Neovim (LazyVim)

### Structure
```
core/editor/nvim/
├── init.lua           # Entry point (if exists)
├── lazy-lock.json     # Plugin version lock file
└── lua/
    ├── config/        # LazyVim config overrides
    ├── plugins/       # Custom plugin specs
    └── ...            # Other Lua modules
```

### LazyVim Conventions
- **Plugin manager:** Lazy.nvim (auto-installed)
- **Base:** LazyVim distribution (sensible defaults + key presets)
- **Plugin format:** Lua tables in `lua/plugins/*.lua`
- **Config format:** Lua tables in `lua/config/*.lua`

### Key Principles
1. **Don't fight LazyVim defaults** — extend, don't replace
2. **One plugin per file** — easier to toggle/debug
3. **Lazy loading** — use `event`, `ft`, `cmd`, `keys` to defer loading
4. **Keymaps** — use `<leader>` prefix (Space by default)

### Common Plugin Patterns

#### Basic plugin spec
```lua
return {
  "author/plugin-name",
  event = "VeryLazy",  -- Load after startup
  opts = {
    -- Plugin options here
  },
}
```

#### Plugin with dependencies
```lua
return {
  "main-plugin/name",
  dependencies = {
    "dep1/name",
    "dep2/name",
  },
  config = function()
    require("plugin-name").setup({
      -- Config here
    })
  end,
}
```

#### Plugin with custom keymaps
```lua
return {
  "plugin/name",
  keys = {
    { "<leader>fp", "<cmd>PluginCommand<cr>", desc = "Description" },
  },
}
```

### LSP Configuration
LazyVim comes with LSP pre-configured via `mason.nvim` and `nvim-lspconfig`.

To add a language server:
```lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tsserver = {},      -- TypeScript
      pyright = {},       -- Python
      lua_ls = {},        -- Lua
      rust_analyzer = {}, -- Rust
    },
  },
}
```

### Deployment
Neovim config is deployed by symlinking or copying:

```bash
# Symlink (recommended - live updates)
ln -sf ~/.dotfiles/core/editor/nvim ~/.config/nvim

# Or copy (static snapshot)
cp -r ~/.dotfiles/core/editor/nvim ~/.config/
```

After deployment:
1. Open Neovim: `nvim`
2. LazyVim will auto-install plugins on first run
3. Check health: `:checkhealth`

## VSCode

### Structure
```
development/vscode/
└── vscode/
    └── settings.json   # VSCode user settings
```

### Key Settings
- **Font:** `'Dank Mono', 'Hack Nerd Font Mono'`
- **Theme:** Andromeda Italic
- **Tab size:** 2 spaces for all languages
- **Format on save:** Enabled with fix-all, organize imports
- **Formatters by language:**
  - Shell → `shfmt`
  - Python → `black`
  - Java → `redhat.java`
  - CSS/SCSS → `stylelint` / `prettier`
  - Markdown → `markdown-all-in-one`
  - YAML → `redhat.vscode-yaml`

### Adding a New Setting
1. Open `development/vscode/vscode/settings.json`
2. Add setting in JSON format
3. Group with related settings (editor, language-specific, etc.)
4. Validate JSON syntax

### Deployment
VSCode settings are deployed by copying:

```bash
# Linux
cp ~/.dotfiles/development/vscode/vscode/settings.json ~/.config/Code/User/

# macOS
cp ~/.dotfiles/development/vscode/vscode/settings.json ~/Library/Application\ Support/Code/User/
```

## Common Tasks

### Add a Neovim Plugin
1. Create new file: `core/editor/nvim/lua/plugins/plugin-name.lua`
2. Add plugin spec (see patterns above)
3. Restart Neovim or run `:Lazy sync`

### Configure LSP for New Language
1. Edit `core/editor/nvim/lua/plugins/lsp.lua` (or create it)
2. Add language server to `servers` table
3. Restart Neovim, run `:Mason` to install server

### Update VSCode Formatter
1. Open `development/vscode/vscode/settings.json`
2. Add/modify `"[language]": { "editor.defaultFormatter": "..." }`
3. Reload VSCode or re-copy settings

## Testing

### Neovim
- **Check health:** `:checkhealth`
- **Plugin status:** `:Lazy`
- **LSP status:** `:LspInfo`
- **Keymaps:** `:Telescope keymaps` or `<leader>sk`

### VSCode
- Open VSCode and verify settings applied
- Check formatter: right-click → Format Document
- Check extensions installed correctly

## Related Files

- `AGENTS.md` — Repository-wide guidelines
- `core/editor/nvim/README.md` — Neovim-specific deployment docs
- `development/vscode/README.md` — VSCode-specific deployment docs
