# OpenCode vs Claude Code — Detailed Comparison

What's the difference between OpenCode and Claude Code, and which one should you use?

---

## TL;DR

| Aspect | OpenCode | Claude Code |
|--------|----------|-------------|
| **Developer** | Third-party (open-source) | Anthropic (official) |
| **Stability** | Community-maintained | Enterprise-grade |
| **Speed** | Fast (direct API) | Fast (native integration) |
| **Authentication** | Plugin-based | Native OAuth |
| **Config Format** | JSON (`opencode.json`) | Markdown (`CLAUDE.md`) |
| **Skills** | `~/.config/opencode/skill/` | `~/.claude/skills/` |
| **MCP Support** | ✅ Yes | ✅ Yes (better) |
| **Engram Memory** | ✅ Yes | ✅ Yes |
| **Custom Agents** | ✅ Yes | ✅ Yes (easier) |
| **Long-term Support** | Community-dependent | Anthropic-backed |

**Recommendation:** Use **Claude Code** for production work. Use **OpenCode** for experimentation or if you prefer JSON config.

---

## Detailed Comparison

### 1. Installation

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| Install command | `curl -fsSL https://opencode.ai/install \| bash` | `curl -fsSL https://claude.ai/install.sh \| bash` |
| Binary location | `~/.local/bin/opencode` | `~/.local/bin/claude` |
| Auto-update | ✅ Yes (`autoupdate: true`) | ✅ Yes (`autoUpdate: true`) |
| Manual update | `opencode update` | `claude update` |

### 2. Authentication

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| Method | Plugin (`opencode-anthropic-auth`) | Native OAuth |
| Setup | `npm install -g opencode-anthropic-auth && opencode auth login` | `claude auth login` |
| API Key | Stored via plugin | Stored via OAuth token |
| Browser required | ✅ Yes | ✅ Yes |

**Winner:** Claude Code (simpler, no npm dependency)

### 3. Configuration

#### OpenCode

**Config file:** `~/.config/opencode/opencode.json`

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "lenny": {
      "description": "...",
      "mode": "primary",
      "prompt": "You are a CTO...",
      "tools": {
        "edit": true,
        "write": true
      }
    }
  },
  "mcp": {
    "engram": {
      "command": ["engram", "mcp", "--tools=agent"],
      "enabled": true,
      "type": "local"
    }
  },
  "permission": {
    "bash": {
      "*": "allow",
      "git commit *": "ask"
    }
  }
}
```

**Pros:** Structured, validated by JSON schema
**Cons:** Prompts are truncated in JSON (2000 char limit), harder to edit multiline text

#### Claude Code

**Config file:** `~/CLAUDE.md` (Markdown)

```markdown
# Claude Code Configuration

## Custom Agents

### Lenny Sanders — Sarcastic CTO

You are a CTO with 15+ years of experience...

