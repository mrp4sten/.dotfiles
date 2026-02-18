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

### Copy `opencode.json`

opencode reads its config from `~/.config/opencode/opencode.json` (global) or from
`opencode.json` at the root of a project (local, takes precedence).

**Global config (applies everywhere):**

```bash
mkdir -p ~/.config/opencode
cp ~/.dotfiles/development/IA/opencode/opencode.json ~/.config/opencode/opencode.json
```

**Per-project config:**

```bash
cp ~/.dotfiles/development/IA/opencode/opencode.json ~/your-project/opencode.json
```

### Copy skills

Skills are markdown files that teach opencode domain-specific patterns. They live under a
`skill/` directory alongside `opencode.json`.

**Global skills:**

```bash
mkdir -p ~/.config/opencode/skill
cp -r ~/.dotfiles/development/IA/opencode/skill/. ~/.config/opencode/skill/
```

**Per-project skills:**

```bash
cp -r ~/.dotfiles/development/IA/opencode/skill ./skill
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

## Available Skills

Skills are loaded automatically when their trigger keywords appear in the conversation.

| Skill | Description |
|---|---|
| `ai-sdk-5` | Vercel AI SDK v5 patterns |
| `chained-pr` | Creating stacked / chained pull requests |
| `django-drf` | Django REST Framework best practices |
| `jira-epic` | Writing Jira epics |
| `jira-task` | Writing Jira tasks |
| `nextjs-15` | Next.js 15 patterns |
| `notion-adr` | Writing Architecture Decision Records in Notion |
| `notion-prd` | Writing Product Requirements Documents in Notion |
| `notion-product-brain` | Notion product brain structure |
| `notion-rfc` | Writing RFCs in Notion |
| `notion-to-jira` | Converting Notion docs to Jira issues |
| `playwright` | Playwright E2E testing patterns |
| `pr-review` | Pull request review guidelines |
| `pytest` | pytest testing patterns |
| `react-19` | React 19 patterns and best practices |
| `sdd-apply` | Spec-Driven Development — apply phase |
| `sdd-archive` | Spec-Driven Development — archive phase |
| `sdd-design` | Spec-Driven Development — design phase |
| `sdd-explore` | Spec-Driven Development — explore phase |
| `sdd-init` | Spec-Driven Development — init phase |
| `sdd-propose` | Spec-Driven Development — propose phase |
| `sdd-spec` | Spec-Driven Development — spec phase |
| `sdd-tasks` | Spec-Driven Development — tasks phase |
| `sdd-verify` | Spec-Driven Development — verify phase |
| `skill-creator` | Creating new AI agent skills |
| `tailwind-4` | Tailwind CSS v4 patterns |
| `transcript-processor` | Processing and formatting transcripts |
| `typescript` | TypeScript strict patterns and best practices |
| `vitest` | Vitest unit testing patterns |
| `zod-4` | Zod v4 schema validation patterns |
| `zustand-5` | Zustand v5 state management patterns |

---

## Directory structure

```shell
opencode/
├── opencode.json       # Main config (agents, MCP, permissions, theme)
├── README.md           # This file
└── skill/              # AI agent skills (auto-loaded by trigger keywords)
    ├── ai-sdk-5/
    ├── chained-pr/
    ├── django-drf/
    ├── jira-epic/
    ├── jira-task/
    ├── nextjs-15/
    ├── notion-adr/
    ├── notion-prd/
    ├── notion-product-brain/
    ├── notion-rfc/
    ├── notion-to-jira/
    ├── playwright/
    ├── pr-review/
    ├── pytest/
    ├── react-19/
    ├── sdd-apply/
    ├── sdd-archive/
    ├── sdd-design/
    ├── sdd-explore/
    ├── sdd-init/
    ├── sdd-propose/
    ├── sdd-spec/
    ├── sdd-tasks/
    ├── sdd-verify/
    ├── skill-creator/
    ├── tailwind-4/
    ├── transcript-processor/
    ├── typescript/
    ├── vitest/
    ├── zod-4/
    └── zustand-5/
```

---

## Updating opencode

```bash
opencode update
```

Or, since `autoupdate` is enabled, it updates itself automatically on startup.
