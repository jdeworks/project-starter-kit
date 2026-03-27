# AGENTS.md

## Session mode
Declare your mode at the start of every session:
- **full** — all three test tiers active, all hooks enforced, CHANGES.md required. Use for features being merged.
- **lean** — feature tests only, reduced hooks, CHANGES.md optional. Use for spikes and prototypes.

Default: **full**. To switch, state "mode: lean" at session start or read `docs/modules/lean.md`.

---

## Project overview
<!-- FILL IN: one paragraph describing what this project does -->

## Tech stack
<!-- FILL IN: language, framework, database, hosting -->

## Key commands
```
make dev        # start dev server
make check      # full quality pipeline (format + lint + types + deadcode + tests + health)
make test       # run tests only
make health     # architecture health check only
make ci         # check + build (runs in CI)
make help       # list all targets
```

## Important paths
<!-- FILL IN: src/, tests/, key config files -->

---

## Reference docs — read on demand

Read these when the situation calls for it. Do not load all of them upfront.

| Doc | Read when |
|-----|-----------|
| `docs/code-health.md` | A file is getting large, complex, or you're unsure about structure |
| `docs/testing.md` | Writing or reviewing tests; starting a new feature |
| `docs/llm-testing.md` | Adding or modifying any code that calls an LLM |
| `docs/changelog-protocol.md` | End of session, before compressing context, or after removing symbols |
| `docs/context-management.md` | Context is filling up or you're about to compact |
| `docs/research-planning.md` | Starting a non-trivial feature; unsure about architecture |
| `docs/modules/full.md` | Switching to full mode mid-session |
| `docs/modules/lean.md` | Switching to lean mode mid-session |
| `docs/git-and-github.md` | Commit hygiene, branching, pre-commit hooks, PR best practices |
| `docs/architecture.md` | Understanding the base + variant + CLI layering (for contributors) |
| `docs/bring-your-own-stack.md` | Using a framework the kit doesn't have examples for |

---

## Non-negotiable rules (active in all modes)

1. **No feature is done without tests.** At minimum: one passing test per exported function.
2. **Run `make check` before declaring work complete.** Fix all failures before stopping.
3. **Append to CHANGES.md at session end** (full mode) or when removing symbols (any mode).
4. **Never leave `console.log` in production files.** Use a logger or remove before committing.
5. **Read the relevant doc before starting unfamiliar work** — don't guess at conventions.
6. **Every fix gets a regression test.** When you fix a bug, add a test that would have caught it. Log it in CHANGES.md with `tests_added`.
7. **Learn from CHANGES.md.** At session start, check recent entries for patterns — areas with repeated fixes need better test coverage. See `docs/testing.md` § Regression tests.

---

## Hooks (Claude Code)
Hooks run automatically via `.claude/settings.json`:
- After every file edit: health check warning + auto-format
- Before context compact: changelog analysis + session summary written
- On session start: last session summary + pending dead code flags injected
- On stop: prompt to write CHANGES.md entry

---

## Tool-specific entry points
- Cursor: `.cursor/rules/main.mdc`
- Windsurf: `.windsurf/rules/main.md`
- GitHub Copilot: `.github/copilot-instructions.md`
- Online AI (ChatGPT, Gemini): `bundle.xml` via repomix (`npx repomix`)
- All of these redirect here.