(Full prompt, unlimited length, readable Markdown)
```

**Settings file:** `~/.claude/settings.json`

```json
{
  "mcpServers": {
    "engram": {
      "command": "engram",
      "args": ["mcp", "--tools=agent"]
    }
  }
}
```

**Pros:** Unlimited prompt length, readable Markdown, easy to edit
**Cons:** Less structured (but more flexible)

**Winner:** Claude Code (better for long prompts, easier to read/edit)

### 4. Custom Agents

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| Definition | `agent` object in `opencode.json` | Markdown sections in `CLAUDE.md` |
| Prompt length | Limited (~2000 chars per prompt) | Unlimited |
| Tool permissions | Explicit (`"tools": {"edit": true}`) | Implicit (all tools available) |
| Agent switching | Via UI selector | `--agent <name>` flag |
| Default agent | `"mode": "primary"` | `"defaultAgent": "lenny"` in settings |

**Winner:** Claude Code (more flexible, better for complex prompts)

### 5. Skills

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| Location | `~/.config/opencode/skill/` | `~/.claude/skills/` |
| Format | `SKILL.md` (Markdown) | `SKILL.md` (Markdown) |
| Auto-discovery | ✅ Yes | ✅ Yes |
| Invocation | `/skill-name` | `/skill skill-name` or `--skill skill-name` |
| Shared skills | ✅ Yes (via symlink) | ✅ Yes (via symlink) |

**Winner:** Tie (both use the same format, fully compatible)

### 6. MCP (Model Context Protocol)

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| MCP support | ✅ Yes | ✅ Yes |
| Config location | `opencode.json` → `mcp` | `~/.claude/settings.json` → `mcpServers` |
| Engram support | ✅ Yes | ✅ Yes |
| Context7 support | ✅ Yes | ✅ Yes |
| Custom MCP servers | ✅ Yes | ✅ Yes |

**Winner:** Tie (both support MCP fully)

### 7. Permissions

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| Config location | `opencode.json` → `permission` | `~/.claude/settings.json` → `permissions` |
| Bash permissions | `"bash": {"*": "allow", "git push": "ask"}` | `"bash": {"allow": ["*"], "ask": ["git push"]}` |
| Read permissions | `"read": {"*": "allow", "**/.env": "deny"}` | `"read": {"allow": ["*"], "deny": ["**/.env"]}` |
| Override via CLI | ❌ No | ✅ Yes (`--dangerously-skip-permissions`) |

**Winner:** Claude Code (more flexible, CLI overrides)

### 8. User Experience

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| UI/UX | Custom terminal UI | Native Claude UI |
| Speed | Fast | Fast |
| Session resume | ✅ Yes | ✅ Yes (`--continue`) |
| Fork session | ❌ No | ✅ Yes (`--fork-session`) |
| Debug mode | ✅ Yes (`--debug`) | ✅ Yes (`--debug`) |
| Bare mode | ❌ No | ✅ Yes (`--bare` for minimal startup) |

**Winner:** Claude Code (more features, better UX)

### 9. Ecosystem & Support

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| Developer | Community (open-source) | Anthropic (official) |
| Support | GitHub issues | Official Anthropic support |
| Updates | Community-driven | Anthropic-driven |
| Breaking changes | Possible | Rare (enterprise stability) |
| Long-term viability | Depends on community | Backed by Anthropic |
| Documentation | Community wiki | Official docs |

**Winner:** Claude Code (official support, long-term stability)

### 10. Performance

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| Startup time | ~1-2s | ~1-2s (bare mode: <1s) |
| API latency | Same (both use Claude API) | Same (both use Claude API) |
| Memory usage | Low | Low |
| Context handling | Same | Same |

**Winner:** Tie (both are fast)

---

## Which One Should You Use?

### Use **Claude Code** if:

- ✅ You want **official** Anthropic support
- ✅ You need **long prompts** for custom agents
- ✅ You prefer **Markdown** over JSON
- ✅ You want **enterprise-grade stability**
- ✅ You need **CLI permission overrides**
- ✅ You want **session forking**
- ✅ You prefer **native OAuth** (no npm plugins)

### Use **OpenCode** if:

- ✅ You prefer **JSON configuration**
- ✅ You like **structured schemas**
- ✅ You want to **contribute to open-source**
- ✅ You need **explicit tool permissions per agent**
- ✅ You prefer **community-driven development**

---

## Migration: OpenCode → Claude Code

Your dotfiles now support **both** OpenCode and Claude Code with **shared skills**.

### What's Shared:

- ✅ All 33+ skills (via symlink)
- ✅ Engram memory (same database)
- ✅ Agent personas (Lenny, Gentleman)
- ✅ Permissions philosophy (read deny `.env`, ask on `git push`)

### What's Different:

- Config format (JSON vs Markdown)
- Binary name (`opencode` vs `claude`)
- Config location (`~/.config/opencode/` vs `~/.claude/`)

### How to Switch:

#### From OpenCode to Claude Code:

```bash
# Install Claude Code
bash ~/.dotfiles/development/IA/claude-code/install.sh

# Start using Claude Code
claude --agent lenny
```

Your OpenCode setup remains intact. Both can coexist.

#### From Claude Code to OpenCode:

```bash
# Install OpenCode
curl -fsSL https://opencode.ai/install | bash

# Link config
ln -sf ~/.dotfiles/development/IA/opencode ~/.config/opencode

# Authenticate
npm install -g opencode-anthropic-auth
opencode auth login

# Start using OpenCode
opencode
```

---

## Recommendation

**Use Claude Code.** It's official, stable, and has better long-term support. OpenCode is great for experimentation, but Claude Code is the production-ready tool backed by Anthropic.

Your dotfiles are configured for **both**, so you can switch anytime without losing skills, agents, or memory.

---

## Summary Table

| Category | OpenCode | Claude Code | Winner |
|----------|----------|-------------|--------|
| **Installation** | Easy | Easy | Tie |
| **Authentication** | Plugin-based | Native OAuth | Claude Code |
| **Configuration** | JSON (limited prompts) | Markdown (unlimited) | Claude Code |
| **Custom Agents** | ✅ Yes | ✅ Yes (better) | Claude Code |
| **Skills** | ✅ Yes | ✅ Yes | Tie |
| **MCP** | ✅ Yes | ✅ Yes | Tie |
| **Permissions** | JSON-based | JSON + CLI overrides | Claude Code |
| **UX** | Good | Better | Claude Code |
| **Support** | Community | Official | Claude Code |
| **Performance** | Fast | Fast | Tie |

**Overall Winner:** **Claude Code** 🏆

---

**A la mierda OpenCode (solo por hoy), vamos con Claude Code, loco. It's the official shit. 🔥**
