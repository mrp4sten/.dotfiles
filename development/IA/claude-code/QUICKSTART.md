# Claude Code — Quick Start Guide

Fast-track setup for Claude Code with your custom configuration.

---

## 🚀 One-Command Install

```bash
bash ~/.dotfiles/development/IA/claude-code/install.sh
```

This script will:
1. Install Claude Code (if not already installed)
2. Link all 33+ skills from your dotfiles
3. Merge your custom settings
4. Link global CLAUDE.md configuration
5. Create shell aliases (`lenny`, `gentleman`, `cl`)
6. Verify the installation

---

## 🔑 Authenticate

```bash
claude auth login
```

This opens a browser for OAuth authentication with Anthropic.

---

## 🎭 Launch Your Agents

### Lenny — Sarcastic CTO

```bash
lenny
```

Or:

```bash
claude --agent lenny
```

**Personality:** Sarcastic, brutally honest, gaming references, roasts bad code, teaches through tough love.

**Best for:** Refactoring, code reviews, architecture discussions, learning clean code principles.

### Gentleman — Warm Mentor

```bash
gentleman
```

Or:

```bash
claude --agent gentleman
```

**Personality:** Warm, encouraging, patient, never condescending, teaches with care.

**Best for:** Learning new concepts, debugging, pair programming, asking "dumb" questions (there are none).

---

## 📚 Using Skills

Skills are automatically discovered from `~/.claude/skills/`.

### In a session:

```bash
claude
```

Then inside the chat:

```
/skill tdd
```

Or list all skills:

```
/skills
```

### From command line:

```bash
claude --skill tdd
```

---

## 🧠 Persistent Memory (Engram)

Engram is already configured. Claude will automatically:
- Remember architectural decisions
- Recall past bug fixes
- Persist patterns and conventions
- Search previous sessions

**Pro tip:** Before ending a session, always create a summary:

```
Create a session summary for Engram
```

Claude will automatically call `mem_session_summary` with structured content.

---

## 🔄 Continue Last Session

```bash
claude --continue
```

Or:

```bash
cl -c
```

---

## 🛠️ Common Workflows

### Start a new feature with TDD:

```bash
claude --skill tdd
```

Then:

```
I need to implement user authentication
```

### Start a new feature with SDD (recommended for complex features):

```bash
claude
```

Then:

```
/sdd-init
/sdd-new user-authentication
```

The orchestrator will guide you through 8 phases:
1. **Explore** — Investigate requirements and constraints
2. **Propose** — Create change proposal with scope and approach
3. **Spec** — Write detailed specifications with requirements and scenarios
4. **Design** — Create technical design document with architecture decisions
5. **Tasks** — Break down into implementation task checklist
6. **Apply** — Implement tasks (delegated to sub-agent)
7. **Verify** — Validate implementation against specs
8. **Archive** — Close and persist final state to Engram

### Review a PR:

```bash
claude --skill pr-review
```

Then:

```
Review PR #123
```

Or:

```
Review https://github.com/user/repo/pull/123
```

### Create a chained PR:

```bash
claude --skill chained-pr
```

Then:

```
Create a chained PR for this feature
```

### Fix a bug with root cause analysis:

```bash
claude --agent lenny --skill tdd
```

Then:

```
Users are seeing a 500 error when uploading images
```

---

## 📂 Directory Structure

```
~/.dotfiles/development/IA/claude-code/
├── CLAUDE.md              # Main config (agents, skills, SDD orchestrator, Engram protocol)
├── README.md              # Full documentation
├── QUICKSTART.md          # This file
├── install.sh             # Automated installer
├── settings.json          # Claude settings (Engram, permissions)
├── agents/
│   ├── lenny.md           # Lenny agent prompt
│   └── gentleman.md       # Gentleman agent prompt
└── skills/                # All 33+ skills (shared with OpenCode)
    ├── tdd/
    ├── clean-code/
    ├── security-first/
    ├── sdd-init/          # Initialize SDD context
    ├── sdd-explore/       # Explore ideas
    ├── sdd-propose/       # Change proposals
    ├── sdd-spec/          # Specifications
    ├── sdd-design/        # Technical design
    ├── sdd-tasks/         # Task breakdown
    ├── sdd-apply/         # Implementation
    ├── sdd-verify/        # Verification
    ├── sdd-archive/       # Archive completed changes
    ├── react-19/
    ├── nextjs-15/
    ├── typescript/
    └── ... (24+ more)
```

