#!/usr/bin/env bash
# update.sh — update starter-kit infrastructure in an existing project
# Downloads the latest kit and replaces hooks, scripts, docs, and base AGENTS.md sections.
# Project-specific content (code, tests, CHANGES.md entries, custom AGENTS.md sections) is preserved.
# Usage: bash <(curl -sL .../cli/update.sh) [--variant game-dev] [--dry-run]
#    or: bash /path/to/cli/update.sh --target /path/to/project [--variant game-dev]
set -euo pipefail

REPO_URL="https://github.com/jdeworks/project-starter-kit.git"
BRANCH="dev"
TARGET="" VARIANT="" DRY_RUN=false

show_help() {
  cat << 'EOF'
Usage: bash cli/update.sh [--target <path>] [--variant <name>] [--dry-run]

Updates starter-kit infrastructure files in an existing project to the latest version.

What gets updated:
  - .claude/hooks/          All hook scripts (replaced)
  - .claude/settings.json   Hook wiring (replaced)
  - scripts/                analyze-changes.sh, health-check.sh (replaced)
  - docs/                   Base + variant docs (new files added, existing replaced)
  - AGENTS.md               Base sections updated, project-specific sections preserved
  - Makefile                Replaced (task runner)
  - .opencode/, .cursor/, .windsurf/, .github/   Agent configs (replaced)

What is NOT touched:
  - src/, tests/            Your code
  - CHANGES.md              Your session history (entries preserved)
  - SESSION_SUMMARY.md      Regenerated on next pre-compact
  - package.json, etc.      Your dependencies
  - Any file not from the kit

Options:
  --target <path>   Project directory (default: current directory)
  --variant <name>  Variant to use (auto-detected from AGENTS.md if omitted)
  --dry-run         Show what would change without writing
  --help, -h        Show this help
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)   TARGET="$2";    shift 2 ;;
    --variant)  VARIANT="$2";   shift 2 ;;
    --dry-run)  DRY_RUN=true;   shift ;;
    --help|-h)  show_help ;;
    *) echo "Unknown argument: $1. Use --help."; exit 1 ;;
  esac
done

TARGET="${TARGET:-$(pwd)}"

# ── Validate target ─────────────────────────────────────────────────────────
if [ ! -f "$TARGET/AGENTS.md" ]; then
  echo "Error: no AGENTS.md found in $TARGET. Is this a starter-kit project?"
  exit 1
fi

# ── Auto-detect variant from AGENTS.md ──────────────────────────────────────
if [ -z "$VARIANT" ]; then
  # Look for variant-specific markers in AGENTS.md
  if grep -q 'game-architecture\|game-loop\|Game-specific rules' "$TARGET/AGENTS.md" 2>/dev/null; then
    VARIANT="game-dev"
  elif grep -q 'saas-architecture\|multi-tenancy\|SaaS-specific' "$TARGET/AGENTS.md" 2>/dev/null; then
    VARIANT="saas"
  elif grep -q 'api-architecture\|API-specific' "$TARGET/AGENTS.md" 2>/dev/null; then
    VARIANT="api-service"
  elif grep -q 'monorepo\|Monorepo-specific' "$TARGET/AGENTS.md" 2>/dev/null; then
    VARIANT="monorepo"
  elif grep -q 'mcp-server\|MCP-specific' "$TARGET/AGENTS.md" 2>/dev/null; then
    VARIANT="mcp-server"
  elif grep -q 'cli-tool\|CLI-specific' "$TARGET/AGENTS.md" 2>/dev/null; then
    VARIANT="cli-tool"
  elif grep -q 'mobile-app\|Mobile-specific' "$TARGET/AGENTS.md" 2>/dev/null; then
    VARIANT="mobile-app"
  elif grep -q 'desktop-app\|Desktop-specific' "$TARGET/AGENTS.md" 2>/dev/null; then
    VARIANT="desktop-app"
  elif grep -q 'website\|Website-specific' "$TARGET/AGENTS.md" 2>/dev/null; then
    VARIANT="website"
  fi

  if [ -z "$VARIANT" ]; then
    echo "Warning: could not auto-detect variant. Use --variant to specify."
    echo "Updating base files only (no variant-specific docs)."
  else
    echo "Auto-detected variant: $VARIANT"
  fi
fi

echo ""
echo "project-starter-kit update"
echo "=========================="
echo "  Target  : $TARGET"
[ -n "$VARIANT" ] && echo "  Variant : $VARIANT"
echo "  Dry run : $DRY_RUN"
echo ""

