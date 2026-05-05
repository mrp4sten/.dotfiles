---
name: refactoring
description: Improve the internal structure of code without changing its behavior. Use when the user asks to clean up, refactor, simplify, or reduce complexity in existing code.
---

## Refactoring Process

### Guiding Principle
Refactoring changes structure, not behavior. Every step must leave the code working.
Never refactor and fix bugs in the same commit.

### Step 1 — Assess Before Touching
- Do tests exist? If not, write characterization tests first to capture current behavior.
- What's the scope? One function, one file, or a module?
- What's the actual problem? (duplicated logic, god class, deep nesting, long method, etc.)

### Step 2 — Common Refactoring Moves

**Extract Method/Function** — when a block of code has a clear single purpose
**Rename** — when a name doesn't reflect what the thing actually does
**Inline** — when a helper is so trivial it adds more noise than clarity
**Replace Magic Number/String** — extract to a named constant
**Introduce Parameter Object** — when a function takes 4+ related args
**Decompose Conditional** — when `if` chains are hard to read, extract to named predicates
**Remove Dead Code** — delete it; git history is the safety net
**Flatten Nesting** — early returns, guard clauses, extract to helper

### Step 3 — Do It Incrementally
- One refactoring move at a time, verified with tests
- Commit after each working step
- Don't try to do everything at once

### Step 4 — Output
When suggesting refactoring:
1. Show the before code
2. State what problem it has
3. Show the after code
4. Explain what changed and why it's better

Don't rewrite everything — prefer targeted changes with clear reasoning.