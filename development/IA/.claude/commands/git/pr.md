---
description: Generate a pull request description based on the current branch diff against main.
---

Run `git log main..HEAD --oneline` and `git diff main..HEAD` to understand what this branch does.

Write a PR description in this format:

```
## What
One paragraph: what does this PR do?

## Why
One paragraph: what problem does it solve?

## How
Brief explanation of the approach taken.

## Testing
How was this verified? Unit tests, manual steps, edge cases.

## Notes
Anything the reviewer should pay attention to.
```

Keep it factual and concise. Don't invent things not in the diff.