---

## 🧪 Test the Setup

### 1. Check Claude version:

```bash
claude --version
```

### 2. List skills:

```bash
ls ~/.claude/skills/
```

Should show 33+ directories.

### 3. Test Lenny:

```bash
lenny
```

Say:

```
Hola Lenny, ¿cómo estás?
```

Expected: Sarcastic Spanish response with Mexican flair.

### 4. Test Gentleman:

```bash
gentleman
```

Say:

```
Can you explain what SOLID principles are?
```

Expected: Warm, patient explanation.

### 5. Test a skill:

```bash
claude
```

Then:

```
/skill tdd
```

Expected: TDD workflow instructions loaded.

---

## ⚙️ Configuration Files

### Global Config

`~/CLAUDE.md` — Loaded for all projects (symlinked from dotfiles)

### Per-Project Config

Copy to any project:

```bash
cp ~/.dotfiles/development/IA/claude-code/CLAUDE.md ~/my-project/CLAUDE.md
```

Edit as needed. Claude will prioritize project-local config over global.

### Settings

`~/.claude/settings.json` — Contains:
- MCP servers (Engram, Context7)
- Agent definitions
- Permissions
- Plugin configuration

---

## 🔧 Customization

### Add a new agent:

1. Create `~/.dotfiles/development/IA/claude-code/agents/my-agent.md`
2. Add to `~/.dotfiles/development/IA/claude-code/settings.json`:

```json
{
  "agents": {
    "my-agent": {
      "description": "Short description",
      "systemPromptFile": "~/.dotfiles/development/IA/claude-code/agents/my-agent.md"
    }
  }
}
```

3. Invoke:

```bash
claude --agent my-agent
```

### Add a new skill:

1. Create `~/.dotfiles/development/IA/claude-code/skills/my-skill/SKILL.md`
2. No config needed — Claude auto-discovers it

3. Use:

```bash
claude
/skill my-skill
```

---

## 🐛 Troubleshooting

### Skills not loading?

```bash
ls -la ~/.claude/skills
```

Should be a symlink to `~/.dotfiles/development/IA/claude-code/skills`.

Fix:

```bash
ln -sf ~/.dotfiles/development/IA/claude-code/skills ~/.claude/skills
```

### Agent not found?

Check that `CLAUDE.md` exists:

```bash
ls ~/CLAUDE.md
```

Or:

```bash
ls ./CLAUDE.md
```

Fix:

```bash
ln -sf ~/.dotfiles/development/IA/claude-code/CLAUDE.md ~/CLAUDE.md
```

### Engram not working?

```bash
cat ~/.claude/settings.json | grep engram
```

Should show:

```json
"enabledPlugins": {
  "engram@engram": true
}
```

Reinstall:

```bash
claude plugin install engram@engram
```

---

## 📖 Learn More

- Full docs: [`README.md`](README.md)
- Config reference: [`CLAUDE.md`](CLAUDE.md)
- Skills overview: [`skills/README.md`](skills/README.md)
- Agent prompts: [`agents/`](agents/)

---

## 🎯 Pro Tips

1. **Always use `--continue`** to resume work — keeps context and memory intact
2. **End every session with a summary** — feed Engram for future sessions
3. **Use project-local `CLAUDE.md`** for project-specific rules
4. **Combine agents and skills** — e.g., `lenny --skill tdd` for brutal TDD coaching
5. **Use bare mode for speed** — `claude --bare` skips hooks/prefetch for faster startup
6. **Leverage permissions** — edit `~/.claude/settings.json` to auto-allow trusted commands

---

**Bienvenido al Lenny Show, loco. Let's write some artistic code. 🔥**
