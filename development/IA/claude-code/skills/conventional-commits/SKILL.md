---
name: conventional-commits
description: >
  Conventional Commits specification and Keep a Changelog best practices.
  Trigger: When creating commits or updating CHANGELOG.md.
license: Apache-2.0
metadata:
  author: mrp4sten
  version: "1.0"
  scope: [root]
  auto_invoke:
    - "Creating git commits"
    - "Updating CHANGELOG.md"
    - "Preparing releases"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

## Conventional Commits

A specification for structured, semantic commit messages that enable automated tooling (changelog generation, semantic versioning).

**Format:**
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

---

## Commit Types

| Type | Description | Bumps Version | Example |
|------|-------------|---------------|---------|
| `feat` | New feature | MINOR (0.x.0) | `feat: add user authentication` |
| `fix` | Bug fix | PATCH (0.0.x) | `fix: resolve login timeout` |
| `docs` | Documentation only | - | `docs: update API guide` |
| `style` | Code style (no logic change) | - | `style: format with prettier` |
| `refactor` | Code refactoring | - | `refactor: extract validation logic` |
| `perf` | Performance improvement | PATCH | `perf: optimize database queries` |
| `test` | Adding/updating tests | - | `test: add user service tests` |
| `build` | Build system changes | - | `build: update webpack config` |
| `ci` | CI/CD changes | - | `ci: add GitHub Actions workflow` |
| `chore` | Maintenance tasks | - | `chore: update dependencies` |
| `revert` | Revert previous commit | - | `revert: feat: add user auth` |

---

## Scopes (Optional)

Scopes provide context about what part of the codebase is affected.

**Examples:**
- `feat(api): add user endpoint`
- `fix(ui): resolve button alignment`
- `docs(readme): update installation steps`
- `refactor(auth): simplify token validation`

**Common scopes:**
- Component names: `(header)`, `(sidebar)`, `(login)`
- Layers: `(api)`, `(ui)`, `(database)`, `(auth)`
- Features: `(payments)`, `(notifications)`, `(reports)`

---

## Commit Message Format

### Structure

```
<type>[scope]: <short summary in imperative mood>
<blank line>
[optional body providing context and motivation]
<blank line>
[optional footer: Breaking changes, issue references]
```

### Rules

1. **Subject line** (first line):
   - Max 72 characters
   - Imperative mood: "add feature" not "added feature"
   - No period at the end
   - Lowercase after colon

2. **Body** (optional):
   - Explain WHAT and WHY, not HOW
   - Wrap at 72 characters
   - Separated from subject by blank line

3. **Footer** (optional):
   - Breaking changes: `BREAKING CHANGE: description`
   - Issue references: `Closes #123`, `Refs #456`

---

## Examples

### Simple Feature

```
feat: add dark mode toggle

Allows users to switch between light and dark themes.
Preference is saved in localStorage.
```

### Bug Fix with Issue Reference

```
fix: resolve login timeout on slow connections

Increased timeout from 5s to 30s and added retry logic
with exponential backoff.

Closes #234
```

### Breaking Change

```
feat(api): redesign user authentication

Migrate from session-based to JWT authentication.
All existing sessions will be invalidated.

BREAKING CHANGE: Session endpoints (/login, /logout) removed.
Use /auth/token endpoint instead.

Refs #456
```

### Refactoring

```
refactor(payments): extract Stripe integration

Moved Stripe-specific code to separate service class
to improve testability and enable future payment providers.
```

### Documentation Update

```
docs: add API rate limiting guide

Explains rate limit headers and best practices for
handling 429 responses.
```

### Revert

```
revert: feat: add user authentication

This reverts commit abc123def456.

Reason: Introduced security vulnerability (CVE-2024-1234).
Will re-implement with proper validation.
```

---

## Keep a Changelog

Based on https://keepachangelog.com/

### CHANGELOG.md Structure

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New features not yet released

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security fixes

## [1.2.0] - 2024-02-15

### Added
- User profile page with avatar upload
- Dark mode toggle in settings