# ── Download latest kit ─────────────────────────────────────────────────────
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "==> Downloading latest starter-kit..."

# If we're running from inside the kit repo, use it directly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"
if [ -f "$KIT_ROOT/base/AGENTS.md" ] && [ -d "$KIT_ROOT/cli" ]; then
  echo "    Using local kit at $KIT_ROOT"
  KIT="$KIT_ROOT"
else
  if ! git clone --filter=blob:none --no-checkout --depth=1 -b "$BRANCH" \
    "$REPO_URL" "$TMPDIR/kit" 2>&1 | tail -1; then
    echo "Error: failed to clone. Check your network."; exit 1
  fi
  cd "$TMPDIR/kit"
  SPARSE_SET="base cli"
  [ -n "$VARIANT" ] && SPARSE_SET="$SPARSE_SET $VARIANT/AGENTS.md $VARIANT/docs"
  git sparse-checkout init --cone 2>/dev/null
  git sparse-checkout set $SPARSE_SET
  git checkout "$BRANCH" 2>/dev/null
  KIT="$TMPDIR/kit"
fi

source "$KIT/cli/_helpers.sh"

# ── Determine what to update ────────────────────────────────────────────────

# Files that get fully replaced (kit infrastructure)
REPLACE_DIRS=(".claude/hooks" "scripts" ".opencode" ".cursor" ".windsurf" ".github")
REPLACE_FILES=(".claude/settings.json" "Makefile")

# Docs: base docs + variant docs (replaced/added, never removed)
BASE_DOCS="$KIT/base/docs"
VARIANT_DOCS=""
[ -n "$VARIANT" ] && [ -d "$KIT/$VARIANT/docs" ] && VARIANT_DOCS="$KIT/$VARIANT/docs"

# Files excluded from compose (should not exist in target)
EXCLUDE_FILES=("HOOKS.md" "CONTRIBUTING.md" "docs/architecture.md" "docs/bring-your-own-stack.md" "scripts/verify-changes.sh")

updated=0 added=0 removed=0 skipped=0

update_file() {
  local src="$1" dest="$2" label="$3"
  if [ ! -f "$src" ]; then return; fi

  if [ -f "$dest" ]; then
    if diff -q "$src" "$dest" >/dev/null 2>&1; then
      skipped=$((skipped + 1))
      return
    fi
    if [ "$DRY_RUN" = true ]; then
      echo "  UPDATE: $label"
      updated=$((updated + 1))
      return
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "  UPDATE: $label"
    updated=$((updated + 1))
  else
    if [ "$DRY_RUN" = true ]; then
      echo "  ADD:    $label"
      added=$((added + 1))
      return
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "  ADD:    $label"
    added=$((added + 1))
  fi
}

# ── Replace infrastructure directories ──────────────────────────────────────
echo "==> Updating infrastructure files..."

for dir in "${REPLACE_DIRS[@]}"; do
  src_dir="$KIT/base/$dir"
  [ ! -d "$src_dir" ] && continue
  while IFS= read -r -d '' f; do
    rel="${f#$src_dir/}"
    full_rel="$dir/$rel"
    # Skip files in the exclusion list
    skip=false
    for excl in "${EXCLUDE_FILES[@]}"; do
      [ "$full_rel" = "$excl" ] && skip=true && break
    done
    [ "$skip" = true ] && continue
    update_file "$f" "$TARGET/$full_rel" "$full_rel"
  done < <(find "$src_dir" -type f -print0 2>/dev/null)
done

for file in "${REPLACE_FILES[@]}"; do
  update_file "$KIT/base/$file" "$TARGET/$file" "$file"
done

# ── Update docs ─────────────────────────────────────────────────────────────
echo "==> Updating docs..."

if [ -d "$BASE_DOCS" ]; then
  while IFS= read -r -d '' f; do
    rel="${f#$BASE_DOCS/}"
    # Skip kit-internal docs
    skip=false
    for excl in "architecture.md" "bring-your-own-stack.md"; do
      [ "$rel" = "$excl" ] && skip=true && break
    done
    [ "$skip" = true ] && continue
    update_file "$f" "$TARGET/docs/$rel" "docs/$rel"
  done < <(find "$BASE_DOCS" -type f -name "*.md" -print0 2>/dev/null)
fi

if [ -n "$VARIANT_DOCS" ]; then
  while IFS= read -r -d '' f; do
    rel="${f#$VARIANT_DOCS/}"
    update_file "$f" "$TARGET/docs/$rel" "docs/$rel (variant)"
  done < <(find "$VARIANT_DOCS" -type f -name "*.md" -print0 2>/dev/null)
