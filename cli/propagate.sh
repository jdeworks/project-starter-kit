#!/usr/bin/env bash
# propagate.sh — find downstream projects using the kit and update them
# Scans sibling directories for .claude/KIT_VERSION, runs update.sh on each.
# For own repos: auto-update + commit. For external repos: open a PR.
#
# Usage:
#   bash cli/propagate.sh                    # interactive — prompts per project
#   bash cli/propagate.sh --auto             # auto-update all own repos
#   bash cli/propagate.sh --dry-run          # show what would be updated
#   bash cli/propagate.sh --check            # exit 1 if any project is outdated (for CI)
#
# Called by: post-commit hook (interactive) or manually.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"
SEARCH_DIR="${SEARCH_DIR:-$(dirname "$KIT_ROOT")}"
MODE="${1:-}"

# ── Determine what changed in the last commit ────────────────────────────────
# Only propagate if base/ or variant files were touched
changed_files=$(git -C "$KIT_ROOT" diff --name-only HEAD~1 HEAD 2>/dev/null || echo "")

base_changed=false
if echo "$changed_files" | grep -q '^base/' 2>/dev/null; then
  base_changed=true
fi

# Collect changed variants
changed_variants=()
for variant in website api-service saas monorepo cli-tool mcp-server mobile-app game-dev desktop-app; do
  if echo "$changed_files" | grep -q "^${variant}/" 2>/dev/null; then
    changed_variants+=("$variant")
  fi
done

if [ "$base_changed" = false ] && [ ${#changed_variants[@]} -eq 0 ]; then
  # Nothing relevant changed — skip propagation
  [ "$MODE" = "--check" ] && exit 0
  exit 0
fi

# ── Get current kit version ──────────────────────────────────────────────────
kit_version=""
if [ -f "$KIT_ROOT/base/.claude/KIT_VERSION" ]; then
  kit_version=$(tr -d '[:space:]' < "$KIT_ROOT/base/.claude/KIT_VERSION")
fi

echo ""
echo "project-starter-kit propagation"
echo "================================"
echo "  Kit version : $kit_version"
echo "  Base changed: $base_changed"
[ ${#changed_variants[@]} -gt 0 ] && echo "  Variants    : ${changed_variants[*]}"
echo "  Searching   : $SEARCH_DIR"
echo ""

# ── Find downstream projects ─────────────────────────────────────────────────
found=0
outdated=0

for project_dir in "$SEARCH_DIR"/*/; do
  [ ! -f "$project_dir/.claude/KIT_VERSION" ] && continue
  [ "$project_dir" = "$KIT_ROOT/" ] && continue

  project_name=$(basename "$project_dir")
  project_version=$(tr -d '[:space:]' < "$project_dir/.claude/KIT_VERSION")
  found=$((found + 1))

  # Check if this project's variant was changed (or base was changed)
  needs_update=false
  if [ "$base_changed" = true ]; then
    needs_update=true
  else
    # Detect project's variant
    project_variant=""
    if [ -f "$project_dir/AGENTS.md" ]; then
      for variant in "${changed_variants[@]}"; do
        case "$variant" in
          game-dev)   grep -q 'game-architecture\|game-loop\|Game-specific' "$project_dir/AGENTS.md" 2>/dev/null && project_variant="$variant" ;;
          saas)       grep -q 'saas-architecture\|multi-tenancy\|SaaS-specific' "$project_dir/AGENTS.md" 2>/dev/null && project_variant="$variant" ;;
          api-service) grep -q 'api-architecture\|API-specific' "$project_dir/AGENTS.md" 2>/dev/null && project_variant="$variant" ;;
          website)    grep -q 'website\|Website-specific' "$project_dir/AGENTS.md" 2>/dev/null && project_variant="$variant" ;;
          *)          grep -qi "${variant}\|${variant//-/ }" "$project_dir/AGENTS.md" 2>/dev/null && project_variant="$variant" ;;
        esac
        [ -n "$project_variant" ] && break
      done
    fi
    [ -n "$project_variant" ] && needs_update=true
  fi

  if [ "$needs_update" = false ]; then
    continue
  fi

  # Check if version already matches
  if [ "$project_version" = "$kit_version" ]; then
    echo "  $project_name — already at $kit_version"
    continue
  fi

  outdated=$((outdated + 1))
  echo "  $project_name — $project_version → $kit_version"

  if [ "$MODE" = "--dry-run" ] || [ "$MODE" = "--check" ]; then
    continue
  fi

  # Determine if we own the repo (can push directly) or need a PR
  can_push=false
  remote_url=$(git -C "$project_dir" remote get-url origin 2>/dev/null || echo "")
  if echo "$remote_url" | grep -q 'jdeworks' 2>/dev/null; then
    can_push=true
  fi

  if [ "$can_push" = true ]; then
    # ── Own repo: update + commit ──────────────────────────────────────────
    if [ "$MODE" != "--auto" ]; then
      printf "    Update %s? [y/N] " "$project_name"
      read -r answer < /dev/tty 2>/dev/null || answer="n"
      [[ "$answer" != [yY]* ]] && echo "    Skipped." && continue
    fi

    echo "    Updating $project_name..."
    update_output=$(bash "$KIT_ROOT/cli/update.sh" --target "$project_dir" 2>&1)
    update_status=$?

    if [ $update_status -eq 0 ]; then
      # Commit the update
      cd "$project_dir"
      git add -A .claude/ .opencode/ .cursor/ .windsurf/ .github/ scripts/ .kit/ AGENTS.md .gitignore 2>/dev/null || true
      # Only commit if there are staged changes
      if ! git diff --cached --quiet 2>/dev/null; then
        git commit -m "chore: Update starter-kit to $kit_version

Automated update via project-starter-kit propagation.
Stop any running AI sessions to pick up the new hooks and rules." 2>/dev/null
        echo "    Committed. Note: stop running sessions to pick up changes."
      else
        echo "    No changes to commit (already up to date after update)."
      fi
      cd "$KIT_ROOT"
    else
      echo "    Update failed: $update_output"
    fi
  else
    # ── External repo: we'd open a PR, but skip for now ────────────────────
    echo "    External repo (no push access) — skipping. Would open PR in future."
  fi
done

echo ""
echo "Found $found downstream project(s), $outdated need update(s)."

if [ "$MODE" = "--check" ] && [ "$outdated" -gt 0 ]; then
  exit 1
fi

exit 0
