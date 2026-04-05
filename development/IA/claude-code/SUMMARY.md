# Claude Code Configuration — Summary

Complete Claude Code setup based on your OpenCode configuration.

---

## 📦 What Was Created

### Main Configuration Files

| File | Purpose | Lines |
|------|---------|-------|
| `CLAUDE.md` | Main config — agent definitions, skill reference | ~370 |
| `README.md` | Full installation and usage documentation | ~550 |
| `QUICKSTART.md` | Fast-track setup guide | ~450 |
| `COMPARISON.md` | OpenCode vs Claude Code comparison | ~400 |
| `settings.json` | Claude Code settings (MCP, permissions) | ~60 |
| `install.sh` | Automated installation script | ~220 |
| `.gitignore` | Exclude sensitive files from git | ~30 |

### Agent Prompts

| File | Agent | Personality |
|------|-------|-------------|
| `agents/lenny.md` | Lenny Sanders | Sarcastic CTO, crypto hacker, brutal honesty, gaming references |
| `agents/gentleman.md` | Gentleman | Warm mentor, patient teacher, never condescending |

### Skills Directory

| Directory | Description | Count |
|-----------|-------------|-------|
| `skills/` | All skills from OpenCode | 33+ skills |
| `skills/sdd-*` | Spec-Driven Development workflow | 9 skills |
| `skills/tdd`, `security-first`, `clean-code` | Core development practices | 3 skills |
| `skills/react-19`, `nextjs-15`, `typescript` | Frontend frameworks | 3 skills |
| `skills/grails-5`, `django-drf` | Backend frameworks | 2 skills |
| `skills/pytest`, `spock`, `vitest`, `playwright` | Testing frameworks | 4 skills |
| Others | Tools, workflows, utilities | 12 skills |

---

## 📂 Directory Structure

```
claude-code/
├── CLAUDE.md                  # Main config (370 lines)
├── README.md                  # Full documentation (550 lines)
├── QUICKSTART.md              # Quick start guide (450 lines)
├── COMPARISON.md              # OpenCode vs Claude Code (400 lines)
├── SUMMARY.md                 # This file
├── settings.json              # Settings (60 lines)
├── install.sh                 # Installer (220 lines)
├── .gitignore                 # Git ignore rules
├── agents/
│   ├── lenny.md               # Lenny agent prompt
│   └── gentleman.md           # Gentleman agent prompt
└── skills/                    # 33+ skills (shared with OpenCode)
    ├── ai-sdk-5/
    ├── chained-pr/
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
    ├── sdd-apply/
    ├── sdd-archive/
    ├── sdd-design/
    ├── sdd-explore/
    ├── sdd-init/
    ├── sdd-propose/
    ├── sdd-spec/
    ├── sdd-tasks/
    ├── sdd-verify/
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

**Total:** ~2000 lines of configuration + 33 skills

---

## 🚀 Installation

### One-Command Install

```bash
bash ~/.dotfiles/development/IA/claude-code/install.sh
```

This will:
1. ✅ Install Claude Code (if not installed)
2. ✅ Link all skills from dotfiles
3. ✅ Merge settings (preserving Engram config)
4. ✅ Link global CLAUDE.md
5. ✅ Create shell aliases (`lenny`, `gentleman`, `cl`)
6. ✅ Verify installation

### Manual Install

```bash
# 1. Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# 2. Authenticate
claude auth login

# 3. Link skills
ln -sf ~/.dotfiles/development/IA/claude-code/skills ~/.claude/skills

# 4. Copy settings
cp ~/.dotfiles/development/IA/claude-code/settings.json ~/.claude/settings.json

# 5. Link global config
ln -sf ~/.dotfiles/development/IA/claude-code/CLAUDE.md ~/CLAUDE.md

# 6. Add aliases to ~/.zshrc
echo 'alias lenny="claude --agent lenny"' >> ~/.zshrc
echo 'alias gentleman="claude --agent gentleman"' >> ~/.zshrc
echo 'alias cl="claude"' >> ~/.zshrc
source ~/.zshrc
```

---

## 🎭 Usage

### Launch Agents

```bash
# Lenny (sarcastic CTO)
lenny

# Gentleman (warm mentor)
gentleman

