# Python — Setup Guide (Ubuntu)

> Package manager used: [`nala`](https://github.com/volitank/nala) (wrapper over apt with better UX)
> Install nala first if you haven't: `sudo apt install nala`

---

## 1. Core — Runtime & Package Management

```bash
# Python 3 + pip
sudo nala install python3 python3-pip python3-venv pipx

# pipenv — virtualenv + pip in one, tracks Pipfile
pip install --user pipenv

# pyenv — manage multiple Python versions
curl https://pyenv.run | bash
```

> After pyenv install, add to your `.zshrc` / `.bashrc`:
>
> ```bash
> export PYENV_ROOT="$HOME/.pyenv"
> export PATH="$PYENV_ROOT/bin:$PATH"
> eval "$(pyenv init -)"
> ```

---

## 2. Build Dependencies (needed by pyenv to compile Python versions)

```bash
sudo nala install \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  liblzma-dev
```

> Without these, `pyenv install 3.x.x` will fail or produce a broken build.

---

## 3. Project & Dependency Management

```bash
# poetry — modern dep management + packaging (replaces setup.py + requirements.txt)
curl -sSL https://install.python-poetry.org | python3 -

# uv — blazing fast pip/venv replacement, written in Rust
pip install --user uv
# or via curl:
curl -LsSf https://astral.sh/uv/install.sh | sh
```

> `uv` is the new standard for speed. `uv pip install <pkg>` drops-in for pip.
> `poetry` is better for project management and publishing packages.

---

## 4. Code Quality — Linters & Formatters

```bash
# ruff — extremely fast linter + formatter (replaces flake8, isort, pyupgrade)
pip install --user ruff

# black — opinionated code formatter (still widely used)
pip install --user black

# mypy — static type checker
pip install --user mypy
```

> `ruff` alone replaces like 5 tools. Start there.

---

## 5. Testing

```bash
# pytest — the standard testing framework
pip install --user pytest

# pytest-cov — coverage reports
pip install --user pytest-cov

# httpx — async HTTP client, great for testing APIs
pip install --user httpx
```

---

## 6. REPL & Interactive Tools

```bash
# ipython — supercharged Python REPL (autocomplete, syntax highlight, magic commands)
pip install --user ipython

# ptpython — another excellent REPL with vi mode support
pip install --user ptpython

# bpython — REPL with inline docs and rewind
pip install --user bpython
```

> Pick one. `ipython` is the most common and integrates well with Jupyter if you ever need it.

---

## 7. Terminal Productivity

```bash
# rich — beautiful terminal output (tables, progress bars, markdown)
pip install --user rich

# httpie — curl but for humans, written in Python
sudo nala install httpie
# or:
pip install --user httpie

# pgcli / mycli — smarter database CLIs with autocompletion
pip install --user pgcli     # PostgreSQL
pip install --user mycli     # MySQL / MariaDB

# tldr — community man pages, faster to read
sudo nala install tldr
```

---

## 8. Debugging

```bash
# pdb++ — drop-in upgrade for Python's built-in debugger
pip install --user pdbpp

# icecream — smarter print debugging
pip install --user icecream
```

> `ic(variable)` instead of `print(variable)` — shows the expression + value. Game changer.

---

## 9. Security & Auditing

```bash
# pip-audit — scan your dependencies for known vulnerabilities
pip install --user pip-audit

# bandit — static analysis for security issues in your code
pip install --user bandit
```

---

## 10. Optional but Solid

```bash
# cookiecutter — project scaffolding from templates
pip install --user cookiecutter

# pre-commit — run checks before every git commit
pip install --user pre-commit

# watchdog — file system watcher, useful for auto-reload scripts
pip install --user watchdog
```

---

## Recommended Minimal Install (fast start)

```bash
# System
sudo nala install python3 python3-pip python3-venv httpie

# Build deps for pyenv
sudo nala install build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev \
  libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# pyenv
curl https://pyenv.run | bash

# Core Python tools
pip install --user pipenv uv ruff black mypy pytest ipython icecream rich pip-audit
```

---

## 11. VSCode Extensions for Python

Install the essentials via CLI:

```bash
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension ms-python.black-formatter
code --install-extension charliermarsh.ruff
code --install-extension njpwerner.autodocstring
code --install-extension KevinRose.vsc-python-indent
code --install-extension tamasfe.even-better-toml
```

### Core — Non-negotiable

| Extension | ID | Why |
| --- | --- | --- |
| **Python** | `ms-python.python` | Main engine. IntelliSense, debugging, env management |
| **Pylance** | `ms-python.vscode-pylance` | Real-time type checking, smart autocompletion |
| **Black Formatter** | `ms-python.black-formatter` | Opinionated formatter — consistent code on save |
| **Ruff** | `charliermarsh.ruff` | Ultra-fast linter, replaces flake8 + isort in one shot |

### Productivity

| Extension | ID | Why |
| --- | --- | --- |
| **autoDocstring** | `njpwerner.autodocstring` | Auto-generates docstrings when you type `"""` |
| **Python Indent** | `KevinRose.vsc-python-indent` | Smarter indentation — Python is sensitive about this |
| **Even Better TOML** | `tamasfe.even-better-toml` | Syntax highlight + validation for `pyproject.toml` (poetry) |

### Skip these — not worth it

- **Kite** — dead, don't install it
- **Tabnine** — redundant if you already have Copilot or Claude
- **Pylint extension** — Ruff already does this, faster and better

### settings.json — Python block

Add this to your VSCode `settings.json` for a clean Python experience:

```json
"python.analysis.typeCheckingMode": "basic",
"python.analysis.autoImportCompletions": true,
"python.analysis.inlayHints.variableTypes": true,
"python.analysis.inlayHints.functionReturnTypes": true,
"python.testing.pytestEnabled": true,
"python.testing.unittestEnabled": false,
"[python]": {
  "editor.defaultFormatter": "ms-python.black-formatter",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "always",
    "source.organizeImports": "always"
  }
}
```

### Virtual environment — set interpreter manually per project

Do NOT set a global `defaultInterpreterPath` in settings.json — it causes conflicts.
Instead, every time you start a new project:

1. Create your virtual environment:

   ```bash
   python -m venv .venv
   # or with poetry:
   poetry install
   # or with uv:
   uv venv
   ```

2. Open the Command Palette in VSCode: `Ctrl+Shift+P`

3. Run: `Python: Select Interpreter`

4. Pick the `.venv` interpreter from the list (it should auto-detect it)

> If using poetry, run `poetry config virtualenvs.in-project true` once globally.
> This makes poetry always create `.venv` inside the project folder, so VSCode finds it automatically.

---

## Notes

- Prefer `pip install --user` over `sudo pip install` — never pip as root.
- Use `pyenv` to pin Python versions per project (`.python-version` file).
- Use `poetry` or `uv` for new projects instead of bare `pip` + `requirements.txt`.
- `ruff` + `mypy` + `pytest` is a solid base for any serious project.

---

## 12. Neovim (LazyVim) — Python + Django Setup

> This section assumes you're using the LazyVim-based Neovim config at `~/.dotfiles/core/editor/nvim/`.
> All plugin specs go into `lua/plugins/` as individual files.

---

### 12.1 LazyVim Extras — Enable via `:LazyExtras`

LazyVim ships first-class extras for Python. Enable them inside Neovim:

```
:LazyExtras
```

Enable these:
- `lang.python` — pyright LSP + ruff + debugpy + venv selector, all pre-wired

That single extra gives you:
- **pyright** — LSP (hover, go-to-def, type checking)
- **ruff-lsp** — linting + formatting via ruff
- **debugpy** — Python debugger (DAP)
- **nvim-dap-python** — DAP adapter configured for Python
- **venv-selector.nvim** — auto-detects and switches `.venv` per project

> Alternatively, add it to your `lazyvim.json` under `"extras"`:
>
> ```json
> {
>   "extras": [
>     "lang.python"
>   ]
> }
> ```

---

### 12.2 Mason — Install LSP servers and tools

Inside Neovim run `:Mason` and install:

| Tool | Role |
|---|---|
| `pyright` | LSP — type checking, IntelliSense |
| `ruff` | Linter + formatter (replaces flake8, isort, black) |
| `debugpy` | Python DAP debugger |
| `mypy` | Static type checker (optional, pyright covers most of this) |
| `djlint` | Django template linter + formatter |

Or install via Mason CLI (`:MasonInstall <name>`):

```
:MasonInstall pyright ruff debugpy djlint
```

---

### 12.3 Plugin — venv-selector.nvim

Auto-detects your virtual environment per project. Critical for correct LSP behavior.

Create `lua/plugins/python.lua`:

```lua
-- lua/plugins/python.lua
return {
  -- Virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    branch = "regexp",
    opts = {
      settings = {
        search = {
          -- auto-find venvs in project root and ~/.virtualenvs
          venvs_path = vim.fn.expand("~/"),
        },
      },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
    },
  },
}
```

> After selecting a venv with `<leader>cv`, pyright auto-restarts with the correct interpreter.
> Works perfectly with `poetry`, `uv venv`, and plain `python -m venv .venv`.

---

### 12.4 Plugin — Django templates (syntax + filetype)

LazyVim's treesitter doesn't cover Django templates out of the box. Add this:

Create or add to `lua/plugins/python.lua`:

```lua
-- Add inside the return {} table in lua/plugins/python.lua
{
  -- Django template syntax highlighting
  "Glench/Vim-Jinja2-Syntax",
  ft = { "html", "jinja", "htmldjango" },
},

-- Treesitter: add htmldjango grammar
{
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, {
      "python",
      "htmldjango",
      "html",
      "toml",        -- pyproject.toml
    })
    return opts
  end,
},
```

---

### 12.5 Filetype detection — Django templates

Add to `lua/config/autocmds.lua` so Neovim correctly identifies Django templates:

```lua
-- lua/config/autocmds.lua
vim.filetype.add({
  pattern = {
    -- Treat *.html inside templates/ dirs as htmldjango
    [".*templates/.*%.html"] = "htmldjango",
    [".*templates/.*%.txt"] = "htmldjango",
  },
})
```

> Without this, Neovim treats your Django templates as plain HTML — you lose
> `{% %}` / `{{ }}` syntax highlighting and djlint formatting.

---

### 12.6 LSP — pyright tuned for Django projects

Add to `lua/plugins/python.lua` to tune pyright for Django's dynamic patterns:

```lua
{
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",       -- "off" | "basic" | "strict"
              autoImportCompletions = true,
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
      },
    },
  },
},
```

> `typeCheckingMode = "basic"` is the sweet spot for Django — strict mode will
> yell about Django's metaclass magic and you'll spend more time silencing errors
> than writing code.

---

### 12.7 Formatter — ruff as the single formatter

If you enabled `lang.python` via LazyExtras, ruff is already wired in. To make it
the explicit default formatter for Python:

```lua
-- Add to lua/plugins/python.lua
{
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.python = { "ruff_format" }
    opts.formatters_by_ft.htmldjango = { "djlint" }
    return opts
  end,
},
```

---

### 12.8 Debugging — DAP for Django

`debugpy` + `nvim-dap` let you set breakpoints and step through Django code inside Neovim.
If `lang.python` extra is enabled, DAP is mostly pre-configured. Just add a launch config.

Create `.vscode/launch.json` in your Django project root (nvim-dap reads this):

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Django",
      "type": "python",
      "request": "launch",
      "program": "${workspaceFolder}/manage.py",
      "args": ["runserver", "--noreload"],
      "django": true,
      "justMyCode": true
    }
  ]
}
```

Then inside Neovim:
- `<leader>db` — toggle breakpoint
- `<leader>dc` — start / continue debugger
- `<leader>du` — open DAP UI

---

### 12.9 Complete `lua/plugins/python.lua`

Full consolidated file — drop this into your config:

```lua
-- lua/plugins/python.lua
-- Python + Django setup for LazyVim
-- Assumes lang.python extra is enabled via :LazyExtras

