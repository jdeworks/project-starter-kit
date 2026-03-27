#!/usr/bin/env bash
# .opencode/hooks/session-start.sh
# Mirrors Claude Code's session-start behavior for OpenCode sessions
set -uo pipefail

if [ -f "SESSION_SUMMARY.md" ]; then
  summary_lines=$(wc -l < SESSION_SUMMARY.md | tr -d ' ')
  if [ "$summary_lines" -gt 10 ]; then
    echo "=== Session context from previous session ==="
    cat SESSION_SUMMARY.md
    echo "============================================="
  fi
fi

if [ -f "CHANGES.md" ]; then
  recent=$(grep -A7 '^## \[' CHANGES.md | tail -30 2>/dev/null || echo "")
  if [ -n "$recent" ]; then
    echo "=== Recent CHANGES.md entries ==="
    echo "$recent"
    echo "================================="
  fi
fi

exit 0
