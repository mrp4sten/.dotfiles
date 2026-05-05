---
description: Review your own uncommitted or staged changes before pushing, like a self-code-review pass.
---

Run `git diff HEAD` (or `git diff --staged` if changes are staged).

Review the diff as if you were a senior engineer reviewing someone else's PR. Look for:

- 🔴 **Bugs**: logic errors, missing error handling, off-by-one, null dereference
- 🔴 **Security**: hardcoded secrets, unsanitized inputs, missing auth checks
- 🟡 **Code quality**: unclear naming, duplicated logic, overly complex code
- 🟡 **Missing tests**: changed behavior with no test coverage
- 🟢 **Nits**: formatting, naming preferences, minor style

Give specific feedback with file + line references.

End with: overall verdict (good to go / needs work) and the top 1–2 things to fix before committing.