#!/usr/bin/env bash
# .opencode/hooks/session-end.sh
# Runs analyze-changes and reminds agent to write CHANGES.md
set -uo pipefail

echo "==> Session end: running changelog analysis..."
if [ -f "scripts/analyze-changes.sh" ]; then
  bash scripts/analyze-changes.sh
fi

today=$(date +%Y-%m-%d)
if ! grep -q "## \[$today\]" CHANGES.md 2>/dev/null; then
  echo ""
  echo "--- Reminder: CHANGES.md has no entry for today ($today)."
  echo "    If you removed symbols or are in full mode, please add one."
fi

exit 0
