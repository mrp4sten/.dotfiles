---
name: code-review
description: Perform a structured code review. Use when the user asks to review code, check a PR, audit a file, or validate an implementation against best practices.
---
 
## Code Review Process
 
### Step 1 — Understand Context
Read the code in full before commenting. Understand what it's trying to do.
 
### Step 2 — Review Checklist
 
**Correctness**
- Does the logic do what the name/comment says?
- Are edge cases handled? (nulls, empty collections, off-by-one)
- Are errors caught and handled meaningfully?
**Design**
- Is the abstraction appropriate — not too thin, not over-engineered?
- Are responsibilities clearly separated?
- Is there unnecessary coupling between modules?
**Readability**
- Are names (variables, functions, classes) intention-revealing?
- Is the code self-documenting, or does it rely on stale comments?
- Is complex logic explained with a comment or broken into named steps?
**Security**
- Are inputs validated/sanitized before use?
- Are secrets or credentials never hardcoded?
- Is authorization checked, not just authentication?
**Performance** (flag only if clearly problematic)
- N+1 queries or obvious algorithmic inefficiencies?
- Unbounded loops or memory allocations?
### Step 3 — Output Format
 
Group findings by severity:
 
- 🔴 **Blocker** — must fix before merge (bugs, security holes, data loss risk)
- 🟡 **Suggestion** — worth fixing, improves quality but not critical
- 🟢 **Nit** — minor style or naming preference, low priority
For each finding: state the issue, why it matters, and suggest a fix.
End with a summary: overall assessment and the 1-2 most important things to address.