fi

# ── Update AGENTS.md base sections ──────────────────────────────────────────
echo "==> Updating AGENTS.md..."

# Strategy: rebuild AGENTS.md by taking the new base template up to "Tool-specific entry points"
# then appending everything from the old AGENTS.md after the base section (variant-specific content).
NEW_BASE="$KIT/base/AGENTS.md"
OLD_AGENTS="$TARGET/AGENTS.md"
VARIANT_AGENTS=""
[ -n "$VARIANT" ] && [ -f "$KIT/$VARIANT/AGENTS.md" ] && VARIANT_AGENTS="$KIT/$VARIANT/AGENTS.md"

if [ -f "$NEW_BASE" ]; then
  # Extract project-specific sections from old AGENTS.md:
  # - Project overview + Tech stack + Key commands + Important paths (user-filled)
  # - Everything after "Tool-specific entry points" section (variant content)
  old_overview=$(sed -n '/^## Project overview$/,/^---$/p' "$OLD_AGENTS" | head -n -1)
  old_techstack=$(sed -n '/^## Tech stack$/,/^## Key commands$/p' "$OLD_AGENTS" | head -n -1)
  old_commands=$(sed -n '/^## Key commands$/,/^## Important paths$/p' "$OLD_AGENTS" | head -n -1)
  old_paths=$(sed -n '/^## Important paths$/,/^---$/p' "$OLD_AGENTS" | head -n -1)
  old_variant=$(sed -n '/^## Tool-specific entry points$/,//p' "$OLD_AGENTS")

  if [ "$DRY_RUN" = true ]; then
    echo "  UPDATE: AGENTS.md (base sections refreshed, project sections preserved)"
    updated=$((updated + 1))
  else
    # Build new AGENTS.md
    {
      # Header + mode section from new base
      sed -n '1,/^---$/p' "$NEW_BASE"
      echo ""

      # Project-specific sections (preserved from old)
      echo "$old_overview"
      echo ""
      echo "$old_techstack"
      echo ""
      echo "$old_commands"
      echo ""
      echo "$old_paths"
      echo ""
      echo "---"
      echo ""

      # Reference docs + rules + hooks from new base
      sed -n '/^## Reference docs/,/^## Tool-specific entry points$/p' "$NEW_BASE" | head -n -1

      # Variant content (from old file, or merge from kit variant)
      echo "$old_variant"

      # If there's a variant AGENTS.md, append sections not already present
      if [ -n "$VARIANT_AGENTS" ]; then
        variant_content=$(sed '1,/^---$/d' "$VARIANT_AGENTS" 2>/dev/null || cat "$VARIANT_AGENTS")
        # Only append if variant content isn't already in the file
        while IFS= read -r section_header; do
          if ! grep -qF "$section_header" "$OLD_AGENTS" 2>/dev/null; then
            echo ""
            sed -n "/^${section_header}$/,/^---$/p" "$VARIANT_AGENTS" 2>/dev/null || true
          fi
        done < <(grep '^## ' <<< "$variant_content" 2>/dev/null || true)
      fi
    } > "$TARGET/AGENTS.md.new"

    mv "$TARGET/AGENTS.md.new" "$TARGET/AGENTS.md"
    echo "  UPDATE: AGENTS.md (base sections refreshed, project sections preserved)"
    updated=$((updated + 1))
  fi
fi

# ── Remove files that shouldn't exist ───────────────────────────────────────
echo "==> Cleaning up kit-internal files..."
for f in "${EXCLUDE_FILES[@]}"; do
  if [ -f "$TARGET/$f" ]; then
    if [ "$DRY_RUN" = true ]; then
      echo "  REMOVE: $f"
    else
      rm "$TARGET/$f"
      echo "  REMOVE: $f"
    fi
    removed=$((removed + 1))
  fi
done

# ── Make scripts executable ─────────────────────────────────────────────────
if [ "$DRY_RUN" = false ]; then
  find "$TARGET/scripts" "$TARGET/.claude/hooks" "$TARGET/.opencode/hooks" \
    -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
fi

# ── Summary ─────────────────────────────────────────────────────────────────
echo ""
if [ "$DRY_RUN" = true ]; then
  echo "[dry-run] Would update $updated, add $added, remove $removed files ($skipped unchanged)"
else
  echo "Update complete: $updated updated, $added added, $removed removed ($skipped unchanged)"
  echo ""
  echo "Review the changes with 'git diff' before committing."
fi
