#!/usr/bin/env bash
# validate.sh — verify all variant AGENTS.md doc references point to existing files
# Also runs hook smoke tests if --hooks is passed
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  cat << 'HELPEOF'
Usage: bash cli/validate.sh [--hooks]

Validates the starter kit: doc references, starters.json manifests, orphaned docs.

Options:  --hooks  Run hook smoke tests.  --help|-h  This help.
HELPEOF
  exit 0
fi

RUN_HOOKS=false
[[ "${1:-}" == "--hooks" ]] && RUN_HOOKS=true

VALID_VARIANTS="website saas api-service monorepo game-dev mcp-server cli-tool mobile-app desktop-app/cross-platform desktop-app/native"

ERRORS=0
WARNINGS=0

echo ""
echo "project-starter-kit validate"
echo "============================"
echo ""

# ── Check variant doc references ─────────────────────────────────────────────
echo "==> Checking variant doc references..."
for v in $VALID_VARIANTS; do
  agents_file="$KIT_ROOT/$v/AGENTS.md"
  if [ ! -f "$agents_file" ]; then
    echo "  ERROR: $v/AGENTS.md missing"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  # Extract doc paths from markdown table rows like: | `.kit/foo.md` |
  while IFS= read -r doc_ref; do
    doc_path=$(echo "$doc_ref" | sed -n 's/.*`\(docs\/[^`]*\)`.*/\1/p' || true)
    if [ -n "$doc_path" ]; then
      full_path="$KIT_ROOT/$v/$doc_path"
      if [ ! -f "$full_path" ]; then
        echo "  ERROR: $v/AGENTS.md references $doc_path but file does not exist"
        ERRORS=$((ERRORS + 1))
      fi
    fi
  done < <(grep '| `.kit/' "$agents_file" 2>/dev/null || true)
done

if [ "$ERRORS" -eq 0 ]; then
  echo "  All doc references valid."
fi

# ── Check base doc references ────────────────────────────────────────────────
echo ""
echo "==> Checking base AGENTS.md doc references..."
base_agents="$KIT_ROOT/base/AGENTS.md"
while IFS= read -r doc_ref; do
  doc_path=$(echo "$doc_ref" | grep -oP '`.kit/[^`]+`' | tr -d '`' || true)
  if [ -n "$doc_path" ]; then
    full_path="$KIT_ROOT/base/$doc_path"
    if [ ! -f "$full_path" ]; then
      echo "  ERROR: base/AGENTS.md references $doc_path but file does not exist"
      ERRORS=$((ERRORS + 1))
    fi
  fi
done < <(grep '| `.kit/' "$base_agents" 2>/dev/null || true)

if [ "$ERRORS" -eq 0 ]; then
  echo "  All doc references valid."
fi

# ── Validate starters.json manifests ─────────────────────────────────────────
echo ""
echo "==> Checking starters.json manifests..."
for v in $VALID_VARIANTS; do
  sjson="$KIT_ROOT/$v/starters/starters.json"
  [ -f "$sjson" ] || continue
  # Extract starter ids and check directories exist
  while IFS= read -r sid; do
    sdir="$KIT_ROOT/$v/starters/$sid"
    if [ ! -d "$sdir" ]; then
      echo "  ERROR: $v/starters/starters.json lists '$sid' but directory missing"
      ERRORS=$((ERRORS + 1))
    elif [ ! -f "$sdir/README.md" ]; then
      echo "  WARN: $v/starters/$sid/ has no README.md"
      WARNINGS=$((WARNINGS + 1))
    fi
  done < <(sed -n 's/.*"id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$sjson")
done
echo "  Starter manifests checked."

# ── Check for orphaned docs ──────────────────────────────────────────────────
echo ""
echo "==> Checking for orphaned docs..."
for v in $VALID_VARIANTS; do
  if [ -d "$KIT_ROOT/$v/docs" ]; then
    while IFS= read -r doc_file; do
      doc_basename=$(basename "$doc_file")
      doc_rel=".kit/$doc_basename"
      if ! grep -q "$doc_rel" "$KIT_ROOT/$v/AGENTS.md" 2>/dev/null; then
        echo "  WARN: $v/$doc_rel exists but not referenced in AGENTS.md"
        WARNINGS=$((WARNINGS + 1))
      fi
    done < <(find "$KIT_ROOT/$v/docs" -name "*.md" -type f 2>/dev/null)
  fi
done

if [ "$WARNINGS" -eq 0 ]; then
  echo "  No orphaned docs."
fi

# ── Hook smoke tests ─────────────────────────────────────────────────────────
if [ "$RUN_HOOKS" = true ]; then
  echo ""
  echo "==> Running hook smoke tests..."
  TMPDIR=$(mktemp -d)
  trap 'rm -rf "$TMPDIR"' EXIT

  # Set up minimal project structure in temp dir
  mkdir -p "$TMPDIR/src" "$TMPDIR/.claude/hooks"
  cp "$KIT_ROOT/base/.claude/hooks/"*.sh "$TMPDIR/.claude/hooks/"
  cp "$KIT_ROOT/base/scripts/"*.sh "$TMPDIR/" 2>/dev/null || true
  touch "$TMPDIR/CHANGES.md" "$TMPDIR/SESSION_SUMMARY.md"

  for hook in "$TMPDIR/.claude/hooks/"*.sh; do
    hook_name=$(basename "$hook")
    if bash "$hook" > /dev/null 2>&1; then
      echo "  OK: $hook_name"
    else
      echo "  ERROR: $hook_name failed (exit $?)"
      ERRORS=$((ERRORS + 1))
    fi
  done
fi

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
echo "Validation complete: $ERRORS error(s), $WARNINGS warning(s)"

if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi
