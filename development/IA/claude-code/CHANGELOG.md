# Changelog

All notable changes to the Claude Code configuration.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.1.0] - 2026-03-24

### Added - SDD Integration

**Spec-Driven Development (SDD) Orchestrator:**
- Full SDD workflow with 8 phases (explore, propose, spec, design, tasks, apply, verify, archive)
- Delegation protocol — orchestrator delegates ALL heavy work to specialized sub-agents
- Sub-Agent Context Protocol — fresh context per task with explicit artifact read/write rules
- Hard Stop Rules — ZERO exceptions for inline execution work
- Artifact Store Policy — engram (default), openspec, hybrid, or none modes
- Dependency graph tracking — proposal → specs/design → tasks → apply → verify → archive
- Engram Topic Key format for persistent SDD artifacts across sessions
- Sub-Agent Launch Pattern with skill loading instructions
- Recovery rules for post-compaction state restoration

**Enhanced Engram Protocol:**
- Mandatory `mem_save` triggers (bug fixes, decisions, discoveries, patterns, configs, preferences)
- PROACTIVE memory search on user's first message with project context
- Mandatory session close protocol with structured summary
- Post-compaction recovery protocol
- Two-step artifact recovery (search → get full observation)

**Skills Auto-load:**
- Context detection for framework/library (ai-sdk-5, django-drf, grails-5, nextjs-15, react-19, etc.)
- Testing framework detection (playwright, pytest, spock, vitest)
- Workflow detection (clean-code, conventional-commits, pr-review, tdd, security-first, solid)
- Automatic skill loading BEFORE writing code

**Hard Rules:**
- Never add AI attribution to commits (conventional commits only)
- Never build after changes
- STOP and wait for user response when asking questions
- Verify before agreeing with user claims ("dejame verificar")
- Explain WHY with evidence when user is wrong
- Propose alternatives with tradeoffs
- Verify technical claims before stating them

**Identity Inheritance:**
- SDD orchestrator maintains same personality (Lenny sarcasm OR Gentleman warmth)
- No generic orchestrator voice during SDD flows
- Coaching behavior continues: explain WHY, validate assumptions, challenge weak decisions

### Changed

**CLAUDE.md Structure:**
- Added `<!-- gentle-ai:rules -->` section at top
- Added `<!-- gentle-ai:skills-autoload -->` with detection tables
- Added `<!-- gentle-ai:sdd-orchestrator -->` with full workflow
- Enhanced `<!-- gentle-ai:engram-protocol -->` with proactive search
- Reorganized agent sections with clearer hierarchy
- Added SDD commands reference (/sdd-init, /sdd-new, /sdd-continue, etc.)

**Agent Definitions:**
- Added Expertise section to Gentleman (Angular, React, state management, architecture)
- Added Behavior section to Gentleman (push back, analogies, technical WHY)
- Enhanced Philosophy sections (CONCEPTS > CODE, FOUNDATIONS FIRST, AGAINST IMMEDIACY)

**Skills Organization:**
- Separated SDD workflow skills into dedicated section
- Added auto-load triggers for all skills
- Updated skill descriptions with explicit triggers

### Technical Details

**SDD Workflow:**
```
/sdd-init          → Initialize project context
/sdd-explore       → Explore idea (optional)
/sdd-new <name>    → Start change (explore + propose)
/sdd-continue      → Run next phase (spec/design/tasks)
/sdd-ff            → Fast-forward all planning phases
/sdd-apply         → Implement tasks
/sdd-verify        → Validate implementation
/sdd-archive       → Close and persist
```

**Delegation Modes:**
- `delegate` (async, default) — sub-agent runs in background
- `task` (sync) — only when orchestrator NEEDS result for next action

**Artifact Backends:**
- `engram` — persistent memory (default, recommended)
- `openspec` — file-based artifacts in `openspec/` directory
- `hybrid` — both backends simultaneously (higher token cost)
- `none` — no persistence, inline results only

