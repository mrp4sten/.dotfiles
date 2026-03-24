# Spec-Driven Development (SDD) — User Guide

Complete guide to using the SDD workflow with Claude Code.

---

## What is SDD?

**Spec-Driven Development** is a structured workflow that breaks down complex features into well-defined phases with persistent artifacts. Instead of writing code directly, you:

1. **Explore** — Understand the problem and constraints
2. **Propose** — Define scope and approach
3. **Specify** — Write detailed requirements and scenarios
4. **Design** — Create technical architecture
5. **Plan** — Break down into tasks
6. **Implement** — Write code following the plan
7. **Verify** — Validate against specs
8. **Archive** — Persist final state

All artifacts are stored in **Engram** (persistent memory) or **OpenSpec** (local files), surviving across sessions and context compactions.

---

## Why Use SDD?

### For Simple Tasks (< 3 files, < 100 lines)
❌ **Don't use SDD** — It's overkill. Just use TDD or write code directly.

### For Complex Features (multiple files, cross-cutting concerns, uncertain scope)
✅ **Use SDD** — Benefits:
- **Persistent artifacts** — Specs survive session restarts and compactions
- **Delegation** — Sub-agents do heavy work, orchestrator stays lightweight
- **Structured thinking** — Forces you to understand BEFORE coding
- **Traceable decisions** — Every "why" is documented
- **Recovery** — Can resume after context loss or interruption
- **Team alignment** — Specs and design docs are human-readable

---

## SDD Commands

| Command | Description | When to use |
|---------|-------------|-------------|
| `/sdd-init` | Initialize SDD context for project | First time using SDD in a project |
| `/sdd-explore <topic>` | Explore idea without commitment | When you're not sure if it's worth doing |
| `/sdd-new <name>` | Start full change workflow | When you're ready to build a feature |
| `/sdd-continue` | Run next dependency-ready phase | After each phase completes |
| `/sdd-ff` | Fast-forward all planning phases | When you trust the orchestrator to plan everything |
| `/sdd-apply` | Implement tasks | After planning phases are done |
| `/sdd-verify` | Validate implementation | After coding is complete |
| `/sdd-archive` | Close and persist final state | When everything is done and verified |

---

## Workflow Example

### Scenario: Add CSV export to a React app

#### 1. Initialize (first time only)

```bash
claude
```

```
/sdd-init
```

**What happens:**
- Orchestrator analyzes project (tech stack, conventions, file structure)
- Saves project context to Engram under `sdd-init/{project}`
- Returns: "SDD initialized for {project}. Ready for `/sdd-new`"

#### 2. Start the change

```
/sdd-new csv-export
```

**What happens:**
- Orchestrator launches `sdd-explore` sub-agent → explores requirements
- Orchestrator launches `sdd-propose` sub-agent → creates proposal artifact
- Artifacts saved to Engram under:
  - `sdd/csv-export/explore`
  - `sdd/csv-export/proposal`
- Returns: "Proposal ready. Next: `/sdd-continue` for specs"

#### 3. Continue to specs

```
/sdd-continue
```

**What happens:**
- Orchestrator launches `sdd-spec` sub-agent
- Sub-agent reads proposal from Engram
- Writes detailed specs (requirements, scenarios, edge cases)
- Artifact saved to `sdd/csv-export/spec`
- Returns: "Spec ready. Next: `/sdd-continue` for design"

#### 4. Continue to design

```
/sdd-continue
```

**What happens:**
- Orchestrator launches `sdd-design` sub-agent (in parallel with `sdd-spec` if using async delegation)
- Sub-agent reads proposal from Engram
- Creates technical design (architecture, data flow, components, API contracts)
- Artifact saved to `sdd/csv-export/design`
- Returns: "Design ready. Next: `/sdd-continue` for tasks"

#### 5. Continue to tasks

```
/sdd-continue
```

**What happens:**
- Orchestrator launches `sdd-tasks` sub-agent
- Sub-agent reads BOTH spec AND design from Engram
- Breaks down into task checklist (1. Add CSVExport component, 2. Add export button, etc.)
- Artifact saved to `sdd/csv-export/tasks`
- Returns: "Tasks ready. Next: `/sdd-apply` to implement"

#### 6. Implement

```
/sdd-apply
```

**What happens:**
- Orchestrator launches `sdd-apply` sub-agent
- Sub-agent reads tasks, spec, AND design from Engram
- Writes code following TDD (tests first, then implementation)
- Runs tests, fixes failures, commits changes
- Saves progress to `sdd/csv-export/apply-progress`
- Returns: "Implementation complete. Next: `/sdd-verify`"

