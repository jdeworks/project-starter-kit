# CHANGES.md

Append-only log of all agent sessions. Written by the agent at session end (full mode)
or whenever symbols are removed (any mode). Used by PreCompact hook to detect dead code
and generate SESSION_SUMMARY.md.

**Format — copy this block for each entry:**
```
## [YYYY-MM-DD] session-<id> | mode: full|lean | type: add|remove|refactor|fix|chore
files_touched: path/to/file.ts, path/to/other.ts
symbols_added: FunctionName, ClassName, CONSTANT_NAME
symbols_removed: OldFunction, DeprecatedClass
reason: One-line explanation. Note any symbols that are now dead code.
health_snapshot: LOC=<n>, tests=<n>, complexity=ok|warn|fail
```

**Rules:**
- `symbols_removed` is mandatory whenever code is deleted — this is how dead code is tracked.
- If `symbols_removed` is non-empty, note in `reason` whether it was cleaned up or left for later.
- Keep `reason` to one line. Detail belongs in commit messages, not here.
- Do not edit past entries. Append only.

---
<!-- Entries below — newest at bottom -->
