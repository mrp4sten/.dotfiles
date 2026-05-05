---
description: Create a CLAUDE.md for the current project based on the actual codebase. Run once when starting work on a new project.
---

Explore the project to understand it:
1. Read `README.md` if present
2. Check the dependency manifest (`package.json`, `pom.xml`, `pyproject.toml`, etc.)
3. Look at the top-level directory structure
4. Run `git log --oneline -10` to understand recent work

Then generate a project-level `CLAUDE.md` at the project root with:

```markdown
# <Project Name>

## What This Is
[One paragraph description]

## Stack
[Languages, frameworks, key libraries]

## Project Structure
[Key directories and what they contain]

## How to Run
[Dev server, build, test commands]

## Code Conventions
[Any patterns you observed: naming, file organization, style]

## Key Files
[Important entry points, config files worth knowing]

## Rules for This Project
[Anything specific: don't touch X, always do Y, migration strategy, etc.]
```

Save the file and confirm. Tell me if you need me to fill in anything you couldn't infer from the code.