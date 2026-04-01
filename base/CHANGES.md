# CHANGES.md

Session log with progressive tracking. Every session creates a **started** entry at the
beginning, **progress** lines as work happens, and a **completed** entry at the end.
If a session is interrupted, the next session sees the orphaned "started" entry plus any
progress lines — so it knows exactly what was done.

**Start entry (write before doing any work):**
```
## [YYYY-MM-DDTHH:MM] session-<id> | status: started | mode: full|lean | type: add|fix|refactor|chore
intent: One line describing what this session will do
```

**Progress lines (append after each logical unit of work):**
```
- progress: <what was done> | <files touched>
- progress: Replaced OldThing with NewThing | src/foo.ts (removed: OldThing)
```

**End entry (write when work is done):**
```
## [YYYY-MM-DDTHH:MM] session-<id> | status: completed | mode: full|lean | type: add|fix|refactor|chore
files_touched: path/to/file.ts, path/to/other.ts
symbols_added: FunctionName, ClassName
symbols_removed: OldFunction, DeprecatedClass
tests_added: path/to/test.ts
reason: One sentence. Note whether removed symbols were cleaned up or left for later.
health_snapshot: LOC=<n>, tests=<n>, complexity=ok|warn|fail
```

**Rules:**
- Write the **started** entry first — before doing any work.
- **Log progress as you go** — after each completed chunk, before moving to the next task.
- Write the **completed** entry when you finish — `symbols_removed` is mandatory if you deleted code.
- Note removed symbols in progress lines: `(removed: SymbolName)` — feeds dead code detection.
- Use the same `session-<id>` for both start and end entries.
- `tests_added` is required for `type: fix` — every fix needs a regression test.
- Do not edit past entries. Append only.
- See `.kit/changelog-protocol.md` for full details.

---
<!-- Entries below — newest at bottom -->
