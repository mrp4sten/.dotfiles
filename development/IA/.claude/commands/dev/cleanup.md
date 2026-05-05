---
description: Find dead code, unused imports, TODO comments, and console/debug statements left in the codebase.
---

Scan the codebase for things that shouldn't ship:

1. **Debug statements**: `console.log`, `print(`, `println!`, `System.out.print`, `debugger`, `binding.pry`, `dd(`, `var_dump(`
2. **TODO / FIXME / HACK / XXX comments**: `grep -rn "TODO\|FIXME\|HACK\|XXX" --include="*.{js,ts,py,java,rs,go}" .`
3. **Commented-out code blocks**: large blocks of `//` or `#` commented code (not docstrings)
4. **Unused imports**: flag files that import things never referenced (language-dependent)

Present findings grouped by category with file + line number.

Don't delete anything automatically. Ask: "Want me to remove these?"