# Default
claude
```

### Load Skills

```bash
claude
/skill tdd
```

Or:

```bash
claude --skill tdd
```

### Continue Session

```bash
claude --continue
```

---

## 🔑 Key Features

### 1. Custom Agents

- **Lenny Sanders:** Sarcastic CTO, brutal honesty, gaming references, roasts bad code
- **Gentleman:** Warm mentor, patient, never condescending, teaches with care

Both agents:
- Speak **Spanish** (Lenny: Mexican, Gentleman: Rioplatense) when prompted in Spanish
- Use modern CLI tools (`bat`, `rg`, `fd`, `eza`)
- Follow SOLID, Clean Code, TDD, Secure by Design principles
- Stop and wait when asking questions (no over-explaining)

### 2. 33+ Skills

All skills from OpenCode, including:
- **Development:** `tdd`, `clean-code`, `security-first`, `solid`
- **Frameworks:** `react-19`, `nextjs-15`, `typescript`, `grails-5`, `django-drf`
- **Testing:** `pytest`, `spock`, `vitest`, `playwright`, `grails-tdd`
- **Workflows:** `sdd-*` (Spec-Driven Development), `chained-pr`, `pr-review`
- **Tools:** `skill-creator`, `skill-sync`, `conventional-commits`, `transcript-processor`

### 3. Persistent Memory (Engram)

Engram is pre-configured and shares the same database with OpenCode:
- Architecture decisions
- Bug fixes
- Patterns and conventions
- Session summaries

### 4. Permissions

**Read permissions:**
- ✅ Allow: All files
- ❌ Deny: `.env`, `credentials.json`, `secrets/**`

**Bash permissions:**
- ✅ Allow: Most commands
- ❓ Ask: `git commit`, `git push`, `git push --force`, `git rebase`, `git reset --hard`

### 5. MCP Servers

- **Engram:** Persistent memory (enabled by default)
- **Context7:** Live documentation (disabled, requires API key)

---

## 🔄 Shared with OpenCode

These are **shared** between OpenCode and Claude Code:

| Item | Location | Shared? |
|------|----------|---------|
| Skills | `~/.dotfiles/development/IA/claude-code/skills/` | ✅ Yes (symlink) |
| Engram memory | `~/.engram/` (SQLite database) | ✅ Yes (same DB) |
| Agent personas | Defined separately but same personality | ✅ Yes (ported) |
| Permissions philosophy | Defined separately but same rules | ✅ Yes (ported) |

Both tools can **coexist** without conflict. You can use OpenCode for some projects and Claude Code for others.

---

## 📊 Stats

| Metric | Value |
|--------|-------|
| Configuration files | 9 |
| Total lines of config | ~2000 |
| Skills | 33+ |
| Agents | 2 (Lenny, Gentleman) |
| MCP servers | 2 (Engram, Context7) |
| Supported languages | 10+ (JS/TS, Python, Java/Groovy, Go, etc.) |
| Frameworks covered | 15+ (React, Next.js, Grails, Django, etc.) |

---

## 🆚 OpenCode vs Claude Code

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| Developer | Third-party | Anthropic (official) |
| Config format | JSON | Markdown |
| Prompt length | Limited (~2000 chars) | Unlimited |
| Authentication | Plugin | Native OAuth |
| Support | Community | Official |
| Stability | Good | Enterprise-grade |

**Recommendation:** Use **Claude Code** for production work. It's official, stable, and has better long-term support.

---

## 📖 Documentation

| File | Purpose |
|------|---------|
| `README.md` | Full installation, configuration, and usage guide |
| `QUICKSTART.md` | Fast-track setup for impatient developers |
| `COMPARISON.md` | Detailed OpenCode vs Claude Code comparison |
| `CLAUDE.md` | Main config file (loaded by Claude) |
| `SUMMARY.md` | This file — overview of the setup |

---

## ✅ Verification Checklist

After installation, verify:

- [ ] `claude --version` works
- [ ] `~/.claude/skills/` is a symlink to dotfiles
- [ ] `~/CLAUDE.md` is a symlink to dotfiles
- [ ] `lenny` alias launches Lenny agent
- [ ] `gentleman` alias launches Gentleman agent
- [ ] `/skill tdd` loads the TDD skill inside a Claude session
- [ ] Engram memory is working (`mem_search` tool available)

---

## 🎯 Next Steps

1. **Authenticate:**
   ```bash
   claude auth login
   ```

2. **Test Lenny:**
   ```bash
   lenny
   ```
   Say: `Hola Lenny, ¿cómo estás?`

3. **Test Gentleman:**
   ```bash
   gentleman
   ```
   Say: `Can you explain SOLID principles?`

4. **Test a skill:**
   ```bash
   claude
   /skill tdd
   ```

5. **Build something awesome** 🚀

---

## 🐛 Troubleshooting

### Skills not loading?

```bash
ls -la ~/.claude/skills
```

Should be a symlink. Fix:

```bash
ln -sf ~/.dotfiles/development/IA/claude-code/skills ~/.claude/skills
```

### Agent not found?

```bash
ls ~/CLAUDE.md
```

Should be a symlink. Fix:

```bash
ln -sf ~/.dotfiles/development/IA/claude-code/CLAUDE.md ~/CLAUDE.md
```

### Engram not working?

```bash
cat ~/.claude/settings.json | grep engram
```

Should show `"engram@engram": true`. Fix:

```bash
claude plugin install engram@engram
```

---

## 🎓 Philosophy

This configuration embodies:

1. **Code as Art:** Clean, maintainable, expressive
2. **Foundations First:** Know the basics before the framework
3. **System Thinking:** Understand the whole before the parts
4. **Best Idea Wins:** Not rank, not loudness
5. **AI as a Tool:** We direct, AI executes (Tony Stark, not the suit)
6. **Security by Design:** Secure from day one, not bolted on
7. **TDD Always:** Test-first for features, bugs, and refactors

---

## 🔥 Final Thoughts

You now have:
- ✅ Official Anthropic CLI (Claude Code)
- ✅ 33+ battle-tested skills
- ✅ 2 custom agents (Lenny, Gentleman)
- ✅ Persistent memory (Engram)
- ✅ Spec-Driven Development workflow
- ✅ Fully documented and automated setup

This is the **same** powerful setup as OpenCode, but with:
- Official Anthropic support
- Better long-term stability
- Unlimited prompt lengths
- Cleaner Markdown config

**Bienvenido al Lenny Show, loco. Let's write some artistic, bulletproof code. 🔥**

---

_Created on 2026-03-24 by your AI assistant (probably Lenny, because this README is sarcastic as fuck)._
