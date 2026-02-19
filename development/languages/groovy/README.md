# Groovy / Grails — Setup Guide (Ubuntu)

> Version manager used: [`SDKMAN!`](https://sdkman.io) — the definitive manager for JVM-based tools.
> Handles Java, Groovy, Grails, Gradle, Maven, Kotlin, Scala, and more — all from one CLI.

---

## 1. Install SDKMAN!

```bash
curl -s "https://get.sdkman.io" | bash
```

> After install, SDKMAN! adds itself to your `.bashrc` / `.zshrc` automatically.
> Reload your shell or source it manually:

```bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
```

> Verify SDKMAN! is working:

```bash
sdk version
```

> Add this to your `.zshrc` / `.bashrc` if SDKMAN! doesn't auto-source:
>
> ```bash
> export SDKMAN_DIR="$HOME/.sdkman"
> [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
> ```

---

## 2. Install the JVM Stack

```bash
# Java — use Temurin (Eclipse) or Corretto (Amazon). LTS versions recommended.
sdk install java 21.0.5-tem     # Java 21 LTS — recommended for modern Grails
sdk install java 17.0.13-tem    # Java 17 LTS — if the project requires it

# Set default Java version
sdk default java 21.0.5-tem

# Groovy — the language itself
sdk install groovy

# Grails — the framework
sdk install grails

# Gradle — Grails' build tool
sdk install gradle

# Maven — if the project uses it instead of Gradle
sdk install maven
```

> Check available versions for any candidate:
>
> ```bash
> sdk list java        # all available JDKs
> sdk list groovy      # all available Groovy versions
> sdk list grails      # all available Grails versions
> ```

---

## 3. Pin Versions Per Project with `.sdkmanrc`

`.sdkmanrc` is the SDKMAN! equivalent of `.nvmrc` — it pins the exact versions for a project.
Drop it at the root of your Grails project:

```bash
# .sdkmanrc — project root
java=21.0.5-tem
groovy=4.0.24
grails=6.2.3
gradle=8.11.1
```

> Then, entering the project directory and running:
>
> ```bash
> sdk env
> ```
>
> ...switches all candidates to the pinned versions automatically.

**Auto-switch on `cd` (recommended):**

Add this to your `.zshrc` / `.bashrc`:

```bash
# Auto-switch SDKMAN! candidates when entering a directory with .sdkmanrc
export SDKMAN_AUTO_ENV=true
```

> This way you never have to manually run `sdk env` — it just works like `.nvmrc` + `nvm use`.

---

## 4. SDKMAN! Cheatsheet

```bash
# --- Install / Manage ---
sdk install <candidate>              # install latest stable
sdk install <candidate> <version>    # install specific version
sdk uninstall <candidate> <version>  # remove a version
sdk default <candidate> <version>    # set global default
sdk use <candidate> <version>        # switch version in current shell only

# --- List ---
sdk list                             # all available candidates
sdk list <candidate>                 # all versions for a candidate
sdk current                          # show all active versions
sdk current <candidate>              # show active version for one candidate

# --- Update ---
sdk update                           # refresh candidate lists
sdk upgrade                          # upgrade all installed candidates
sdk upgrade <candidate>              # upgrade specific candidate

# --- Environment ---
sdk env                              # apply .sdkmanrc in current dir
sdk env install                      # install all versions in .sdkmanrc
sdk env clear                        # reset to defaults
sdk flush                            # clear SDKMAN! cache
```

---

## 5. Grails Development Workflow

```bash
# Create a new Grails app
grails create-app myapp

# Create a new Grails app with a specific profile
grails create-app myapp --profile=rest-api
grails create-app myapp --profile=web

# Run the dev server (hot reload included)
grails run-app

# Interactive REPL — run Groovy code in your app's full context
grails shell          # game changer for debugging domain objects, services, etc.

# Generate controller + views for a domain class
grails generate-all com.example.MyDomain

# Run tests
grails test-app
grails test-app --unit          # unit tests only
grails test-app --integration   # integration tests only

# Build the WAR for deployment
grails war

# Clean build artifacts
grails clean
```

> `grails shell` is one of Grails' killer features. You can call services, query the DB,
> inspect beans — all live. It's like having a debugger and a REPL in one.

---

## 6. Groovy Console — Interactive REPL

```bash
# Launch the Groovy Swing console (GUI REPL)
groovyConsole

# Run a Groovy script directly
groovy script.groovy

# Groovy REPL in the terminal
groovysh
```

> `groovysh` is your quick scratchpad for testing Groovy expressions, closures, and GDK methods
> without spinning up the full Grails context.
> Use `grails shell` when you need the app context (domain classes, services, GORM).

---

## 7. Gradle — Useful Commands

```bash
# List available tasks
./gradlew tasks

# Run the app (Spring Boot embedded)
./gradlew bootRun

# Run tests
./gradlew test

# Build the JAR
./gradlew build

# Build without running tests
./gradlew build -x test

# Force dependency refresh (useful when deps are cached stale)
./gradlew build --refresh-dependencies

# Show dependency tree
./gradlew dependencies

# Clean build directory
./gradlew clean

# Gradle daemon — speeds up subsequent builds
./gradlew --daemon      # enable daemon for this build
./gradlew --stop        # stop all running daemons
```

> Always use the **Gradle wrapper** (`./gradlew`) instead of the global `gradle` command.
> This ensures everyone on the team uses the exact same Gradle version defined in the project.

---

## 8. Terminal Utilities — The Pretty Stack

> Your terminal already runs Zsh + Starship + Dank Mono/Hack Nerd Font.
> These tools are built for exactly that setup.

### `sdk` autocompletion — always on

SDKMAN! ships with zsh/bash completion out of the box. If it's not working, verify it's sourced:

```bash
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
```

---

### `jenv` — fine-grained Java version control per directory (optional, layered over SDKMAN!)

```bash
# Install
git clone https://github.com/jenv/jenv.git ~/.jenv

# Add to .zshrc
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Add a JDK installed by SDKMAN!
jenv add ~/.sdkman/candidates/java/21.0.5-tem/

# Set version for a project directory
jenv local 21.0
```

> Only useful if you need per-directory Java switching that's more granular than SDKMAN! `.sdkmanrc`.
> For most Grails projects, `.sdkmanrc` alone is enough.

---

### `httpie` — HTTP client for testing Grails REST APIs

```bash
# Install
sudo nala install httpie

# Usage — much cleaner than curl
http GET localhost:8080/api/users
http POST localhost:8080/api/users name="Lenny" email="lenny@example.com"
http PUT localhost:8080/api/users/1 name="Updated"
http DELETE localhost:8080/api/users/1

# With auth headers
http GET localhost:8080/api/secure Authorization:"Bearer <token>"

# Pretty JSON output is the default — no flags needed
```

---

### `jq` — JSON processor for API responses

```bash
# Install
sudo nala install jq

# Pretty-print JSON
curl -s localhost:8080/api/users | jq .

# Filter specific fields
curl -s localhost:8080/api/users | jq '.[].name'

# Count results
curl -s localhost:8080/api/users | jq 'length'
```

---

### `gradle-profiler` — find where your builds are slow

```bash
# Install via SDKMAN!
sdk install gradleprofiler

# Profile a build
gradle-profiler --benchmark --project-dir . --scenario-file performance.scenarios
```

> Most Grails/Gradle slow builds come from configuration phase, not compilation.
> This tool tells you exactly where the time goes.

---

### Zsh Aliases — add to your `_aliases/utils.sh`

```bash
# SDKMAN!
alias sdkl='sdk list'
alias sdku='sdk use'
alias sdki='sdk install'
alias sdkc='sdk current'
alias sdkenv='sdk env'

# Grails
alias gr='grails run-app'
alias gs='grails shell'
alias gt='grails test-app'
alias gw='./gradlew'
alias gwb='./gradlew build'
alias gwt='./gradlew test'
alias gwc='./gradlew clean'
alias gwbr='./gradlew bootRun'
alias gwbd='./gradlew build -x test'

# Quick Groovy REPL
alias gsh='groovysh'
```

---

## 9. Recommended Minimal Install (fast start)

```bash
# 1. Install SDKMAN!
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# 2. Install the core JVM stack
sdk install java 21.0.5-tem
sdk install groovy
sdk install grails
sdk install gradle

# 3. Set Java 21 as default
sdk default java 21.0.5-tem

# 4. Enable auto-env switching in .zshrc
echo 'export SDKMAN_AUTO_ENV=true' >> ~/.zshrc

# 5. Create .sdkmanrc in your project (adjust versions to match your project)
cat > .sdkmanrc <<EOF
java=21.0.5-tem
groovy=4.0.24
grails=6.2.3
gradle=8.11.1
EOF

# 6. Install terminal utilities
sudo nala install httpie jq
```

---

## 10. VSCode Extensions for Groovy / Grails

Install via CLI:

```bash
code --install-extension marlon407.code-groovy
code --install-extension vscjava.vscode-java-pack
code --install-extension vscjava.vscode-gradle
code --install-extension redhat.vscode-xml
code --install-extension redhat.vscode-yaml
```

### Core — Non-negotiable

| Extension | ID | Why |
| --- | --- | --- |
| **Code Groovy** | `marlon407.code-groovy` | Groovy syntax highlighting, snippets, basic completion |
| **Extension Pack for Java** | `vscjava.vscode-java-pack` | Full Java/JVM support: IntelliSense, debugging, Maven/Gradle |
| **Gradle for Java** | `vscjava.vscode-gradle` | Gradle task runner, dependency viewer, build management |

### Productivity

| Extension | ID | Why |
| --- | --- | --- |
| **XML** | `redhat.vscode-xml` | Groovy/Grails projects often have XML configs — proper validation |
| **YAML** | `redhat.vscode-yaml` | `application.yml` support with schema validation |
| **REST Client** | `humao.rest-client` | Test your Grails REST endpoints directly from `.http` files in VSCode |

### settings.json — Groovy / Java block

Add this to your VSCode `settings.json`:

```json
"java.configuration.runtimes": [
  {
    "name": "JavaSE-21",
    "path": "${env:HOME}/.sdkman/candidates/java/current",
    "default": true
  }
],
"java.jdt.ls.java.home": "${env:HOME}/.sdkman/candidates/java/current",
"gradle.java.home": "${env:HOME}/.sdkman/candidates/java/current",
"[groovy]": {
  "editor.tabSize": 4,
  "editor.insertSpaces": true,
  "editor.formatOnSave": false
},
"[java]": {
  "editor.tabSize": 4,
  "editor.insertSpaces": true,
  "editor.formatOnSave": true
}
```

> `${env:HOME}/.sdkman/candidates/java/current` always points to the active SDKMAN! JDK.
> You don't need to hardcode version paths — SDKMAN! manages the `current` symlink for you.

---

## 11. Neovim Setup for Groovy / Grails

> Based on LazyVim. Add these to your `lua/plugins/` directory.

### Step 1 — Add Groovy to Treesitter

In `lua/plugins/lsp.lua`, add `"groovy"` to `ensure_installed`:

```lua
-- lua/plugins/lsp.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- your existing languages...
        "bash", "html", "javascript", "json", "lua",
        "markdown", "markdown_inline", "python", "query",
        "regex", "vim", "yaml",
        -- JVM stack
        "groovy",
        "java",
        "xml",       -- for Grails config files
        "toml",      -- for build files
      },
    },
  },
}
```

### Step 2 — LSP for Groovy/Java

Create `lua/plugins/jvm.lua`:

```lua
-- lua/plugins/jvm.lua
return {
  -- Mason: installs LSP servers, linters, formatters
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "groovy-language-server",   -- Groovy LSP
        "google-java-format",       -- Java/Groovy formatter
        "checkstyle",               -- Java linter (optional)
      },
    },
  },

  -- LSP config: wire up the Groovy language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        groovyls = {
          -- groovy-language-server requires a JDK — it picks up SDKMAN!'s current
          cmd = { "groovy-language-server" },
          filetypes = { "groovy" },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(
              "build.gradle",
              "build.gradle.kts",
              "settings.gradle",
              "grails-app",
              ".git"
            )(fname)
          end,
          settings = {
            groovy = {
              classpath = {},
            },
          },
        },
      },
    },
  },

  -- None-ls: linting and formatting pipelines
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.google_java_format.with({
          filetypes = { "java", "groovy" },
        }),
      })
    end,
  },
}
```

### Step 3 — Install the servers

Open Neovim and run:

```
:MasonInstall groovy-language-server google-java-format
```

Or let Mason auto-install via `ensure_installed` on next launch.

### Useful Neovim Keymaps for Grails Dev

LazyVim ships with LSP keymaps out of the box. The most useful ones for a Grails project:

| Keymap | Action |
| --- | --- |
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |
| `<leader>ca` | Code action (fix, refactor) |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format file |
| `<leader>xx` | Trouble: show diagnostics |
| `<leader>gg` | Open lazygit (already in your setup) |

### Run Grails from Neovim terminal

```vim
" Open a terminal split and run the Grails dev server
:sp | term grails run-app

" Or use the LazyVim terminal toggle
<leader>`    " toggleterm floating terminal
```

> Tip: use a tmux split instead — run `grails run-app` in one pane, edit in another.
> It's cleaner than embedding the server in Neovim's terminal.

---

## Notes

- Use **SDKMAN!** for all JVM candidates — never `sudo apt install groovy` or similar.
  The Ubuntu repos ship ancient versions that will break modern Grails apps.
- Pin versions with **`.sdkmanrc`** at the project root — treat it like a `.nvmrc`.
- Enable `SDKMAN_AUTO_ENV=true` in your shell — eliminates the manual `sdk env` step.
- Always use **`./gradlew`** (the wrapper) over the global `gradle` command.
- `grails shell` is your best debugging tool — use it before reaching for a debugger.
- `groovysh` is for quick Groovy experiments. `grails shell` is for app-context debugging.
- The Groovy LSP (`groovy-language-server`) works best when the project is fully built —
  run `./gradlew classes` first if you see missing type errors in Neovim.
