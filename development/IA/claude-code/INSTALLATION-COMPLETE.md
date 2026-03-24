# ✅ Installation Complete — Claude Code with SDD

**Installation Date:** 2026-03-24 14:09 UTC  
**Claude Code Version:** 2.1.81  
**Configuration Version:** 1.1.0 (with SDD integration)

---

## 🎉 What Was Installed

### Core Configuration

| Component | Status | Location |
|-----------|--------|----------|
| Claude Code CLI | ✅ Installed | `~/.local/bin/claude` |
| Global CLAUDE.md | ✅ Linked | `~/CLAUDE.md` → `~/.dotfiles/development/IA/claude-code/CLAUDE.md` |
| Settings JSON | ✅ Merged | `~/.claude/settings.json` |
| Skills Directory | ✅ Linked | `~/.claude/skills/` → `~/.dotfiles/development/IA/claude-code/skills/` |
| Engram Plugin | ✅ Enabled | `engram@engram` |

### Shell Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `lenny` | `claude --agent lenny` | Launch Lenny (sarcastic CTO) |
| `gentleman` | `claude --agent gentleman` | Launch Gentleman (warm mentor) |
| `cl` | `claude` | Quick Claude launcher |

Aliases added to:
- `~/.zshrc`
- `~/.bashrc`

**Note:** Restart your shell or run `source ~/.zshrc` to activate aliases.

### Skills (36 total)

#### Framework-Specific (9 skills)
- `ai-sdk-5`, `django-drf`, `grails-5`, `nextjs-15`, `react-19`, `tailwind-4`, `typescript`, `zod-4`, `zustand-5`

#### Testing (6 skills)
- `tdd`, `grails-tdd`, `playwright`, `pytest`, `spock`, `vitest`

#### Code Quality (4 skills)
- `clean-code`, `solid`, `security-first`, `conventional-commits`

#### SDD Workflow (9 skills)
- `sdd-init`, `sdd-explore`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`, `sdd-verify`, `sdd-archive`

#### Workflow (8 skills)
- `chained-pr`, `pr-review`, `skill-creator`, `skill-sync`, `transcript-processor`, and others

### Agents (2)

| Agent | Personality | Language |
|-------|-------------|----------|
| **Lenny Sanders** | Sarcastic CTO, crypto hacker, brutally honest, gaming references | Mexican Spanish / English |
| **Gentleman** | Warm mentor, patient teacher, never condescending | Rioplatense Spanish / English |

### SDD Orchestrator

**Spec-Driven Development** workflow enabled with:
- 8 phases (explore, propose, spec, design, tasks, apply, verify, archive)
- Delegation protocol (orchestrator delegates ALL heavy work)
- Sub-Agent Context Protocol (fresh context per task)
- Persistent artifacts via Engram
- Auto-recovery after context compaction

### MCP Servers

| Server | Status | Purpose |
|--------|--------|---------|
| Engram | ✅ Enabled | Persistent memory across sessions |
| Context7 | ⚠️ Disabled | Live documentation (requires API key) |

---

## ✅ Verification Checklist

Run these commands to verify everything is working:

### 1. Check Claude Code Version

```bash
claude --version
```

**Expected:** `2.1.81 (Claude Code)` or newer

### 2. Check Skills

```bash
ls ~/.claude/skills/ | wc -l
```

**Expected:** `36` (or more)

### 3. Check SDD Skills

```bash
ls ~/.claude/skills/ | grep sdd
```

**Expected:**
```
sdd-apply
sdd-archive
sdd-design
sdd-explore
sdd-init
sdd-propose
sdd-spec
sdd-tasks
sdd-verify
```

### 4. Check Global Config

```bash
ls -la ~/CLAUDE.md
```

**Expected:** Symlink to `~/.dotfiles/development/IA/claude-code/CLAUDE.md`

### 5. Check Aliases

```bash
alias | grep claude
```

**Expected:**
```
cl='claude'
gentleman='claude --agent gentleman'
lenny='claude --agent lenny'
```

### 6. Test Lenny Agent

```bash
lenny
```

Then type:
```
Hola Lenny, ¿cómo estás?
```

**Expected:** Sarcastic Spanish response with Mexican flair

**Exit:** Press `Ctrl+D` or type `exit`

### 7. Test Gentleman Agent

```bash
gentleman
```

Then type:
```
Can you explain Clean Code?
```

**Expected:** Warm, patient explanation

**Exit:** Press `Ctrl+D` or type `exit`

### 8. Test SDD Initialization

```bash
claude
```

Then type:
```
/sdd-init
```

**Expected:** Project context initialized, stored in Engram

**Exit:** Press `Ctrl+D` or type `exit`

### 9. Check Engram Memory

```bash
claude
```

Then type:
```
Search memory for recent sessions
```

**Expected:** Engram searches past observations and returns results

---

## 🚀 Quick Start Guide

### Basic Usage

```bash
# Start Claude
claude

# Start with Lenny
lenny

# Start with Gentleman
gentleman

