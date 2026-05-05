---
name: debugging
description: Systematically investigate and fix bugs, errors, or unexpected behavior. Use when the user reports a bug, shares an error/stacktrace, or asks why something isn't working.
---
 
## Debugging Process
 
### Step 1 — Reproduce First
Before theorizing, confirm the bug is reproducible.
- What is the exact input/action that triggers it?
- Does it happen consistently or intermittently?
- What environment? (OS, runtime version, config)
### Step 2 — Read the Error
If there's a stacktrace or error message:
- Read it top to bottom — the root cause is usually at the bottom
- Identify the exact file, line, and function where the error originates
- Distinguish between the throw site and the propagation chain
### Step 3 — Form Hypotheses (max 3)
List the most likely causes ranked by probability. For each:
- What assumption would have to be wrong for this to be the cause?
- What's the fastest way to confirm or rule it out?
### Step 4 — Investigate Systematically
- Add targeted logging or print statements around the suspect area
- Use binary search: comment out half the code to isolate
- Check recent changes — `git log -10 --oneline`, `git diff HEAD~1`
- Verify inputs at every layer — don't assume upstream data is correct
### Step 5 — Fix & Verify
- Fix the root cause, not the symptom
- Confirm the fix resolves the original issue
- Check for related code paths that might have the same bug
- Add a regression test if the bug had no test coverage
### Common Traps
- Off-by-one errors in loops or slices
- Null/undefined handling missing at boundary
- State mutation where immutability was assumed
- Race condition in async code
- Config or env var missing in a specific environment