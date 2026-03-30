# AGENTS.md

## Session mode
Declare your mode at the start of every session:
- **full** — all three test tiers active, all hooks enforced, CHANGES.md required. Use for features being merged.
- **lean** — feature tests only, reduced hooks, CHANGES.md optional. Use for spikes and prototypes.

Default: **full**. To switch, state "mode: lean" at session start or read `.kit/modules/lean.md`.

---

## Project overview
project-starter-kit is a structured foundation for AI-assisted software projects. It provides
AGENTS.md instruction layers, lifecycle hooks, health-check scripts, multi-tier testing docs,
and variant templates so AI agents (Claude Code, OpenCode, Cursor, Windsurf) produce maintainable
code from day one. The kit is organized as a base layer (shared by all projects) plus variant
overlays (website, api-service, saas, etc.) composed via CLI scripts.

## Tech stack
- Shell (bash) — CLI scripts, hooks, health checks
- Make — task runner
- Markdown — all docs, AGENTS.md, variant templates
- JSON — agent configs (.claude/settings.json, .opencode/config.json)
- No runtime dependencies — the kit is pure config/docs/scripts

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
- `base/` — shared layer: AGENTS.md template, hooks, scripts, docs, Makefile
- `base/.claude/` — Claude Code hooks and settings
- `base/.opencode/` — OpenCode hooks, commands, config
- `base/.kit/` — reference docs (code-health, testing, changelog-protocol, etc.)
- `base/scripts/` — health-check.sh, analyze-changes.sh
- Variants: `website/`, `api-service/`, `saas/`, `monorepo/`, `game-dev/`, `mcp-server/`, `cli-tool/`, `mobile-app/`, `desktop-app/`
- `cli/` — init.sh, compose.sh, migrate.sh, upgrade.sh
- Root symlinks: `.claude/hooks`, `.claude/settings.json`, `.kit/`, `scripts/`, `Makefile` all point into `base/`

---

## Reference docs — read on demand

Read these when the situation calls for it. Do not load all of them upfront.

| Doc | Read when |
|-----|-----------|
| `.kit/code-health.md` | A file is getting large, complex, or you're unsure about structure |
| `.kit/testing.md` | Writing or reviewing tests; starting a new feature |
| `.kit/llm-testing.md` | Adding or modifying any code that calls an LLM |
| `.kit/changelog-protocol.md` | End of session, before compressing context, or after removing symbols |
| `.kit/context-management.md` | Context is filling up or you're about to compact |
| `.kit/research-planning.md` | Starting a non-trivial feature; unsure about architecture |
| `.kit/modules/full.md` | Switching to full mode mid-session |
| `.kit/modules/lean.md` | Switching to lean mode mid-session |
| `.kit/git-and-github.md` | Commit hygiene, branching, pre-commit hooks, PR best practices |
| `.kit/architecture.md` | Understanding the base + variant + CLI layering (for contributors) |
| `.kit/bring-your-own-stack.md` | Using a framework the kit doesn't have examples for |
| `CONTRIBUTING.md` | Adding a new variant, hook support, or fixing the kit itself |

---

## Non-negotiable rules (active in all modes)

1. **No feature is done without tests.** At minimum: one passing test per exported function.
2. **Run `make check` before declaring work complete.** Fix all failures before stopping.
3. **Append to CHANGES.md at session end** (full mode) or when removing symbols (any mode).
4. **Never leave `console.log` in production files.** Use a logger or remove before committing.
5. **Read the relevant doc before starting unfamiliar work** — don't guess at conventions.
6. **Every fix gets a regression test.** When you fix a bug, add a test that would have caught it. Log it in CHANGES.md with `tests_added`.
7. **Learn from CHANGES.md.** At session start, check recent entries for patterns — areas with repeated fixes need better test coverage. See `.kit/testing.md` § Regression tests.
8. **Shell scripts must stay under 150 lines** — see CONTRIBUTING.md.

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
