# IA / AI Tools

AI-powered development tools and agent orchestration frameworks.

---

## Overview

This directory contains configuration and tools for AI-assisted development:

```
IA/
├── agents-teams-lite/    # Agent orchestration framework (git submodule)
├── opencode/             # OpenCode AI assistant config
├── claude-code/          # Claude Code (official Anthropic CLI) config
└── README.md             # This file
```

---

## Tools

### Engram

[Engram](https://github.com/Gentleman-Programming/engram) is a persistent memory system for AI agents that survives across sessions and context compactions.

**Installation:**

```bash
# 1. Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install Engram
brew install gentleman-programming/tap/engram
```

**Features:**

- Persistent memory across AI sessions
- Survives context compaction
- Searchable observations with FTS5
- Session summaries and learnings
- Project-scoped and personal observations

**Usage:**

Engram is designed to be used by AI agents (like opencode) automatically. It provides:
- `mem_save` — Save architecture decisions, bug fixes, patterns
- `mem_search` — Search past observations
- `mem_context` — Get recent session context
- `mem_session_summary` — Create end-of-session summaries

See [Engram documentation](https://github.com/Gentleman-Programming/engram) for full usage.

---

### Agent Teams Lite

[Agent Teams Lite](https://github.com/Gentleman-Programming/agent-teams-lite) is an agent-team orchestration framework with specialized sub-agents for structured feature development.

**Installation:**

Already installed as a git submodule in this repository.

```bash
# Update submodule to latest version
cd ~/.dotfiles
git submodule update --remote development/IA/agents-teams-lite
```

**Features:**

- **Orchestrator** — Lightweight coordinator that delegates work
- **Specialized sub-agents** — Explorer, Proposer, Spec Writer, Designer, Task Planner, Implementer, Verifier, Archiver
- **Structured workflow** — Proposal → Spec → Design → Tasks → Implementation → Verification → Archive
- **Persistent artifacts** — All specs and decisions saved to `openspec/` directory
- **Fresh context per task** — Each sub-agent starts clean, no context overload

**Workflow:**

```
YOU: "Add CSV export to the app"

ORCHESTRATOR:
  → EXPLORER      → Analyzes codebase
  → PROPOSER      → Creates proposal artifact
  → SPEC WRITER   → Creates spec artifact
  → DESIGNER      → Creates design artifact
  → TASK PLANNER  → Creates task breakdown
  → IMPLEMENTER   → Writes code
  → VERIFIER      → Validates implementation
  → ARCHIVER      → Archives change
```

**Usage:**

Agent Teams Lite works with any AI coding assistant that supports custom instructions (opencode, Claude, Cursor, Windsurf, etc.).

See [`agents-teams-lite/README.md`](agents-teams-lite/README.md) for full documentation and setup instructions.

---

### OpenCode

[OpenCode](https://opencode.ai) is a third-party AI-powered terminal coding assistant.

See [`opencode/README.md`](opencode/README.md) for installation and configuration.

---

### Claude Code

[Claude Code](https://claude.ai/code) is the **official** Anthropic CLI for Claude AI. It provides native integration with Claude's API, MCP support, skills, custom agents, and persistent memory.

**Key Features:**
- Official Anthropic tool (not third-party)
- Native Claude API integration
- MCP (Model Context Protocol) support
- Custom agent personalities (Lenny, Gentleman)
- 33+ shared skills from OpenCode
- Persistent memory via Engram
- Project-aware context

**Installation:**

```bash
# Run the automated installer
bash ~/.dotfiles/development/IA/claude-code/install.sh
```

Or manually:

```bash
# 1. Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# 2. Authenticate
claude auth login

# 3. Link skills
ln -sf ~/.dotfiles/development/IA/claude-code/skills ~/.claude/skills

# 4. Link global config
ln -sf ~/.dotfiles/development/IA/claude-code/CLAUDE.md ~/CLAUDE.md
```

**Usage:**

```bash
# Start with Lenny agent (sarcastic CTO)
claude --agent lenny
# or
lenny

# Start with Gentleman agent (warm mentor)
claude --agent gentleman
# or
gentleman

# Load a skill
claude
/skill tdd

# Continue last session
claude --continue
```

See [`claude-code/README.md`](claude-code/README.md) for full documentation.

---

## Quick Start

1. **Install Engram:**
   ```bash
   brew install gentleman-programming/tap/engram
   ```

2. **Update agent-teams-lite submodule:**
   ```bash
   cd ~/.dotfiles
   git submodule update --init --recursive
   ```

3. **Install Claude Code (recommended):**
   ```bash
   bash ~/.dotfiles/development/IA/claude-code/install.sh
   ```

   Or install OpenCode (alternative):
   ```bash
   curl -fsSL https://opencode.ai/install | bash
   ln -sf ~/.dotfiles/development/IA/opencode ~/.config/opencode
   ```

---

## Integration

All tools work together:

- **Claude Code** (or **OpenCode**) provides the AI coding assistant interface
- **Agent Teams Lite** provides the structured workflow and orchestration
- **Engram** provides persistent memory across sessions

Together they form a powerful, structured AI development environment that maintains context, follows best practices, and produces consistent, well-documented code.

**Recommended Stack:**
- **Primary:** Claude Code + Agent Teams Lite + Engram
- **Alternative:** OpenCode + Agent Teams Lite + Engram

Both Claude Code and OpenCode share the same skills, agents, and Engram memory. Claude Code is recommended for its official support and native Claude integration.
