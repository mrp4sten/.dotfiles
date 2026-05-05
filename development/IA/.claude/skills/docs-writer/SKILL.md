---
name: docs-writer
description: Write or improve technical documentation. Use when the user asks to document code, write a README, generate API docs, write a technical spec, or explain how something works for other engineers.
---

## Documentation Writer

### README Template
When writing a project README:
```markdown
# Project Name
One-sentence description of what this is and who it's for.

## What it does
2-3 sentences max. No fluff.

## Requirements
List of dependencies and versions.

## Setup
Step-by-step, copy-pasteable commands.

## Usage
The most common use case shown with a real example.

## Configuration
Table of env vars or config options with defaults and descriptions.

## Development
How to run tests, linter, local dev server.

## Contributing
Keep it brief unless this is a public project.
```

### Code Documentation
When documenting functions:
- Document the **why**, not the **what** (the code already says what)
- Document non-obvious behavior, edge cases, and side effects
- Document public APIs thoroughly; private internals only when complex
- Keep comments current — outdated comments are worse than no comments

### Technical Specs / ADRs
Structure for Architecture Decision Records:
```
## Title
## Status (proposed / accepted / deprecated)
## Context — what problem are we solving?
## Decision — what did we choose?
## Consequences — what are the trade-offs?
```

### Principles
- Write for the next engineer, not yourself-today
- Assume technical competence, not project-specific knowledge
- Include examples — they're worth 10 lines of prose
- Keep it DRY: link to other docs rather than duplicating