### Fixed
- Login timeout on slow connections (#234)

## [1.1.0] - 2024-01-20

### Added
- Email notifications for new messages
- Password reset functionality

### Changed
- Redesigned dashboard layout for better UX

### Security
- Updated bcrypt to v5.1.1 (CVE-2024-1234)

## [1.0.0] - 2024-01-01

### Added
- Initial release
- User authentication (login/register)
- Basic CRUD operations for users

[Unreleased]: https://github.com/user/repo/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/user/repo/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/user/repo/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/user/repo/releases/tag/v1.0.0
```

---

## Changelog Categories

| Category | When to Use | Semantic Version Impact |
|----------|-------------|-------------------------|
| **Added** | New features | MINOR (0.x.0) |
| **Changed** | Changes in existing functionality | MINOR or MAJOR |
| **Deprecated** | Soon-to-be removed features | MINOR |
| **Removed** | Removed features | MAJOR (x.0.0) |
| **Fixed** | Bug fixes | PATCH (0.0.x) |
| **Security** | Security fixes | PATCH |

---

## Semantic Versioning (SemVer)

Format: `MAJOR.MINOR.PATCH` (e.g., `2.3.1`)

- **MAJOR (x.0.0):** Incompatible API changes (breaking changes)
- **MINOR (0.x.0):** New features (backwards-compatible)
- **PATCH (0.0.x):** Bug fixes (backwards-compatible)

### Examples

```
1.0.0 → 1.0.1  (fix: bug)
1.0.1 → 1.1.0  (feat: new feature)
1.1.0 → 2.0.0  (BREAKING CHANGE: API redesign)
```

### Pre-release Versions

```
1.0.0-alpha.1   (Early testing)
1.0.0-beta.2    (Feature-complete, testing)
1.0.0-rc.1      (Release candidate)
1.0.0           (Stable release)
```

---

## Workflow

### 1. Make Changes

```bash
# Create feature branch
git checkout -b feat/dark-mode

# Make changes
# ...

# Stage changes
git add .
```

### 2. Write Conventional Commit

```bash
git commit -m "feat: add dark mode toggle

Allows users to switch between light and dark themes.
Preference is saved in localStorage.

Closes #123"
```

### 3. Update Changelog (Before Release)

Edit `CHANGELOG.md`:

```markdown
## [Unreleased]

### Added
- Dark mode toggle in settings (#123)
```

### 4. Create Release

```bash
# Tag with semantic version
git tag -a v1.2.0 -m "Release v1.2.0"

# Update CHANGELOG.md (move Unreleased to version)
## [1.2.0] - 2024-02-15

### Added
- Dark mode toggle in settings (#123)

## [Unreleased]
(empty)

# Commit changelog
git add CHANGELOG.md
git commit -m "chore: release v1.2.0"

# Push tag
git push origin v1.2.0
```

---

## Automated Tools

### Commitlint (Enforce Conventional Commits)

```bash
# Install
npm install --save-dev @commitlint/cli @commitlint/config-conventional

# Configure (.commitlintrc.json)
{
  "extends": ["@commitlint/config-conventional"]
}

# Add to husky pre-commit hook
npx husky add .husky/commit-msg 'npx commitlint --edit $1'
```

### Standard Version (Auto-generate Changelog)

```bash
# Install
npm install --save-dev standard-version

# Run (bumps version, updates CHANGELOG, creates git tag)
npx standard-version

# First release
npx standard-version --first-release

# Pre-release
npx standard-version --prerelease alpha
```

### Semantic Release (Fully Automated)

```bash
# Install
npm install --save-dev semantic-release

# Configure (.releaserc.json)
{
  "branches": ["main"],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    "@semantic-release/npm",
    "@semantic-release/github",
    "@semantic-release/git"
  ]
}

# CI/CD integration (GitHub Actions)
# Automatically creates releases on push to main
```

---

## Bad Commit Examples (Avoid These)

```bash
# ❌ Too vague
git commit -m "fix stuff"
git commit -m "update"
git commit -m "changes"

# ❌ No type
git commit -m "add dark mode"

# ❌ Wrong tense
git commit -m "feat: added dark mode"
git commit -m "fix: fixed bug"

# ❌ Too long subject
git commit -m "feat: add dark mode toggle button to the settings page that allows users to switch"

# ❌ No description for breaking change
git commit -m "feat: redesign API"
```

---

## Good Commit Examples

```bash
# ✅ Simple feature
git commit -m "feat: add dark mode toggle"

# ✅ Bug fix with issue reference
git commit -m "fix: resolve login timeout

Increased timeout from 5s to 30s.

Closes #234"

# ✅ Breaking change
git commit -m "feat(api): redesign authentication

BREAKING CHANGE: Session endpoints removed.
Use /auth/token instead."

# ✅ Refactoring
git commit -m "refactor: extract validation logic

Moved user validation to dedicated class
for better testability."

# ✅ Documentation
git commit -m "docs: add API rate limiting guide"
```

---

## Commit Message Template

Create `.gitmessage` in your home directory:

```
# <type>[optional scope]: <description>
# |<----  Using a Maximum Of 50 Characters  ---->|

# Explain why this change is being made
# |<----   Try To Limit Each Line to a Maximum Of 72 Characters   ---->|

# Provide links or keys to any relevant tickets, articles or other resources
# Example: Closes #23

# --- COMMIT END ---
# Type can be:
#   feat     (new feature)
#   fix      (bug fix)
#   refactor (refactoring code)
#   style    (formatting, missing semicolons, etc.)
#   docs     (changes to documentation)
#   test     (adding or refactoring tests)
#   chore    (updating build tasks, package manager configs, etc.)
```

Configure git to use it:

```bash
git config --global commit.template ~/.gitmessage
```

---

## Resources

- **Conventional Commits:** https://www.conventionalcommits.org/
- **Keep a Changelog:** https://keepachangelog.com/
- **Semantic Versioning:** https://semver.org/
- **Commitlint:** https://commitlint.js.org/
- **Standard Version:** https://github.com/conventional-changelog/standard-version
