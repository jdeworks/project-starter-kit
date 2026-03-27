#!/usr/bin/env bash
# session-start.sh — runs at the start of every Claude Code session
# Injects SESSION_SUMMARY.md and recent CHANGES.md tail into context
# Triggered by: SessionStart
set -uo pipefail

output=""

# Inject SESSION_SUMMARY if it has content beyond the template
if [ -f "SESSION_SUMMARY.md" ]; then
  summary_lines=$(wc -l < SESSION_SUMMARY.md | tr -d ' ')
  if [ "$summary_lines" -gt 10 ]; then
    output+="$(cat SESSION_SUMMARY.md)\n\n"
  fi
fi

# Inject last 3 CHANGES.md entries for quick context
if [ -f "CHANGES.md" ]; then
  recent=$(grep -A7 '^## \[' CHANGES.md | tail -30 2>/dev/null || echo "")
  if [ -n "$recent" ]; then
    output+="### Recent session history (from CHANGES.md)\n${recent}\n"
  fi

  # Check for fix-heavy areas (hotspots) and flag them
  fix_areas=$(grep -B1 'type: fix' CHANGES.md 2>/dev/null \
    | grep '^files_touched:' \
    | sed 's/files_touched: //' \
    | tr ',' '\n' \
    | sed 's/^[[:space:]]*//' \
    | cut -d/ -f1-2 \
    | sort | uniq -c | sort -rn \
    | head -3 \
    | awk '$1 >= 2 {print "  " $1 "x fixes in " $2}' 2>/dev/null || echo "")
  if [ -n "$fix_areas" ]; then
    output+="\n### Test coverage hotspots (areas with repeated fixes)\n${fix_areas}\nConsider adding preventive tests in these areas.\n"
  fi
fi

# Output as additionalContext for Claude Code (v2.1.9+)
if [ -n "$output" ]; then
  escaped=$(printf '%s' "$output" | python3 -c "import sys,json; sys.stdout.write(json.dumps(sys.stdin.read()))" 2>/dev/null || printf '"%s"' "$output")
  printf '{"additionalContext": %s}' "$escaped"
fi

exit 0
