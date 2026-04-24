## Available Skills

Use these skills for detailed patterns on-demand:

| Skill | Description | URL |
|-------|-------------|-----|
| `ai-sdk-5` | Vercel AI SDK 5 patterns. Trigger: When building AI chat features - breaking ... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/ai-sdk-5/SKILL.md) |
| `chained-pr` | Creates GitHub PRs following the Chained PRs workflow pattern. Trigger: When ... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/chained-pr/SKILL.md) |
| `clean-code` | Clean Code principles for readable, maintainable software. Trigger: When writ... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/clean-code/SKILL.md) |
| `conventional-commits` | Conventional Commits specification and Keep a Changelog best practices. Trigg... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/conventional-commits/SKILL.md) |
| `django-drf` | Django REST Framework patterns. Trigger: When building REST APIs with Django ... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/django-drf/SKILL.md) |
| `grails-5` | Grails 5 framework patterns and best practices. Trigger: When working with Gr... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/grails-5/SKILL.md) |
| `grails-tdd` | Test-Driven Development workflow for Grails applications with Spock. Trigger:... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/grails-tdd/SKILL.md) |
| `nextjs-15` | Next.js 15 App Router patterns. Trigger: When working with Next.js - routing,... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/nextjs-15/SKILL.md) |
| `playwright` | Playwright E2E testing patterns. Trigger: When writing E2E tests - Page Objec... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/playwright/SKILL.md) |
| `pr-review` | Reviews GitHub PRs and leaves human, direct comments. Trigger: When user asks... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/pr-review/SKILL.md) |
| `pytest` | Pytest testing patterns for Python. Trigger: When writing Python tests - fixt... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/pytest/SKILL.md) |
| `react-19` | React 19 patterns with React Compiler. Trigger: When writing React components... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/react-19/SKILL.md) |
| `sdd-apply` | Implement tasks from the change, writing actual code following the specs and ... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/sdd-apply/SKILL.md) |
| `sdd-archive` | Sync delta specs to main specs and archive a completed change. Trigger: When ... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/sdd-archive/SKILL.md) |
| `sdd-design` | Create technical design document with architecture decisions and approach. Tr... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/sdd-design/SKILL.md) |
| `sdd-explore` | Explore and investigate ideas before committing to a change. Trigger: When th... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/sdd-explore/SKILL.md) |
| `sdd-init` | Bootstrap the openspec/ directory structure for Spec-Driven Development in an... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/sdd-init/SKILL.md) |
| `sdd-propose` | Create a change proposal with intent, scope, and approach. Trigger: When the ... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/sdd-propose/SKILL.md) |
| `sdd-spec` | Write specifications with requirements and scenarios (delta specs for changes... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/sdd-spec/SKILL.md) |
| `sdd-tasks` | Break down a change into an implementation task checklist. Trigger: When the ... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/sdd-tasks/SKILL.md) |
| `sdd-verify` | Validate that implementation matches specs, design, and tasks. Trigger: When ... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/sdd-verify/SKILL.md) |
| `security-first` | Security-first development practices (Shift-Left Security). Trigger: When han... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/security-first/SKILL.md) |
| `skill-creator` | Creates new AI agent skills following the Agent Skills spec. Trigger: When us... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/skill-creator/SKILL.md) |
| `skill-sync` | Syncs skill metadata to AGENTS.md Auto-invoke sections. Trigger: When updatin... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/skill-sync/SKILL.md) |
| `solid` | SOLID principles for object-oriented design. Trigger: When designing classes,... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/solid/SKILL.md) |
| `spock` | Spock testing framework for Groovy and Java applications. Trigger: When writi... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/spock/SKILL.md) |
| `tailwind-4` | Tailwind CSS 4 patterns and best practices. Trigger: When styling with Tailwi... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/tailwind-4/SKILL.md) |
| `tdd` | Test-Driven Development workflow for any project (UI, Backend, API). Trigger:... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/tdd/SKILL.md) |
| `transcript-processor` | Processes meeting transcripts and generates structured output based on type. ... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/transcript-processor/SKILL.md) |
| `typescript` | TypeScript strict patterns and best practices. Trigger: When writing TypeScri... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/typescript/SKILL.md) |
| `vitest` | Vitest testing patterns with React Testing Library. Trigger: When writing uni... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/vitest/SKILL.md) |
| `zod-4` | Zod 4 schema validation patterns. Trigger: When using Zod for validation - br... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/zod-4/SKILL.md) |
| `zustand-5` | Zustand 5 state management patterns. Trigger: When managing React state with ... | [SKILL.md](~/.dotfiles/development/IA/opencode/skill/zustand-5/SKILL.md) |

### Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action | Skill |
|--------|-------|
| After creating/modifying a skill | `skill-sync` |
| Building AI chat features with Vercel AI SDK | `ai-sdk-5` |
| Building Django REST Framework APIs | `django-drf` |
| Code review | `clean-code` |
| Creating Grails controllers or services | `grails-5` |
| Creating git commits | `conventional-commits` |
| Creating new skills | `skill-creator` |
| Creating test specifications | `spock` |
| Creating validation schemas with Zod | `zod-4` |
| Designing APIs or endpoints | `security-first` |
| Designing GORM domain classes | `grails-5` |
| Designing classes or interfaces | `solid` |
| Fixing bug | `tdd` |
| Fixing bugs in Grails applications | `grails-tdd` |
| Handling user input or authentication | `security-first` |
| Implementing feature | `tdd` |
| Implementing features in Grails | `grails-tdd` |
| Managing state with Zustand | `zustand-5` |
| Mocking dependencies with Spock | `spock` |
| Modifying component | `tdd` |
| Preparing releases | `conventional-commits` |
| Refactoring Grails code | `grails-tdd` |
| Refactoring code | `tdd` |
| Refactoring existing code | `clean-code` |
| Refactoring object-oriented code | `solid` |
| Regenerate AGENTS.md Auto-invoke tables (sync.sh) | `skill-sync` |
| Reviewing GitHub Pull Requests | `pr-review` |
| Reviewing class architecture | `solid` |
| Storing sensitive data | `security-first` |
| Styling with Tailwind CSS | `tailwind-4` |
| Troubleshoot why a skill is missing from AGENTS.md auto-invoke | `skill-sync` |
| Updating CHANGELOG.md | `conventional-commits` |
| Working on task | `tdd` |
| Working with Grails 5 applications | `grails-5` |
| Working with Next.js App Router | `nextjs-15` |
| Working with external dependencies | `security-first` |
| Writing E2E tests with Playwright | `playwright` |
| Writing Python tests with pytest | `pytest` |
| Writing React components | `react-19` |
| Writing Spock tests | `spock` |
| Writing TypeScript code | `typescript` |
| Writing new code | `clean-code` |
| Writing unit tests with Vitest | `vitest` |

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
|   └── IA/{opencode}/ # Config for LLMs
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
