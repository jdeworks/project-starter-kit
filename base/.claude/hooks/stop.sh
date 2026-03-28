#!/usr/bin/env bash
# stop.sh — runs when Claude Code finishes responding
# Enforces CHANGES.md completion in full mode
# Triggered by: Stop
set -uo pipefail

[ ! -f "CHANGES.md" ] && exit 0

# Detect mode
mode="full"
if [ -f "AGENTS.md" ] && grep -q 'Default: \*\*lean\*\*' AGENTS.md 2>/dev/null; then
  mode="lean"
fi

# Find the most recent "started" entry and check if it has a matching "completed"
last_started_sid=$(grep 'status: started' CHANGES.md 2>/dev/null | tail -1 | sed -n 's/.*session-\([^ |]*\).*/\1/p')

if [ -n "$last_started_sid" ]; then
  if grep -q "session-$last_started_sid | status: completed" CHANGES.md 2>/dev/null; then
    # Session properly completed — all good
    exit 0
  fi
fi

# No completed entry for the current/last session
if [ "$mode" = "full" ]; then
  cat >&2 << EOF

--- CHANGES.md: session not completed ---
You have a started session without a completed entry.
In full mode, you MUST append a completed entry to CHANGES.md before finishing.

Format:
## [$(date +%Y-%m-%dT%H:%M)] session-${last_started_sid:-xxxx} | status: completed | mode: full | type: add|fix|refactor|chore
files_touched: <files you changed>
symbols_added: <new exports>
symbols_removed: <deleted exports>
tests_added: <test files>
reason: <one sentence>
health_snapshot: LOC=<n>, tests=<n>, complexity=ok|warn|fail

See docs/changelog-protocol.md for details.
---
EOF
  exit 1
fi

# Lean mode — just a gentle reminder
cat >&2 << 'EOF'

--- Session end reminder (lean mode) ---
Consider logging this session in CHANGES.md if you removed or renamed any symbols.
---
EOF

exit 0
