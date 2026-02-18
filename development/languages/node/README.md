# Node.js — Setup Guide (Ubuntu)

> Version manager used: [`nvm`](https://github.com/nvm-sh/nvm) — Node Version Manager
> **Do NOT install Node from apt/nala** — the Debian/Ubuntu repos ship outdated versions. nvm gives you full control.

---

## 1. Core — Runtime via nvm

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
```

> After install, nvm adds itself to your `.bashrc` / `.zshrc` automatically.
> Reload your shell or source it manually:

```bash
source ~/.zshrc
# or
source ~/.bashrc
```

> Verify nvm is working:

```bash
nvm --version
```

```bash
# Install the latest LTS version of Node (recommended for most projects)
nvm install --lts

# Or install a specific version
nvm install 22
nvm install 20

# Set a default version globally
nvm alias default 22

# Check active version
node -v
npm -v
```

> Add this to your `.zshrc` / `.bashrc` if nvm doesn't auto-source:
>
> ```bash
> export NVM_DIR="$HOME/.nvm"
> [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
> [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
> ```

---

## 2. Package Managers

```bash
# corepack — manages yarn and pnpm versions per project (ships with Node 16+)
corepack enable

# pnpm — fast, disk-efficient npm alternative (recommended)
corepack prepare pnpm@latest --activate
# or via npm:
npm install -g pnpm

# yarn — alternative to npm, still widely used
corepack prepare yarn@stable --activate
# or via npm:
npm install -g yarn
```

> Use `pnpm` for new projects. It's faster and avoids node_modules duplication via a global store.

---

## 3. Global Developer Tools

```bash
# npx — already ships with npm, no install needed
# But if you want it always available:
npm install -g npx

# tsx — run TypeScript directly without compiling (replaces ts-node for modern TS)
npm install -g tsx

# ts-node — TypeScript execution for Node (classic, still useful)
npm install -g ts-node

# nodemon — auto-restart on file changes during development
npm install -g nodemon

# pm2 — process manager for production Node apps (keep alive, logs, clustering)
npm install -g pm2
```

---

## 4. TypeScript

```bash
# TypeScript compiler
npm install -g typescript

# Check version
tsc -v
```

> For projects: install `typescript` as a devDependency, not globally.
> Global install is just for quick CLI use (`tsc --init`, one-off checks).

---

## 5. Code Quality — Linters & Formatters

```bash
# ESLint — the standard JS/TS linter
npm install -g eslint

# Prettier — opinionated code formatter
npm install -g prettier

# Biome — all-in-one linter + formatter, written in Rust (replaces ESLint + Prettier)
npm install -g @biomejs/biome
```

> **Recommendation:** use `biome` for new projects. Fast as hell, zero config to start, replaces both ESLint and Prettier.
> For existing projects already using ESLint — stick with it, migration isn't always worth it.

---

## 6. Project Scaffolding

```bash
# Vite — modern build tool, instant dev server (replaces CRA)
# Run without installing globally:
pnpm create vite@latest

# Create Next.js app
pnpm create next-app@latest

# Create React app (Vite-based, not CRA)
pnpm create vite@latest my-app -- --template react-ts
```

> Never use `create-react-app` — it's dead. Vite is the move.

---

## 7. Testing

```bash
# Vitest — blazing fast test runner, compatible with Jest API (Vite ecosystem)
npm install -g vitest

# Jest — classic test runner, still dominant in larger codebases
npm install -g jest

# Playwright — E2E browser testing
npm install -g @playwright/test
# Install browsers after:
npx playwright install
```

> For new projects: `vitest` if using Vite, `jest` if working with an existing codebase.

---

## 8. Terminal Productivity

```bash
# http-server — serve a folder over HTTP instantly
npm install -g http-server

# json-server — fake REST API from a JSON file (great for frontend dev)
npm install -g json-server

# serve — static file server (Vercel's tool)
npm install -g serve

# tldr — community man pages
sudo nala install tldr

# HTTPie — curl but readable (also works for API testing)
sudo nala install httpie
```

---

## 9. Debugging & Inspection

```bash
# clinic — performance profiling for Node.js apps
npm install -g clinic

# why-is-node-running — tells you why Node won't exit
npm install -g why-is-node-running

# ndb — improved Node.js debugging (uses Chrome DevTools)
npm install -g ndb
```

---

## 10. Security & Auditing

```bash
# npm audit — built-in, no install needed
npm audit
npm audit fix

# snyk — advanced vulnerability scanning
npm install -g snyk
snyk auth   # login with your Snyk account

# lockfile-lint — validate your package-lock.json / yarn.lock
npm install -g lockfile-lint
```

---

## 11. nvm — Useful Commands Cheatsheet

```bash
nvm ls                    # List installed versions
nvm ls-remote             # List all available versions
nvm install <version>     # Install a specific version
nvm use <version>         # Switch version in current shell
nvm alias default <ver>   # Set global default
nvm current               # Show active version
nvm uninstall <version>   # Remove a version
```

> Pin the Node version per project using a `.nvmrc` file:
>
> ```bash
> echo "22" > .nvmrc
> # Then in the project directory:
> nvm use
> ```
>
> nvm will read `.nvmrc` automatically if configured in your shell.

---

## Recommended Minimal Install (fast start)

```bash
# 1. Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# 2. Reload shell
source ~/.zshrc

# 3. Install Node LTS + set as default
nvm install --lts
nvm alias default node

# 4. Enable corepack + install pnpm
corepack enable
corepack prepare pnpm@latest --activate

# 5. Global dev tools
npm install -g tsx nodemon typescript @biomejs/biome

# 6. Optional but solid
npm install -g http-server serve json-server pm2
```

---

## 12. VSCode Extensions for Node / JS / TS

Install the essentials via CLI:

```bash
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension biomejs.biome
code --install-extension christian-kohler.npm-intellisense
code --install-extension eg2.vscode-npm-script
code --install-extension PKief.material-icon-theme
code --install-extension Orta.vscode-jest
```

### Core — Non-negotiable

| Extension | ID | Why |
| --- | --- | --- |
| **ESLint** | `dbaeumer.vscode-eslint` | Real-time linting in the editor |
| **Prettier** | `esbenp.prettier-vscode` | Auto-format on save |
| **Biome** | `biomejs.biome` | All-in-one linter + formatter (Rust-based, fast) |
| **npm Intellisense** | `christian-kohler.npm-intellisense` | Autocomplete for npm imports |

### Productivity

| Extension | ID | Why |
| --- | --- | --- |
| **npm Scripts** | `eg2.vscode-npm-script` | Run npm scripts directly from sidebar |
| **Jest** | `Orta.vscode-jest` | Run/debug tests inline |
| **Thunder Client** | `rangav.vscode-thunder-client` | REST client inside VSCode |

### Skip these — not worth it

- **TSLint** — deprecated, ESLint does everything now
- **Vetur** — Vue 2 only, use `Volar` instead if you're on Vue 3
- **Path Intellisense** — npm Intellisense covers most of this

### settings.json — Node / TypeScript block

Add this to your VSCode `settings.json`:

```json
"typescript.preferences.importModuleSpecifier": "relative",
"typescript.suggest.autoImports": true,
"typescript.inlayHints.parameterNames.enabled": "all",
"typescript.inlayHints.variableTypes.enabled": true,
"typescript.inlayHints.functionLikeReturnTypes.enabled": true,
"[javascript]": {
  "editor.defaultFormatter": "biomejs.biome",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.biome": "always",
    "source.organizeImports.biome": "always"
  }
},
"[typescript]": {
  "editor.defaultFormatter": "biomejs.biome",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.biome": "always",
    "source.organizeImports.biome": "always"
  }
},
"[typescriptreact]": {
  "editor.defaultFormatter": "biomejs.biome",
  "editor.formatOnSave": true
}
```

> If you prefer Prettier over Biome, swap `biomejs.biome` for `esbenp.prettier-vscode` in the formatter fields.

---

## Notes

- **Nunca instales Node vía apt/nala** para desarrollo — la versión está desactualizada.
- Usa `.nvmrc` en cada proyecto para fijar la versión de Node y evitar sorpresas en CI.
- Prefiere `pnpm` sobre `npm` para proyectos nuevos — más rápido, menor uso de disco.
- Para monorepos: `pnpm workspaces` o `turborepo` son la combinación correcta.
- `biome` en 2025 es lo que debería reemplazar tu stack de ESLint + Prettier en proyectos nuevos.
