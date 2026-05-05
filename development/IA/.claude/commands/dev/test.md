---
description: Run the test suite, interpret results, and report failures clearly. Pass a file or module as $ARGUMENTS to run targeted tests.
---

Detect the test runner by checking:
- `package.json` scripts for `test`, `jest`, `vitest`, `mocha`
- `pom.xml` / `build.gradle` for Maven/Gradle
- `pyproject.toml` / `pytest.ini` for pytest
- `Cargo.toml` for `cargo test`
- `Makefile` for a `test` target

Run the tests. If $ARGUMENTS is provided, scope to that file or module.

After running:
- Report: total passed / failed / skipped
- For each failure: show the test name, what was expected vs what happened, and which file/line
- Suggest a likely cause for each failure (don't fix yet — just diagnose)

Ask: "Want me to fix these?"