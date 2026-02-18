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
