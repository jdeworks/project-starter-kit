#!/usr/bin/env bash
# stop.sh — runs when Claude Code finishes responding
# Prompts agent to write CHANGES.md if in full mode or symbols were removed
# Triggered by: Stop
set -uo pipefail

# Check if CHANGES.md exists and if today's session is already logged
today=$(date +%Y-%m-%d)
if [ -f "CHANGES.md" ] && grep -q "## \[$today\]" CHANGES.md 2>/dev/null; then
  # Already logged today — no action needed
  exit 0
fi

# Emit reminder to stderr so Claude sees it
cat >&2 << EOF

--- Session end reminder ---
This session is not yet logged in CHANGES.md.

If you removed, renamed, or refactored any symbols, or if you are in full mode,
please append an entry to CHANGES.md now using the format in docs/changelog-protocol.md.

If you fixed a bug this session, include tests_added: with the regression test(s) you wrote.
Every fix must have a regression test — see docs/testing.md § Regression tests.

If this was a lean-mode session with no symbol removals, you may skip this.
---
EOF

exit 0