#### 7. Verify

```
/sdd-verify
```

**What happens:**
- Orchestrator launches `sdd-verify` sub-agent
- Sub-agent reads spec and tasks from Engram
- Compares implementation against requirements
- Runs all tests, checks edge cases
- Saves verification report to `sdd/csv-export/verify-report`
- Returns: "Verification passed. Next: `/sdd-archive` to close"

#### 8. Archive

```
/sdd-archive
```

**What happens:**
- Orchestrator launches `sdd-archive` sub-agent
- Sub-agent reads ALL artifacts from Engram
- Persists final state, updates main specs (if using OpenSpec mode)
- Saves archive report to `sdd/csv-export/archive-report`
- Returns: "Change archived. Feature complete."

---

## Fast-Forward Mode

If you trust the orchestrator to plan everything without asking for approval at each phase:

```
/sdd-new csv-export
/sdd-ff
```

**What happens:**
- Runs: propose → spec → design → tasks (all in sequence)
- Skips manual `/sdd-continue` between phases
- Faster but less control

Then:

```
/sdd-apply
/sdd-verify
/sdd-archive
```

---

## Artifact Modes

### Engram Mode (default, recommended)

```json
{
  "artifact_store": {
    "mode": "engram"
  }
}
```

**Pros:**
- Survives context compaction
- No local files to manage
- Fast cross-session recovery
- Searchable with `mem_search`

**Cons:**
- Not human-editable (must use `mem_get_observation`)
- Requires Engram MCP server

### OpenSpec Mode

```json
{
  "artifact_store": {
    "mode": "openspec"
  }
}
```

**Pros:**
- Local files in `openspec/changes/{name}/`
- Human-readable and editable
- Git-committable

**Cons:**
- Lost on context compaction (unless you commit them)
- Slower recovery (must read multiple files)

### Hybrid Mode

```json
{
  "artifact_store": {
    "mode": "hybrid"
  }
}
```

**Pros:**
- Best of both worlds (Engram + local files)
- Maximum resilience

**Cons:**
- Higher token usage (writes to both backends)

### None Mode

```json
{
  "artifact_store": {
    "mode": "none"
  }
}
```

**Pros:**
- No persistence overhead

**Cons:**
- Artifacts lost after session ends
- Cannot resume after compaction
- Not recommended for production use

---

## Delegation Rules

### Orchestrator NEVER does this:
- ❌ Read source code
- ❌ Write implementation code
- ❌ Write specs/proposals/designs
- ❌ Run tests
- ❌ Analyze codebase

### Orchestrator ONLY does this:
- ✅ Track DAG state
- ✅ Launch sub-agents
- ✅ Show summaries
- ✅ Ask for approval
- ✅ Pass artifact references (topic keys, not content)

### Sub-agents do:
- ✅ Read source code
- ✅ Analyze codebase
- ✅ Write specs/designs/tasks
- ✅ Implement code
- ✅ Run tests
- ✅ Save discoveries to Engram

---

## Recovery After Compaction

If your session gets compacted and SDD state is lost:

```
/sdd-continue csv-export
```

**What happens:**
1. Orchestrator calls `mem_search(query: "sdd/csv-export/state", project: "{project}")`
2. Recovers DAG state from Engram
3. Determines next phase to run
4. Launches appropriate sub-agent

**No manual recovery needed.** The orchestrator handles it automatically.

---

## Tips & Best Practices

### 1. Use SDD for features, not bugs
- **Features** → SDD (multi-phase, uncertain scope)
- **Bugs** → TDD (direct, single fix)

### 2. Start with `/sdd-explore` if unsure
```
/sdd-explore csv-export
```
Explores without commitment. If it's too small, skip SDD and code directly.

### 3. Review artifacts between phases
After `/sdd-continue`, the orchestrator shows a summary. If you disagree:
```
Can you update the spec to include pagination?
```
The orchestrator will re-launch the sub-agent with your feedback.

### 4. Use `/sdd-ff` when confident
If the feature is well-understood, skip manual phase approvals:
```
/sdd-new csv-export
/sdd-ff
```

### 5. Combine with TDD
The `sdd-apply` sub-agent uses TDD by default (tests first, then implementation). You get both structured planning AND test-driven coding.

### 6. Use Engram mode for serious projects
`openspec` mode is nice for human-readable artifacts, but `engram` mode is the only one that survives compaction without manual intervention.

