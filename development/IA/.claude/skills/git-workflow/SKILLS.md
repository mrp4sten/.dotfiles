---
name: git-workflow
description: Help with git operations, branching strategy, commit preparation, PR descriptions, or resolving conflicts. Use when the user asks about git, wants to commit, stage changes, or write a PR description.
---
 
## Git Workflow Assistant
 
### When Asked to Commit
 
1. Run `git diff HEAD` to inspect what changed
2. Summarize changes in 2-3 bullets
3. Flag anything risky: missing tests, debug code left in, large unrelated change mixed in
4. Propose a conventional commit message
5. Wait for approval before running `git commit`
### When Asked to Write a PR Description
 
Structure:
```
## What
One paragraph: what does this PR do?
 
## Why
One paragraph: what problem does it solve, or what value does it add?
 
## How
Brief explanation of the approach taken.
 
## Testing
How was this verified? Unit tests, manual testing, edge cases covered.
 
## Notes
Anything the reviewer should pay special attention to.
```
 
### When Asked to Resolve a Conflict
 
1. Show both sides of the conflict clearly
2. Explain what each side was trying to do
3. Propose the merged result with reasoning
4. Never silently pick one side without explanation
### Branching Quick Reference
 
| Scenario | Branch name pattern |
|---|---|
| New feature | `feat/<short-name>` |
| Bug fix | `fix/<short-name>` |
| Refactor | `refactor/<short-name>` |
| Chore/infra | `chore/<short-name>` |
| Hotfix to prod | `hotfix/<short-name>` |