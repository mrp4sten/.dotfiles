---
description: Summarize what you did since yesterday based on git log, for a standup update.
---

Run `git log --since="yesterday" --oneline --author="$(git config user.name)"` to get recent commits.

Also run `git diff --stat HEAD~5..HEAD` for a sense of scope.

Write a brief standup update in this format:

**Yesterday**
- [bullet points derived from commit messages, plain English, no jargon]

**Today**
- [ask the user what they're planning, or leave as a placeholder]

**Blockers**
- None (or ask the user)

Keep it under 5 bullets total. Translate commit messages into plain human language.