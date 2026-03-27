# Changelog protocol

CHANGES.md is a machine-readable log that lets future sessions (and the PreCompact hook)
understand what changed, what was removed, and what might be dead code. It is not a human diary.

---

## When to write an entry

**Always write an entry when:**
- A session ends in full mode
- You remove, rename, or restructure symbols (any mode)
- You refactor something that touches more than 3 files

**You may skip an entry when:**
- Session is lean mode and you only added new code (no removals)
- You only changed comments, formatting, or config values

---

## Format

```
## [YYYY-MM-DD] session-<short-id> | mode: full|lean | type: add|remove|refactor|fix|chore
files_touched: path/to/file.ts, path/to/other.ts
symbols_added: ExportedFunctionName, ExportedClassName, EXPORTED_CONSTANT
symbols_removed: OldFunctionName, RemovedType
tests_added: path/to/new.test.ts, path/to/regression.test.ts
reason: One sentence. Include whether removed symbols were cleaned up or left for later.
health_snapshot: LOC=4234, tests=312, complexity=ok|warn|fail
```

**`tests_added`** — list any new test files or test cases created this session. This lets
future sessions verify test coverage is growing alongside the code. For fix-type entries,
this field is required — every fix must have a regression test.

**Types:**
- `add` — new features, new files, new exports
- `remove` — deleted code, removed exports (most important to log)
- `refactor` — restructured without changing behaviour
- `fix` — bug fix
- `chore` — deps, config, CI, tooling

---

## What counts as a symbol

A symbol is anything that's exported and could be imported elsewhere:
- Functions: `export function doThing()`
- Classes: `export class MyService`
- Types/interfaces: `export type Foo`, `export interface Bar`
- Constants: `export const MAX_RETRIES`
- Default exports: `export default MyComponent`

Internal (non-exported) functions do not need to be tracked — they can't be dead code from
another file's perspective.

---

## Example entry

```
## [2026-03-27] session-a1b2 | mode: full | type: refactor
files_touched: src/auth/login.ts, src/auth/types.ts, src/auth/session.ts
symbols_added: LoginForm, validateToken, SessionStore
symbols_removed: OldAuthHandler, legacyLogin, AuthContext
tests_added: src/auth/login.test.ts, src/auth/session.test.ts
reason: Replaced OldAuthHandler pattern with LoginForm + SessionStore. OldAuthHandler,
legacyLogin, and AuthContext are removed — grep confirms no remaining imports.
health_snapshot: LOC=4102, tests=287, complexity=ok
```

**Fix entry example (tests_added is required for fixes):**
```
## [2026-03-28] session-c3d4 | mode: full | type: fix
files_touched: src/billing/webhook.ts
symbols_added: (none)
symbols_removed: (none)
tests_added: src/billing/webhook.test.ts (added: "handles duplicate events idempotently")
reason: Webhook handler processed duplicate Stripe events, causing double charges.
Added idempotency check on event ID. Regression test confirms duplicates are skipped.
health_snapshot: LOC=4110, tests=289, complexity=ok
```

---

## What the PreCompact hook does with this file

Before compressing context, the hook runs `scripts/analyze-changes.sh` which:

1. Collects all `symbols_removed` entries across history
2. Greps the codebase for any of those symbols still in use
3. Reports matches as "confirmed dead code" (removed from log but still used — suspicious)
   or "not cleaned up" (removed from log, not in use — safe to delete file reference)
4. Compresses entries older than 10 sessions into a summary block at the top

The output is written to SESSION_SUMMARY.md and injected into the new context window.

---

## Keeping it honest

The value of CHANGES.md degrades fast if entries are vague. These are bad:
- `reason: refactored some stuff` — useless
- `symbols_removed: (none)` when you actually deleted 3 functions — dishonest

When in doubt: err on the side of logging too much. Future sessions will thank you.