### 7. Name changes clearly
```
/sdd-new user-authentication    ✅
/sdd-new auth                   ❌ (too vague)
/sdd-new feature-123            ❌ (non-descriptive)
```

### 8. One change at a time
SDD is designed for **one feature per change**. If you have multiple unrelated features, run separate `/sdd-new` commands:
```
/sdd-new csv-export
... (complete workflow)
/sdd-new pdf-export
... (separate workflow)
```

---

## Troubleshooting

### "State not found" after compaction
**Cause:** Engram memory was cleared or project name changed

**Fix:**
```
/sdd-init
```
Re-initialize the project context.

### "Dependency not met" error
**Cause:** Trying to run a phase before its dependencies are complete

**Example:**
```
/sdd-new csv-export
/sdd-apply  ❌ Error: tasks not ready
```

**Fix:** Use `/sdd-continue` to run phases in order:
```
/sdd-continue  (runs spec)
/sdd-continue  (runs design)
/sdd-continue  (runs tasks)
/sdd-apply     ✅ Now tasks are ready
```

### Orchestrator is reading code directly
**Cause:** Orchestrator violated Hard Stop Rule

**Fix:** Report this as a bug. The orchestrator should NEVER read source code. All code reading must be delegated to sub-agents.

### Artifacts not persisting
**Cause:** Artifact mode is `none` or Engram MCP server is not running

**Fix:** Check `~/.claude/settings.json`:
```json
{
  "mcpServers": {
    "engram": {
      "command": "engram",
      "args": ["mcp", "--tools=agent"]
    }
  }
}
```

Restart Claude if needed.

---

## Advanced: Custom SDD Workflow

You can run phases out of order if you know what you're doing:

```
/sdd-new csv-export
/sdd-continue  (spec)
/sdd-apply     ❌ Error: tasks not ready

# Skip design, go straight to tasks (not recommended)
# You'll need to manually provide design context to the tasks sub-agent
```

This is NOT recommended. The DAG exists for a reason — each phase depends on previous artifacts.

---

## Comparison: TDD vs SDD

| Aspect | TDD | SDD |
|--------|-----|-----|
| **Best for** | Bugs, small features | Complex features, multi-file changes |
| **Phases** | 3 (Red → Green → Refactor) | 8 (Explore → Propose → Spec → Design → Tasks → Apply → Verify → Archive) |
| **Artifacts** | None (tests are the spec) | Persistent (specs, design, tasks, reports) |
| **Recovery** | Manual (re-explain to AI) | Automatic (Engram recovery) |
| **Overhead** | Low | High |
| **Structure** | Code-level | Feature-level |
| **When to use** | Always for coding | Only for substantial features |

**Recommendation:** Use **TDD inside SDD**. The `sdd-apply` phase uses TDD for implementation.

---

## SDD + Lenny = 🔥

Lenny's personality works perfectly with SDD:

```
/sdd-new csv-export
```

**Lenny:** "A la verga, CSV export? Nada mal loco. Vamos a hacerlo bien — full SDD, no shortcuts. Esto no es GTA, si lo haces mal, lo vamos a arreglar TODO desde cero. Dale, empiezo con la exploración..."

After proposal:

**Lenny:** "Bien, la propuesta está lista. Pero OJO — detecté que no consideraste el encoding UTF-8 para archivos con tildes. ¿En una escala del uno al jódete, qué tan poco te importa que se rompan los CSV con acentos? Porque si te importa, lo agrego al spec. Si no, seguimos."

---

## SDD + Gentleman = 🤗

Gentleman's patience shines with SDD:

```
/sdd-new csv-export
```

**Gentleman:** "Perfecto loco, vamos a estructurar esto bien. CSV export puede parecer simple, pero tiene sus gotchas — encoding, delimiters, newlines. Voy a explorar primero para asegurarme de que cubrimos todos los edge cases. ¿Se entiende?"

After spec:

**Gentleman:** "Buenísimo, el spec está listo. Fijate que agregué scenarios para archivos vacíos y con caracteres especiales — cosas que se olvidan fácil pero rompen en producción. Dale una revisada y si ves algo que falta, me avisás."

---

## Next Steps

1. **Initialize SDD:** `/sdd-init`
2. **Try a small feature:** `/sdd-new {something-simple}`
3. **Go through all phases** to understand the workflow
4. **Then use `/sdd-ff`** when you're comfortable

**Bienvenido al SDD Show, loco. Where features are planned like God of War speedruns — every move calculated, every edge case covered. 🚀🔥**
