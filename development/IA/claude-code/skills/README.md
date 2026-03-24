# AI Agent Skills

This directory contains **Agent Skills** following the [Agent Skills open standard](https://agentskills.io). Skills provide domain-specific patterns, conventions, and guardrails that help AI coding assistants (Claude Code, OpenCode, Cursor, etc.) understand project-specific requirements.

## What Are Skills?

[Agent Skills](https://agentskills.io) is an open standard format for extending AI agent capabilities with specialized knowledge. Originally developed by Anthropic and released as an open standard, it is now adopted by multiple agent products.

Skills teach AI assistants how to perform specific tasks. When an AI loads a skill, it gains context about:

- Critical rules (what to always/never do)
- Code patterns and conventions
- Project-specific workflows
- References to detailed documentation

## Setup

Run the setup script from your dotfiles to configure skills in any project:

```bash
~/.dotfiles/development/IA/opencode/skill/setup.sh
```

**Interactive mode** (recommended):
- Select target project (current dir, browse, recent projects, or zoxide frecent dirs)
- Choose which AI assistants to configure (Claude, Gemini, Codex, Copilot)
- Automatically detects project structure (monorepo vs single-repo)

**Command-line mode**:
```bash
# Configure all AI assistants in current directory
~/.dotfiles/development/IA/opencode/skill/setup.sh --all

# Configure specific project with specific AI
~/.dotfiles/development/IA/opencode/skill/setup.sh --path ~/projects/my-app --claude

# Show all options
~/.dotfiles/development/IA/opencode/skill/setup.sh --help
```

**Optional dependencies** (graceful fallbacks if not available):
- `gum`: Better interactive menus (install: `pacman -S gum` / `brew install gum`)
- `zoxide`: Suggest frecent directories (install: `pacman -S zoxide` / `brew install zoxide`)

This creates symlinks in your target project:

| Tool | Symlink Created |
|------|-----------------|
| Claude Code / OpenCode | `.claude/skills/ -> dotfiles/skills/` |
| Codex (OpenAI) | `.codex/skills/ -> dotfiles/skills/` |
| Gemini CLI | `.gemini/skills/ -> dotfiles/skills/` |
| GitHub Copilot | `.github/copilot-instructions.md` |

After running setup, restart your AI coding assistant to load the skills.

## How to Use Skills

Skills are automatically discovered by the AI agent. To manually load a skill during a session:

```
Read skills/{skill-name}/SKILL.md
```

## Available Skills

### Generic Skills

Reusable patterns for common technologies:

| Skill | Description |
|-------|-------------|
| `typescript` | Const types, flat interfaces, utility types |
| `react-19` | React 19 patterns, React Compiler |
| `nextjs-15` | App Router, Server Actions, streaming |
| `tailwind-4` | cn() utility, Tailwind 4 patterns |
| `playwright` | Page Object Model, selectors |
| `vitest` | Unit testing, React Testing Library |
| `tdd` | Test-Driven Development workflow |
| `pytest` | Fixtures, mocking, markers |
| `django-drf` | ViewSets, Serializers, Filters |
| `zod-4` | Zod 4 API patterns |
| `zustand-5` | Persist, selectors, slices |
| `ai-sdk-5` | Vercel AI SDK patterns |

### Workflow Skills

Project workflow and automation patterns:

| Skill | Description |
|-------|-------------|
| `pr-review` | Reviews GitHub PRs and leaves comments |
| `chained-pr` | Creates stacked/chained GitHub PRs |
| `jira-epic` | Creates Jira epics for large features |
| `jira-task` | Creates Jira tasks/tickets |
| `notion-prd` | Creates PRDs in Notion |
| `notion-rfc` | Creates RFCs for technical design |
| `notion-adr` | Creates Architecture Decision Records |
| `notion-product-brain` | Manages product ideas/features |
| `notion-to-jira` | Syncs Notion RFCs to Jira |
| `transcript-processor` | Processes meeting transcripts |

### Spec-Driven Development (SDD) Skills

Multi-phase workflow for structured development:

| Skill | Description |
|-------|-------------|
| `sdd-init` | Bootstrap SDD in a project |
| `sdd-explore` | Investigate ideas before committing |
| `sdd-propose` | Create change proposals |
| `sdd-spec` | Write specifications with scenarios |
| `sdd-design` | Create technical design docs |
| `sdd-tasks` | Break down implementation tasks |
| `sdd-apply` | Implement tasks following specs |
| `sdd-verify` | Validate implementation vs specs |
| `sdd-archive` | Archive completed changes |

### Meta Skills

| Skill | Description |
|-------|-------------|
| `skill-creator` | Create new AI agent skills |
| `skill-sync` | Sync skill metadata to AGENTS.md Auto-invoke sections |

## Directory Structure

```
skills/
├── {skill-name}/
│   ├── SKILL.md              # Required - main instrunsction and metadata
│   ├── scripts/              # Optional - executable code
│   ├── assets/               # Optional - templates, schemas, resources
│   └── references/           # Optional - links to local docs
└── README.md                 # This file
```

## Why Auto-invoke Sections?

**Problem**: AI assistants (Claude, Gemini, etc.) don't reliably auto-invoke skills even when the `Trigger:` in the skill description matches the user's request. They treat skill suggestions as "background noise" and barrel ahead with their default approach.

**Solution**: The `AGENTS.md` files in each directory contain an **Auto-invoke Skills** section that explicitly commands the AI: "When performing X action, ALWAYS invoke Y skill FIRST." This is a [known workaround](https://scottspence.com/posts/claude-code-skills-dont-auto-activate) that forces the AI to load skills.

**Automation**: Instead of manually maintaining these sections, run `skill-sync` after creating or modifying a skill:

```bash
~/.dotfiles/development/IA/opencode/skill/sync.sh
```

**Interactive mode**:
- Select target project (current dir, browse, recent projects, or zoxide frecent dirs)
- Automatically detects project structure and available AGENTS.md files
- Updates all Auto-invoke sections across the project

**Command-line mode**:
```bash
# Sync specific project
~/.dotfiles/development/IA/opencode/skill/sync.sh --path ~/projects/my-app

# Preview changes without applying
~/.dotfiles/development/IA/opencode/skill/sync.sh --dry-run

# Sync only specific scope
~/.dotfiles/development/IA/opencode/skill/sync.sh --scope root
```

This reads `metadata.scope` and `metadata.auto_invoke` from each `SKILL.md` and generates the Auto-invoke tables in the corresponding `AGENTS.md` files.

## Creating New Skills

Use the `skill-creator` skill for guidance:

```
Read skills/skill-creator/SKILL.md
```

### Quick Checklist

1. Create directory: `skills/{skill-name}/`
2. Add `SKILL.md` with required frontmatter
3. Add `metadata.scope` and `metadata.auto_invoke` fields
4. Keep content concise (under 500 lines)
5. Reference existing docs instead of duplicating
6. Run `./skills/skill-sync/assets/sync.sh` to update AGENTS.md
7. Add to `AGENTS.md` skills table (if not auto-generated)

## Design Principles

- **Concise**: Only include what AI doesn't already know
- **Progressive disclosure**: Point to detailed docs, don't duplicate
- **Critical rules first**: Lead with ALWAYS/NEVER patterns
- **Minimal examples**: Show patterns, not tutorials

## Resources

- [Agent Skills Standard](https://agentskills.io) - Open standard specification
- [Agent Skills GitHub](https://github.com/anthropics/skills) - Example skills
- [Claude Code Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) - Skill authoring guide
