#!/usr/bin/env bash
# status.sh — show kit status, variant details, and doc counts
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  cat << 'HELPEOF'
Usage: bash cli/status.sh

Shows project-starter-kit status: variant details, doc counts, and kit health.
HELPEOF
  exit 0
fi

VALID_VARIANTS="website saas api-service monorepo game-dev mcp-server cli-tool mobile-app desktop-app/cross-platform desktop-app/native"

echo ""
echo "project-starter-kit status"
echo "=========================="
echo ""

# ── Variants ─────────────────────────────────────────────────────────────────
printf "%-34s %-8s %s\n" "VARIANT" "STATUS" "DOCS"
printf "%-34s %-8s %s\n" "-------" "------" "----"

total_docs=0
for v in $VALID_VARIANTS; do
  doc_count=0
  if [ -d "$KIT_ROOT/$v/docs" ]; then
    doc_count=$(find "$KIT_ROOT/$v/docs" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
  fi
  total_docs=$((total_docs + doc_count))

  # Check if AGENTS.md has TODO markers (stub) or real content
  status="Ready"
  if grep -q '<!-- TODO' "$KIT_ROOT/$v/AGENTS.md" 2>/dev/null; then
    status="Stub"
  fi

  printf "%-34s %-8s %s\n" "$v" "$status" "${doc_count} docs"
done

echo ""

# ── Base layer ───────────────────────────────────────────────────────────────
base_docs=$(find "$KIT_ROOT/base/docs" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
base_hooks=$(find "$KIT_ROOT/base/.claude/hooks" -name "*.sh" -type f 2>/dev/null | wc -l | tr -d ' ')
base_scripts=$(find "$KIT_ROOT/base/scripts" -name "*.sh" -type f 2>/dev/null | wc -l | tr -d ' ')
cli_scripts=$(find "$KIT_ROOT/cli" -name "*.sh" -type f 2>/dev/null | wc -l | tr -d ' ')

echo "Base layer:  $base_docs docs, $base_hooks hooks, $base_scripts scripts"
echo "CLI scripts: $cli_scripts"
echo "Total docs:  $((total_docs + base_docs)) (base: $base_docs, variants: $total_docs)"
echo ""

# ── Self-hosting check ───────────────────────────────────────────────────────
echo "Self-hosting:"
checks=0; passes=0
for f in AGENTS.md CLAUDE.md CHANGES.md SESSION_SUMMARY.md Makefile; do
  checks=$((checks + 1))
  if [ -e "$KIT_ROOT/$f" ]; then
    passes=$((passes + 1))
    printf "  %-24s OK\n" "$f"
  else
    printf "  %-24s MISSING\n" "$f"
  fi
done
echo ""
echo "$passes/$checks self-hosting files present"
