#!/usr/bin/env bash
# update.sh — update starter-kit infrastructure in an existing project
# Downloads the latest kit and replaces hooks, scripts, and kit-managed AGENTS.md sections.
# Project-specific content (code, tests, CHANGES.md entries, custom AGENTS.md sections, Makefile) is preserved.
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

What gets REPLACED (kit-owned, safe to overwrite):
  - .claude/hooks/          All hook scripts
  - .claude/settings.json   Hook wiring
  - scripts/                analyze-changes.sh, health-check.sh
  - .kit/                   Reference docs (base + variant)
  - .opencode/, .cursor/, .windsurf/, .github/   Agent configs

What gets MERGED (user content preserved):
  - AGENTS.md               Only the section between kit:managed markers is replaced.
                             Your project overview, custom rules, and variant sections are kept.

What is NOT touched:
  - src/, tests/            Your code
  - Makefile                Your build targets (you own this file)
  - CHANGES.md              Your session history
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
    echo "Updating base files only (no variant-specific .kit/ docs)."
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
  [ -n "$VARIANT" ] && SPARSE_SET="$SPARSE_SET $VARIANT/AGENTS.md $VARIANT/.kit"
  git sparse-checkout init --cone 2>/dev/null
  git sparse-checkout set $SPARSE_SET
  git checkout "$BRANCH" 2>/dev/null
  KIT="$TMPDIR/kit"
fi

# ── Counters ────────────────────────────────────────────────────────────────
updated=0 added=0 removed=0 skipped=0

update_file() {
  local src="$1" dest="$2" label="$3"
  [ ! -f "$src" ] && return

  if [ -f "$dest" ]; then
    if diff -q "$src" "$dest" >/dev/null 2>&1; then
      skipped=$((skipped + 1)); return
    fi
    if [ "$DRY_RUN" = true ]; then
      echo "  UPDATE: $label"; updated=$((updated + 1)); return
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "  UPDATE: $label"; updated=$((updated + 1))
  else
    if [ "$DRY_RUN" = true ]; then
      echo "  ADD:    $label"; added=$((added + 1)); return
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "  ADD:    $label"; added=$((added + 1))
  fi
}

# Files that should never exist in a composed project
EXCLUDE_FILES=("HOOKS.md" "CONTRIBUTING.md" ".kit/architecture.md" ".kit/bring-your-own-stack.md" "scripts/verify-changes.sh")

# ── Replace infrastructure directories ──────────────────────────────────────
echo "==> Updating infrastructure files..."

REPLACE_DIRS=(".claude/hooks" "scripts" ".opencode" ".cursor" ".windsurf" ".github")

for dir in "${REPLACE_DIRS[@]}"; do
  src_dir="$KIT/base/$dir"
  [ ! -d "$src_dir" ] && continue
  while IFS= read -r -d '' f; do
    rel="${f#$src_dir/}"
    full_rel="$dir/$rel"
    skip=false
    for excl in "${EXCLUDE_FILES[@]}"; do
      [ "$full_rel" = "$excl" ] && skip=true && break
    done
    [ "$skip" = true ] && continue
    update_file "$f" "$TARGET/$full_rel" "$full_rel"
  done < <(find "$src_dir" -type f -print0 2>/dev/null)
done

# Replace settings.json (hook wiring) and KIT_VERSION
update_file "$KIT/base/.claude/settings.json" "$TARGET/.claude/settings.json" ".claude/settings.json"
update_file "$KIT/base/.claude/KIT_VERSION" "$TARGET/.claude/KIT_VERSION" ".claude/KIT_VERSION"

# ── Update .kit/ reference docs ─────────────────────────────────────────────
echo "==> Updating .kit/ reference docs..."

if [ -d "$KIT/base/.kit" ]; then
  while IFS= read -r -d '' f; do
    rel="${f#$KIT/base/.kit/}"
    skip=false
    for excl in "architecture.md" "bring-your-own-stack.md"; do
      [ "$rel" = "$excl" ] && skip=true && break
    done
    [ "$skip" = true ] && continue
    update_file "$f" "$TARGET/.kit/$rel" ".kit/$rel"
  done < <(find "$KIT/base/.kit" -type f -name "*.md" -print0 2>/dev/null)
fi

if [ -n "$VARIANT" ] && [ -d "$KIT/$VARIANT/.kit" ]; then
  while IFS= read -r -d '' f; do
    rel="${f#$KIT/$VARIANT/.kit/}"
    update_file "$f" "$TARGET/.kit/$rel" ".kit/$rel (variant)"
  done < <(find "$KIT/$VARIANT/.kit" -type f -name "*.md" -print0 2>/dev/null)
fi

# ── Migrate docs/ → .kit/ if old layout exists ─────────────────────────────
if [ -d "$TARGET/docs" ] && [ ! -d "$TARGET/.kit" ]; then
  echo "==> Migrating docs/ → .kit/ (old layout detected)..."
  if [ "$DRY_RUN" = true ]; then
    echo "  MIGRATE: docs/ → .kit/"
  else
    mv "$TARGET/docs" "$TARGET/.kit"
    echo "  MIGRATE: docs/ → .kit/"
  fi
  updated=$((updated + 1))
elif [ -d "$TARGET/docs" ] && [ -d "$TARGET/.kit" ]; then
  echo "==> Migrating remaining docs/ files → .kit/..."
  while IFS= read -r -d '' f; do
    rel="${f#$TARGET/docs/}"
    if [ ! -f "$TARGET/.kit/$rel" ]; then
      if [ "$DRY_RUN" = true ]; then
        echo "  MIGRATE: docs/$rel → .kit/$rel"
      else
        mkdir -p "$(dirname "$TARGET/.kit/$rel")"
        mv "$f" "$TARGET/.kit/$rel"
        echo "  MIGRATE: docs/$rel → .kit/$rel"
      fi
      updated=$((updated + 1))
    fi
  done < <(find "$TARGET/docs" -type f -print0 2>/dev/null)
  if [ "$DRY_RUN" = false ]; then
    # Remove docs/ entirely — all content is now in .kit/
    rm -rf "$TARGET/docs"
    echo "  REMOVE: docs/ (migrated to .kit/)"
    removed=$((removed + 1))
  fi
fi

# ── Update AGENTS.md (marker-based merge) ───────────────────────────────────
echo "==> Updating AGENTS.md..."

NEW_BASE="$KIT/base/AGENTS.md"
OLD_AGENTS="$TARGET/AGENTS.md"

if [ -f "$NEW_BASE" ]; then
  if grep -q 'kit:managed:start' "$OLD_AGENTS" 2>/dev/null; then
    # Has markers — replace only the managed section
    new_managed=$(sed -n '/kit:managed:start/,/kit:managed:end/p' "$NEW_BASE")

    if [ "$DRY_RUN" = true ]; then
      echo "  UPDATE: AGENTS.md (kit-managed section only, your content preserved)"
      updated=$((updated + 1))
    else
      {
        sed -n '1,/kit:managed:start/p' "$OLD_AGENTS" | head -n -1
        echo "$new_managed"
        sed -n '/kit:managed:end/,$p' "$OLD_AGENTS" | tail -n +2
      } > "$TARGET/AGENTS.md.new"
      mv "$TARGET/AGENTS.md.new" "$TARGET/AGENTS.md"
      echo "  UPDATE: AGENTS.md (kit-managed section only, your content preserved)"
      updated=$((updated + 1))
    fi
  else
    # No markers — inject them around the base sections for future updates
    echo "  NOTE: AGENTS.md has no kit:managed markers. Adding them for future updates."
    echo "        Review the result — your custom content should be outside the markers."

    if [ "$DRY_RUN" = false ]; then
      if grep -q '## Reference docs' "$OLD_AGENTS" && grep -q '## Tool-specific entry points' "$OLD_AGENTS"; then
        new_managed=$(sed -n '/kit:managed:start/,/kit:managed:end/p' "$NEW_BASE")
        {
          sed -n '1,/## Reference docs/p' "$OLD_AGENTS" | head -n -1
          echo "$new_managed"
          sed -n '/## Tool-specific entry points/,$p' "$OLD_AGENTS"
        } > "$TARGET/AGENTS.md.new"
        mv "$TARGET/AGENTS.md.new" "$TARGET/AGENTS.md"
        echo "  UPDATE: AGENTS.md (markers added, base sections refreshed)"
      else
        echo "  SKIP: AGENTS.md structure not recognized — update manually"
      fi
    fi
    updated=$((updated + 1))
  fi

  # Migrate docs/ → .kit/ references in AGENTS.md
  if [ "$DRY_RUN" = false ] && grep -q '`docs/' "$TARGET/AGENTS.md" 2>/dev/null; then
    sed -i 's|`docs/|`.kit/|g' "$TARGET/AGENTS.md"
    echo "  UPDATE: AGENTS.md docs/ → .kit/ path migration"
  fi
fi

# ── Remove files that shouldn't exist ───────────────────────────────────────
echo "==> Cleaning up..."
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