**Sub-Agent Responsibilities:**
- Read source code, analyze codebase, write specs/designs/tasks
- Implement code, run tests, verify against specs
- Save discoveries/decisions to Engram (`mem_save`)
- Load relevant skills from registry

**Orchestrator Responsibilities:**
- Track DAG state, coordinate phases, ask for approval
- Launch sub-agents with artifact references (topic keys or file paths)
- Synthesize results, show progress summaries
- NEVER read/write source code directly

### Documentation Updates

**README.md:**
- Added SDD workflow to key features
- Added `/sdd-init`, `/sdd-new`, `/sdd-continue` usage examples
- Updated comparison table (OpenCode vs Claude Code)

**QUICKSTART.md:**
- Added "Start a new feature with SDD" workflow example
- Updated directory structure to show SDD skills
- Added 8-phase SDD workflow overview

**COMPARISON.md:**
- No changes (SDD is Claude Code exclusive feature)

**SUMMARY.md:**
- Updated stats: 33+ skills → includes 9 SDD workflow skills

---

## [1.0.0] - 2026-03-24

### Added

**Configuration Files:**
- `CLAUDE.md` — Main configuration with agent definitions and skill reference
- `README.md` — Complete installation and usage documentation
- `QUICKSTART.md` — Fast-track setup guide
- `COMPARISON.md` — Detailed OpenCode vs Claude Code comparison
- `SUMMARY.md` — Overview of the entire setup
- `settings.json` — Claude Code settings (MCP, permissions, agents)
- `install.sh` — Automated installation script
- `.gitignore` — Git ignore rules for sensitive files
- `CHANGELOG.md` — This file

**Agent Prompts:**
- `agents/lenny.md` — Lenny Sanders (Sarcastic CTO, crypto hacker)
- `agents/gentleman.md` — Gentleman (Warm mentor, patient teacher)