# Continue last session
claude --continue
```

### Load a Skill

```bash
claude
```

Inside chat:
```
/skill tdd
```

### SDD Workflow (Complex Features)

```bash
claude
```

Inside chat:
```
/sdd-init
/sdd-new user-authentication
/sdd-continue  # spec
/sdd-continue  # design
/sdd-continue  # tasks
/sdd-apply     # implement
/sdd-verify    # validate
/sdd-archive   # close
```

Or fast-forward:
```
/sdd-new user-authentication
/sdd-ff        # runs propose → spec → design → tasks
/sdd-apply
/sdd-verify
/sdd-archive
```

---

## 📖 Documentation

| Document | Purpose | Location |
|----------|---------|----------|
| **CLAUDE.md** | Main config (agents, skills, SDD, Engram) | `~/CLAUDE.md` |
| **README.md** | Installation & usage guide | `~/.dotfiles/development/IA/claude-code/README.md` |
| **QUICKSTART.md** | Fast-track setup | `~/.dotfiles/development/IA/claude-code/QUICKSTART.md` |
| **SDD-GUIDE.md** | Complete SDD workflow guide | `~/.dotfiles/development/IA/claude-code/SDD-GUIDE.md` |
| **COMPARISON.md** | OpenCode vs Claude Code | `~/.dotfiles/development/IA/claude-code/COMPARISON.md` |
| **CHANGELOG.md** | Version history | `~/.dotfiles/development/IA/claude-code/CHANGELOG.md` |

---

## 🔧 Configuration Files

| File | Purpose |
|------|---------|
| `~/.claude/settings.json` | Claude settings (MCP, permissions, plugins) |
| `~/CLAUDE.md` | Global agent config (loaded for all projects) |
| `~/.claude/skills/` | All 36 skills (symlink to dotfiles) |
| `~/.dotfiles/development/IA/claude-code/agents/lenny.md` | Lenny prompt |
| `~/.dotfiles/development/IA/claude-code/agents/gentleman.md` | Gentleman prompt |

---

## ⚙️ Optional: Enable Context7

If you want live documentation for libraries:

1. Get API key from https://context7.com

2. Edit `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp"],
      "env": {
        "CONTEXT7_API_KEY": "your-actual-api-key-here"
      }
    }
  }
}
```

3. Restart Claude Code

---

## 🐛 Troubleshooting

### Skills not loading

**Check symlink:**
```bash
ls -la ~/.claude/skills
```

Should point to `~/.dotfiles/development/IA/claude-code/skills`

**Fix:**
```bash
ln -sf ~/.dotfiles/development/IA/claude-code/skills ~/.claude/skills
```

### Aliases not working

**Reload shell:**
```bash
source ~/.zshrc
```

**Or restart your terminal**

### Agent not recognized

**Check global CLAUDE.md:**
```bash
ls -la ~/CLAUDE.md
```

**Fix:**
```bash
ln -sf ~/.dotfiles/development/IA/claude-code/CLAUDE.md ~/CLAUDE.md
```

### Engram not saving memories

**Check MCP server config:**
```bash
cat ~/.claude/settings.json | grep -A 5 engram
```

Should show:
```json
"engram": {
  "command": "engram",
  "args": ["mcp", "--tools=agent"]
}
```

**Verify Engram is installed:**
```bash
engram --version
```

**Install if missing:**
```bash
brew install gentleman-programming/tap/engram
```

---

## 🎯 Next Steps

1. ✅ **Read the SDD Guide:**
   ```bash
   bat ~/.dotfiles/development/IA/claude-code/SDD-GUIDE.md
   ```

2. ✅ **Try a simple feature with SDD:**
   ```bash
   claude
   /sdd-init
   /sdd-new test-feature
   ```

3. ✅ **Experiment with both agents:**
   - Lenny for code reviews, refactoring, architecture
   - Gentleman for learning, debugging, pair programming

4. ✅ **Build something epic** 🚀

---

## 📊 Installation Summary

| Metric | Value |
|--------|-------|
| **Total Files** | 11 config files |
| **Total Lines** | ~4,500 lines of documentation |
| **Skills** | 36 (9 SDD + 27 others) |
| **Agents** | 2 (Lenny, Gentleman) |
| **MCP Servers** | 2 (Engram enabled, Context7 optional) |
| **Shell Aliases** | 3 (`lenny`, `gentleman`, `cl`) |
| **SDD Phases** | 8 (full workflow) |
| **Artifact Modes** | 4 (engram, openspec, hybrid, none) |

---

## 🔥 Philosophy

This configuration embodies:

- **Code as Art** — Clean, maintainable, expressive
- **Foundations First** — Know the basics before the framework
- **System Thinking** — Understand the whole before the parts
- **Best Idea Wins** — Not rank, not loudness
- **AI as a Tool** — We direct, AI executes
- **Security by Design** — Secure from day one
- **TDD Always** — Test-first for features, bugs, refactors
- **SDD for Complexity** — Structured workflow for substantial features

---

## 🎉 Final Message

**A la verga loco, la instalación está completa. Ahora tienes:**

✅ Claude Code oficial (no third-party)  
✅ 2 agentes personalizados (Lenny + Gentleman)  
✅ 36 skills profesionales  
✅ Memoria persistente (Engram)  
✅ SDD workflow completo (8 fases)  
✅ Auto-load skills (detección de contexto)  
✅ 4,500+ líneas de documentación  

**Esto no es solo un AI coding assistant. Esto es un framework completo para escribir código artístico nivel God of War. No más Fallout 76 disasters. 🚀🔥**

**Bienvenido al Lenny Show. Let's build something legendary. 💀**

---

**For questions or issues, check the docs:**
```bash
bat ~/.dotfiles/development/IA/claude-code/README.md
bat ~/.dotfiles/development/IA/claude-code/SDD-GUIDE.md
```