return {
  -- Virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    branch = "regexp",
    opts = {
      settings = {
        search = {
          venvs_path = vim.fn.expand("~/"),
        },
      },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
    },
  },

  -- Django template syntax
  {
    "Glench/Vim-Jinja2-Syntax",
    ft = { "html", "jinja", "htmldjango" },
  },

  -- Treesitter grammars
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "python",
        "htmldjango",
        "html",
        "toml",
      })
      return opts
    end,
  },

  -- pyright tuned for Django
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
      },
    },
  },

  -- ruff as formatter, djlint for templates
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { "ruff_format" }
      opts.formatters_by_ft.htmldjango = { "djlint" }
      return opts
    end,
  },
}
```

---

### 12.10 Summary — what you get

| Feature | Tool |
|---|---|
| LSP (IntelliSense, go-to-def, hover) | `pyright` via Mason |
| Linting | `ruff` (replaces flake8, isort, pyupgrade) |
| Formatting — Python | `ruff_format` via conform.nvim |
| Formatting — Django templates | `djlint` via conform.nvim |
| Syntax highlight — Python | treesitter `python` grammar |
| Syntax highlight — Django templates | treesitter `htmldjango` + Vim-Jinja2-Syntax |
| Virtual env switching | `venv-selector.nvim` (`<leader>cv`) |
| Debugging | `debugpy` + `nvim-dap` (`<leader>db`, `<leader>dc`) |
| DAP UI | `nvim-dap-ui` (included in `lang.python` extra) |

> **Quick start:** Enable `lang.python` via `:LazyExtras`, drop `lua/plugins/python.lua`
> into your config, run `:MasonInstall pyright ruff debugpy djlint`, and add the
> filetype autocmd. That's it.
