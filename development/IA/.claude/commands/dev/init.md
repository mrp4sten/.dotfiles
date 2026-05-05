---
description: Onboard into a new or unfamiliar codebase. Reads structure, deps, and config to build context fast.
---

Explore this project from scratch. Run the following to build context:

1. `ls -la` — see top-level structure
2. `cat README.md` (or README.rst / README.txt if present)
3. Check for: `package.json`, `pom.xml`, `build.gradle`, `Cargo.toml`, `pyproject.toml`, `go.mod` — read whichever exists to understand the stack and dependencies
4. `git log --oneline -20` — understand recent activity
5. Look for a `src/` or `app/` or `lib/` directory and read its top-level structure
6. Check for `.env.example` or any config files
7. Look for a `docker-compose.yml` or `Makefile` for dev commands

After reading, produce a summary:
- **Stack**: languages, frameworks, key dependencies
- **Structure**: how the codebase is organized
- **Entry points**: where the app starts
- **How to run**: dev server, tests, build
- **Notable things**: anything that looks non-standard or worth knowing

Then ask: "What do you want to work on?"