**Skills (Migrated from OpenCode):**
- All 33+ skills from OpenCode configuration
- Framework-specific: `ai-sdk-5`, `django-drf`, `grails-5`, `grails-tdd`, `nextjs-15`, `react-19`, `tailwind-4`, `zod-4`, `zustand-5`
- Testing: `tdd`, `playwright`, `pytest`, `spock`, `vitest`
- Code Quality: `clean-code`, `solid`, `security-first`, `typescript`, `conventional-commits`
- Spec-Driven Development: `sdd-init`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`, `sdd-verify`, `sdd-archive`, `sdd-explore`
- Workflow: `chained-pr`, `pr-review`, `skill-creator`, `skill-sync`, `transcript-processor`

**MCP Servers:**
- Engram (persistent memory) — enabled by default
- Context7 (live documentation) — configured but disabled (requires API key)

**Permissions:**
- Read: Allow all, deny `.env`, `credentials.json`, `secrets/**`
- Bash: Allow all, ask on `git commit`, `git push`, `git push --force`, `git rebase`, `git reset --hard`

**Aliases:**
- `lenny` — Launch Claude with Lenny agent
- `gentleman` — Launch Claude with Gentleman agent
- `cl` — Shortcut for `claude`

### Features

**Installation:**
- One-command install via `install.sh`
- Automatic backup of existing configuration
- Skills symlinked from dotfiles (shared with OpenCode)
- Settings merged with existing Engram config
- Global `CLAUDE.md` symlinked to home directory
- Shell aliases auto-created in `.bashrc` and `.zshrc`
- Verification step to ensure everything is set up correctly

**Agents:**
- Lenny Sanders: Sarcastic CTO, brutal honesty, gaming references, Mexican Spanish when prompted
- Gentleman: Warm mentor, never condescending, Rioplatense Spanish when prompted
- Both agents use modern CLI tools (`bat`, `rg`, `fd`, `eza`)
- Both follow SOLID, Clean Code, TDD, Secure by Design principles
- Both stop and wait when asking questions (no over-explaining)

**Skills:**
- 33+ skills covering frameworks, testing, code quality, and workflows
- Fully compatible with OpenCode skills (shared directory)
- Auto-discovered by Claude Code via symlink

**Documentation:**
- 5 comprehensive guides (README, QUICKSTART, COMPARISON, SUMMARY, CHANGELOG)
- Troubleshooting sections in all docs
- Examples and usage patterns for every feature
- Migration guide from OpenCode to Claude Code

### Technical Details

**Config Structure:**
```
claude-code/
├── CLAUDE.md              # Main config (Markdown, unlimited length)
├── settings.json          # Claude settings (JSON)
├── agents/                # Agent prompts (Markdown)
│   ├── lenny.md
│   └── gentleman.md
└── skills/                # 33+ skills (symlinked from OpenCode)
```

**Installation Script (`install.sh`):**
- Checks for Claude Code installation (installs if missing)
- Backs up existing config before making changes
- Merges settings using `jq` (if available)
- Creates symlinks for skills and global config
- Adds shell aliases to `.bashrc` and `.zshrc`
- Verifies installation with detailed checks
- Prints next steps for the user

**Shared Resources:**
- Skills directory: Symlinked, not copied (shared with OpenCode)
- Engram memory: Same SQLite database (`~/.engram/`)
- Agent personas: Same personality, ported prompts

**Differences from OpenCode:**
- Config format: Markdown (`CLAUDE.md`) instead of JSON (`opencode.json`)
- Prompt length: Unlimited (Markdown) vs limited (~2000 chars in JSON)
- Authentication: Native OAuth vs plugin-based
- Settings location: `~/.claude/settings.json` vs `~/.config/opencode/opencode.json`
- Support: Official Anthropic vs community-driven

### Philosophy

This configuration embodies:
- **Code as Art:** Clean, maintainable, expressive
- **Foundations First:** Know the basics before the framework
- **System Thinking:** Understand the whole before the parts
- **Best Idea Wins:** Not rank, not loudness
- **AI as a Tool:** We direct, AI executes
- **Security by Design:** Secure from day one
- **TDD Always:** Test-first for features, bugs, refactors

### Migration Notes

**From OpenCode:**
- All skills are shared (symlinked, not duplicated)
- Engram memory is shared (same database)
- Agent personalities are the same (prompts ported)
- Permissions philosophy is the same (rules ported)
- Both tools can coexist without conflict

**To OpenCode:**
- Configuration is bidirectional
- Skills are shared
- Agents can be used in both tools
- Switch anytime without losing context or memory

### Known Issues

None at this time.

### Compatibility

- **Claude Code:** ✅ Tested and working
- **OpenCode:** ✅ Shared skills and memory
- **Engram:** ✅ Version 0.1.0+
- **Context7:** ⚠️ Not tested (requires API key)

### Contributors

- Initial setup: AI assistant (probably Lenny, because sarcasm)
- Based on OpenCode config by: mrp4sten

---

## Future Enhancements

Planned features for future releases:

- [ ] Add more framework-specific skills (Vue, Angular, Svelte, etc.)
- [ ] Create language-specific agents (Python Expert, Java Guru, etc.)
- [ ] Add project templates with pre-configured `CLAUDE.md`
- [ ] Integrate more MCP servers (GitHub, Jira, Slack, etc.)
- [ ] Create skill bundles for common workflows
- [ ] Add video tutorials and demos
- [ ] Create a skill marketplace browser
- [ ] Add telemetry and usage analytics (opt-in)

---

## Support

For issues, questions, or contributions:

1. Check the [README.md](README.md) for detailed docs
2. Check the [QUICKSTART.md](QUICKSTART.md) for fast setup
3. Check the [TROUBLESHOOTING](README.md#troubleshooting) section
4. Open an issue in your dotfiles repo

---

_"A la verga, this is the most documented config I've ever seen. Good job, loco." — Lenny Sanders_
