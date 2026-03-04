# opencode

Personal configuration for [opencode](https://opencode.ai) — an AI-powered terminal coding assistant.

---

## Installation (Ubuntu)

### 1. Install opencode

```bash
curl -fsSL https://opencode.ai/install | bash
```

This installs the `opencode` binary to `~/.local/bin`. Make sure that path is in your `$PATH`:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Verify the installation:

```bash
opencode --version
```

### 2. Install required dependencies

opencode relies on a few tools for the best experience:

```bash
# Node.js (required for MCP servers and plugins)
# Use nvm or asdf — do NOT install via apt (outdated version)
curl -fsSL https://fnm.vercel.app/install | bash
fnm install --lts
fnm use lts-latest

# Git (usually already installed)
sudo apt install -y git curl
```

### 3. Install the Anthropic auth plugin

The `opencode-anthropic-auth` plugin is listed in `opencode.json`. Install it globally:

```bash
npm install -g opencode-anthropic-auth
```

Then authenticate:

```bash
opencode auth login
```

---

## Configuration

### Link config directory

opencode reads its config from `~/.config/opencode/opencode.json` (global) or from
`opencode.json` at the root of a project (local, takes precedence).

**Global config (symlink the whole directory):**

```bash
ln -sf ~/.dotfiles/development/IA/opencode ~/.config/opencode
```

> Or just run `bash ~/.dotfiles/automation/install/install.sh` to set up everything at once.

**Per-project config:**

```bash
cp ~/.dotfiles/development/IA/opencode/opencode.json ~/your-project/opencode.json
```

---

## `opencode.json` reference

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "lenny": {
      "description": "...",
      "mode": "primary",
      "prompt": "...",
      "tools": {
        "edit": true,
        "write": true
      }
    }
  },
  "autoupdate": true,
  "mcp": {
    "context7": {
      "enabled": true,
      "type": "remote",
      "url": "https://mcp.context7.com/mcp"
    }
  },
  "permission": {
    "bash": {
      "*": "allow",
      "git commit *": "ask",
      "git push": "ask",
      "git push --force *": "ask",
      "git push *": "ask",
      "git rebase *": "ask",
      "git reset --hard *": "ask"
    },
    "read": {
      "*": "allow",
      "*.env": "deny",
      "*.env.*": "deny",
      "**/.env": "deny",
      "**/.env.*": "deny",
      "**/credentials.json": "deny",
      "**/secrets/**": "deny"
    }
  },
  "plugin": ["opencode-anthropic-auth"],
  "theme": "lucent-orgn"
}
```

**Key fields:**

| Field | Description |
|---|---|
| `agent` | Custom AI personas with their own system prompt and tool permissions |
| `autoupdate` | Automatically keep opencode up to date |
| `mcp` | Model Context Protocol servers — extends the AI with external tools |
| `permission.bash` | Which shell commands run automatically (`allow`) vs require confirmation (`ask`) |
| `permission.read` | Which files the AI can read. Sensitive paths (`.env`, secrets) are denied |
| `plugin` | opencode plugins installed via npm |
| `theme` | UI color theme |

---

## MCP: context7

[context7](https://context7.com) is a remote MCP server that gives the AI up-to-date
library documentation at query time instead of relying on training data.

It is enabled by default in `opencode.json` — no extra setup required.

---

## Custom Agent: Lenny

`opencode.json` defines a custom agent called **Lenny Sanders** — an intense, self-taught
genius persona that communicates in a sharp, direct style. It speaks Rioplatense Spanish
when prompted in Spanish.

The agent is set as `"mode": "primary"`, meaning it replaces the default system prompt.
It has `edit` and `write` tools enabled so it can modify files directly.

To switch agents inside a session, use the opencode UI agent selector.

---

## Directory structure

```shell
opencode/
├── opencode.json       # Main config (agents, MCP, permissions, theme)
└── README.md           # This file
```

> **Note:** Skills and agent orchestration are now managed via **Agent Teams Lite**.
> See [`../agents-teams-lite/README.md`](../agents-teams-lite/README.md) for details.

---

## Updating opencode

```bash
opencode update
```

Or, since `autoupdate` is enabled, it updates itself automatically on startup.
