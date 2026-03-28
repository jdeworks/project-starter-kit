#!/usr/bin/env bash
# pre-compact.sh — runs before Claude Code compresses context
# Analyzes CHANGES.md for dead code, writes SESSION_SUMMARY.md
# Triggered by: PreCompact
set -uo pipefail

echo "==> PreCompact: analyzing project state before compression..."

# Run the changelog analyzer
if [ -f "scripts/analyze-changes.sh" ]; then
  bash scripts/analyze-changes.sh
else
  echo "Warning: scripts/analyze-changes.sh not found — skipping dead code analysis"
fi

# Remind Claude to fill in next steps before compacting
cat >&2 << 'EOF'

--- PreCompact reminder ---
Before this context is compressed, please:
1. Ensure your CHANGES.md session has a "completed" entry (if in full mode)
2. Fill in the "Next steps" section of SESSION_SUMMARY.md
3. Note any unresolved questions or in-progress work
---
EOF

exit 0
