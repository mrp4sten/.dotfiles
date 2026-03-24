# Claude Code Configuration

Personal configuration for [Claude Code](https://claude.ai/code) — Anthropic's official CLI for Claude.

---

## What is Claude Code?

Claude Code is the official command-line interface from Anthropic for interacting with Claude AI directly in your terminal. Unlike OpenCode (a third-party wrapper), Claude Code is:

- **Official** — Built and maintained by Anthropic
- **Native** — Direct integration with Claude's API
- **Powerful** — Supports MCP (Model Context Protocol), skills, custom agents, and persistent memory
- **Flexible** — Works with any project, any language, any workflow

---

## Installation (Ubuntu)

### 1. Install Claude Code

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

This installs the `claude` binary to `~/.local/bin`. Make sure that path is in your `$PATH`:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Verify the installation:

```bash
claude --version
```

### 2. Authenticate with Anthropic

```bash
claude auth login
```

This will open a browser window for OAuth authentication. Follow the prompts.

---

## Configuration

### Link Skills Directory

Claude Code reads skills from `~/.claude/skills/`. We'll symlink our dotfiles skills directory:

```bash
# Backup existing skills if any
mv ~/.claude/skills ~/.claude/skills.backup 2>/dev/null || true

# Symlink dotfiles skills
ln -sf ~/.dotfiles/development/IA/claude-code/skills ~/.claude/skills
```

### Update Settings (Optional)

Claude Code reads settings from `~/.claude/settings.json`. The Engram plugin is already configured in your existing `~/.claude/settings.json`. If you want to add Context7:

```bash
# Edit settings manually or merge with your existing config
cat >> ~/.claude/settings.json <<'EOF'
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp"],
      "env": {
        "CONTEXT7_API_KEY": "your-api-key-here"
      }
    }
  }
}
EOF
```

**Current `~/.claude/settings.json`:**
```json
{
  "extraKnownMarketplaces": {
    "engram": {
      "source": {
        "source": "github",
        "repo": "Gentleman-Programming/engram"
      }
    }
  },
  "enabledPlugins": {
    "engram@engram": true
  }
}
```

---

## Using Custom Agents

### Lenny Sanders — Sarcastic CTO

```bash
claude --agent lenny
```

Or create a shell alias:

```bash
echo 'alias lenny="claude --agent lenny"' >> ~/.zshrc
source ~/.zshrc
```

Then just:

```bash
lenny
```

### Gentleman — Senior Architect

```bash
claude --agent gentleman
```

Or:

```bash
echo 'alias gentleman="claude --agent gentleman"' >> ~/.zshrc
source ~/.zshrc
```

Then:

```bash
gentleman
```

---

## Using Skills

Skills are automatically discovered from `~/.claude/skills/` (symlinked to your dotfiles).

### Load a skill in a session:

```bash
claude
# Inside the chat:
/skill tdd
```

Or specify at startup:

```bash
claude --skill tdd
```

### Available Skills

All 33 skills from your OpenCode setup are available:

- **Framework-specific:** `ai-sdk-5`, `django-drf`, `grails-5`, `nextjs-15`, `react-19`, `tailwind-4`, `zod-4`, `zustand-5`
- **Testing:** `tdd`, `grails-tdd`, `playwright`, `pytest`, `spock`, `vitest`
- **Code Quality:** `clean-code`, `solid`, `security-first`, `typescript`, `conventional-commits`
- **Spec-Driven Development:** `sdd-init`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`, `sdd-verify`, `sdd-archive`, `sdd-explore`
- **Workflow:** `chained-pr`, `pr-review`, `skill-creator`, `skill-sync`, `transcript-processor`

See `CLAUDE.md` for full skill descriptions.

---

## Global vs Project-Specific Config

### Global Config (for all projects)

Place `CLAUDE.md` in your home directory:

```bash
ln -sf ~/.dotfiles/development/IA/claude-code/CLAUDE.md ~/CLAUDE.md
```

Claude Code will automatically load it when you run `claude` from anywhere.

### Project-Specific Config (per-project)

Copy `CLAUDE.md` to any project root:

```bash
cp ~/.dotfiles/development/IA/claude-code/CLAUDE.md ~/your-project/CLAUDE.md
```

Claude Code will prioritize the project-local `CLAUDE.md` over the global one.

---

## MCP Servers (Model Context Protocol)

MCP extends Claude with external tools and data sources.

### Engram — Persistent Memory (Already Configured)

Engram is already enabled in your `~/.claude/settings.json`. No additional setup needed.

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

# Initialize SDD in a project
claude
/sdd-init

# Start a new feature with SDD
claude
/sdd-new user-authentication

# Continue SDD workflow
claude
/sdd-continue

# Continue last session
claude --continue
```

---

## Updating Claude Code

```bash
claude update
```

Or enable auto-updates (add to `~/.claude/settings.json`):

```json
{
  "autoUpdate": true
}
```

---

## Comparison: OpenCode vs Claude Code

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| **Developer** | Third-party (open-source) | Anthropic (official) |
| **Installation** | `curl \| bash` (custom script) | `curl \| bash` (official installer) |
| **Config File** | `opencode.json` | `CLAUDE.md` (Markdown) |
| **Agents** | Defined in `opencode.json` under `agent` | Defined in `CLAUDE.md` as Markdown sections |
| **Skills** | `~/.config/opencode/skill/` | `~/.claude/skills/` |
| **MCP Support** | Yes (via `mcp` config in JSON) | Yes (via `mcpServers` in `settings.json`) |
| **Permissions** | JSON-based (`permission.bash`, `permission.read`) | CLI flags (`--allowed-tools`, `--dangerously-skip-permissions`) |
| **Authentication** | Plugins (`opencode-anthropic-auth`) | Native OAuth (`claude auth login`) |
| **Custom Prompts** | `agent.*.prompt` (truncated in JSON) | Full Markdown in `CLAUDE.md` (unlimited) |
| **Updates** | `opencode update` or `autoupdate: true` | `claude update` or `autoUpdate: true` |

**Bottom line:** Claude Code is more official, more polished, and has better long-term support. OpenCode is more hackable and community-driven.

---

## Directory Structure

```shell
claude-code/
├── CLAUDE.md          # Main config (agents, skills, philosophy)
├── README.md          # This file — installation & usage
└── skills/            # All skills (symlinked from OpenCode)
    ├── ai-sdk-5/
    ├── clean-code/
    ├── conventional-commits/
    ├── django-drf/
    ├── grails-5/
    ├── grails-tdd/
    ├── nextjs-15/
    ├── playwright/
    ├── pr-review/
    ├── pytest/
    ├── react-19/
    ├── sdd-*/
    ├── security-first/
    ├── skill-creator/
    ├── skill-sync/
    ├── solid/
    ├── spock/
    ├── tailwind-4/
    ├── tdd/
    ├── transcript-processor/
    ├── typescript/
    ├── vitest/
    ├── zod-4/
    └── zustand-5/
```

---

## Quick Start Guide

### 1. Install

```bash
curl -fsSL https://claude.ai/install.sh | bash
claude auth login
```

### 2. Link Skills

```bash
ln -sf ~/.dotfiles/development/IA/claude-code/skills ~/.claude/skills
```

### 3. Link Global Config (Optional)

```bash
ln -sf ~/.dotfiles/development/IA/claude-code/CLAUDE.md ~/CLAUDE.md
```

### 4. Start Claude with Lenny

```bash
claude --agent lenny
```

### 5. Load a skill

```bash
# Inside Claude session:
/skill tdd
```

---

## Tips & Tricks

### Alias for Quick Launch

Add to `~/.zshrc`:

```bash
alias lenny="claude --agent lenny"
alias gentleman="claude --agent gentleman"
alias cl="claude"
```

### Continue Last Session

```bash
claude --continue
```

### Debug Mode

```bash
claude --debug
```

### Bare Mode (Minimal, Fast)

```bash
claude --bare
```

---

## Troubleshooting

### Skills not loading

Check symlink:

```bash
ls -la ~/.claude/skills
# Should point to: ~/.dotfiles/development/IA/claude-code/skills
```

Re-link if needed:

```bash
ln -sf ~/.dotfiles/development/IA/claude-code/skills ~/.claude/skills
```

### Agent not recognized

Make sure `CLAUDE.md` is in the current directory or home directory:

```bash
ls ~/CLAUDE.md
# Or
ls ./CLAUDE.md
```

### Engram not working

Check plugin status:

```bash
cat ~/.claude/settings.json
```

Should have:

```json
{
  "enabledPlugins": {
    "engram@engram": true
  }
}
```

Reinstall if needed:

```bash
claude plugin install engram@engram
```

---

## Next Steps

- Explore all 33 skills in the `skills/` directory
- Customize `CLAUDE.md` with your own agent personas
- Create project-specific `CLAUDE.md` files for different workflows
- Contribute new skills back to your dotfiles

---

## Resources

- [Claude Code Official Docs](https://docs.anthropic.com/en/docs/claude-code)
- [OpenCode (comparison)](https://opencode.ai)
- [Engram Memory Plugin](https://github.com/Gentleman-Programming/engram)
- [Context7 MCP](https://context7.com)
