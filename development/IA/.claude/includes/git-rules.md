# Git Rules

## Commit Messages
- Format: `<type>(<optional scope>): <description>`
- Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `perf`, `ci`
- Description: imperative mood, lowercase, no period at end
- Max 72 characters on subject line
- Example: `feat(auth): add JWT refresh token support`

## Branching
- `main` / `master` — never commit directly
- Feature branches: `feat/<short-description>`
- Fix branches: `fix/<short-description>`
- Always branch from an up-to-date base

## Workflow
- Stage selectively — never `git add .` on large changes without reviewing first
- Never amend commits that have already been pushed
- Always pull --rebase when updating a feature branch from main
- Stash uncommitted changes before switching context

## What Never Goes in a Commit
- Secrets, API keys, tokens
- `.env` files with real values
- Compiled artifacts that belong in `.gitignore`
- Large binary files without LFS