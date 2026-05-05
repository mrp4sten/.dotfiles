---
description: Stage, review, and commit changes with a conventional commit message. Prompts before committing.
---

Run `git diff HEAD` and `git status` to see what's changed.

Summarize the changes in 2–3 bullets. Flag anything risky (debug code, unrelated changes, missing tests).

Propose a conventional commit message following the format:
`<type>(<optional scope>): <description>`

Ask for confirmation before running `git add` and `git commit`.

Never run `git push`.