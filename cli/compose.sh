#!/usr/bin/env bash
# compose.sh — copies base + a chosen variant into an existing (empty or new) repo
# Usage: bash cli/compose.sh --variant website --mode full --target /path/to/repo
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"
source "$SCRIPT_DIR/_helpers.sh"

VARIANT="" MODE="full" TARGET="" DRY_RUN=false AUTO_YES=false

show_help() {
  cat << 'HELPEOF'
Usage: bash cli/compose.sh --variant <variant> --mode <mode> --target <path>

Copies base layer + variant docs into an existing directory. Does not overwrite.

Options:
  --variant <name>   Variant to compose (required). See bash cli/help.sh for list.
  --mode <mode>      full or lean (default: full)
  --target <path>    Target directory (required)
  --dry-run          Show what would be copied without copying
  --yes, -y          Skip confirmation prompt
  --help, -h         Show this help
HELPEOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --variant)  VARIANT="$2"; shift 2 ;;
    --mode)     MODE="$2";    shift 2 ;;
    --target)   TARGET="$2";  shift 2 ;;
    --dry-run)  DRY_RUN=true; shift ;;
    --yes|-y)   AUTO_YES=true; shift ;;
    --help|-h)  show_help ;;
    *) echo "Unknown argument: $1. Use --help for usage."; exit 1 ;;
  esac
done

VALID_VARIANTS="website saas api-service monorepo game-dev mcp-server cli-tool mobile-app desktop-app/cross-platform desktop-app/native"

# ── Interactive mode (if missing required args) ──────────────────────────────
if [ -z "$VARIANT" ] || [ -z "$TARGET" ]; then
  if [ ! -t 0 ]; then
    echo "Error: --variant and --target are required in non-interactive mode."
    exit 1
  fi
  echo ""
  echo "project-starter-kit compose (interactive)"
  echo "=========================================="
  if [ -z "$VARIANT" ]; then
    echo "Available variants:"
    i=1
    for v in $VALID_VARIANTS; do printf "  %2d) %s\n" "$i" "$v"; i=$((i+1)); done
    echo ""
    read -r -p "Pick a variant (number or name): " variant_input
    if [[ "$variant_input" =~ ^[0-9]+$ ]]; then
      VARIANT=$(echo "$VALID_VARIANTS" | tr ' ' '\n' | sed -n "${variant_input}p")
    else
      VARIANT="$variant_input"
    fi
  fi
  [ -z "$TARGET" ] && read -r -p "Target directory: " TARGET
  read -r -p "Mode (full/lean) [full]: " mode_input
  MODE="${mode_input:-full}"
fi

# ── Validate ─────────────────────────────────────────────────────────────────
[ ! -d "$KIT_ROOT/$VARIANT" ] && { echo "Error: variant '$VARIANT' not found."; exit 1; }
[[ "$MODE" != "full" && "$MODE" != "lean" ]] && { echo "Error: --mode must be 'full' or 'lean'"; exit 1; }

# ── Confirm ──────────────────────────────────────────────────────────────────
echo ""
echo "project-starter-kit compose"
echo "==========================="
echo "  Variant : $VARIANT"
echo "  Mode    : $MODE"
echo "  Target  : $TARGET"
echo ""

existing=$(ls -A "$TARGET" 2>/dev/null | { grep -v '^\.' || true; } | wc -l | tr -d ' ')
[ "$existing" -gt 0 ] && echo "Warning: target not empty ($existing items). Existing files NOT overwritten." && echo ""

if [ "$DRY_RUN" = true ]; then
  echo "[dry-run] Would copy from base/:"
  find "$KIT_ROOT/base" -type f -not -path '*/.git/*' | sed "s|$KIT_ROOT/base/|  |" | sort
  echo ""
  echo "[dry-run] Would copy from $VARIANT/:"
  find "$KIT_ROOT/$VARIANT" -type f -not -path '*/.git/*' | sed "s|$KIT_ROOT/$VARIANT/|  |" | sort
  echo "[dry-run] Mode: $MODE. No files written."
  exit 0
fi

if [ "$AUTO_YES" = false ] && [ -t 0 ]; then
  read -r -p "Continue? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }
fi

# ── Copy layers (exclude kit-internal files, variant AGENTS.md replaces base) ─
echo "==> Copying base layer..."
while IFS= read -r -d '' f; do
  rel="${f#$KIT_ROOT/base/}"
  case "$rel" in stacks/*|repomix.config.json|README.md) continue ;; esac
  dest="$TARGET/$rel"
  [ -d "$(dirname "$dest")" ] || mkdir -p "$(dirname "$dest")"
  [ -e "$dest" ] || cp "$f" "$dest"
done < <(find "$KIT_ROOT/base" -type f -not -path '*/.git/*' -print0 2>/dev/null)

echo "==> Copying $VARIANT variant..."
while IFS= read -r -d '' f; do
  rel="${f#$KIT_ROOT/$VARIANT/}"
  case "$rel" in README.md) continue ;; esac
  dest="$TARGET/$rel"
  [ -d "$(dirname "$dest")" ] || mkdir -p "$(dirname "$dest")"
  if [ "$rel" = "AGENTS.md" ]; then
    # Merge: append variant content into base AGENTS.md (skip if user already modified it)
    if [ -e "$dest" ] && grep -q '<!-- FILL IN' "$dest" 2>/dev/null; then
      # Base template exists — append variant content (skip the "Extends base" header line)
      echo "" >> "$dest"
      sed '1,/^---$/d' "$f" >> "$dest" 2>/dev/null || cat "$f" >> "$dest"
    elif [ ! -e "$dest" ]; then
      cp "$f" "$dest"
    fi
  else
    [ -e "$dest" ] || cp "$f" "$dest"
  fi
done < <(find "$KIT_ROOT/$VARIANT" -type f -not -path '*/.git/*' -print0 2>/dev/null)

# ── Set mode ─────────────────────────────────────────────────────────────────
if [ "$MODE" = "lean" ] && grep -q "Default: \*\*full\*\*" "$TARGET/AGENTS.md" 2>/dev/null; then
  sed -i.bak 's/Default: \*\*full\*\*/Default: **lean**/' "$TARGET/AGENTS.md" && rm -f "$TARGET/AGENTS.md.bak"
fi

# ── Make scripts executable ──────────────────────────────────────────────────
find "$TARGET/scripts" "$TARGET/.claude/hooks" "$TARGET/.opencode/hooks" \
  -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# ── Stack + agent detection ──────────────────────────────────────────────────
echo "==> Detecting stack..."
apply_stack "$TARGET" "$KIT_ROOT"
echo "==> Checking agent configs..."
detect_agents

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo "Done. Files written to: $TARGET"
echo ""
echo "Next steps:"
echo "  1. cd $TARGET"
echo "  2. Fill in project overview and tech stack in AGENTS.md"
echo "  3. Tell your agent: 'Read AGENTS.md and tell me what mode we're in'"
[ "$MODE" = "lean" ] && echo "" && echo "  Lean mode. Upgrade anytime: bash cli/upgrade.sh"
if [ -n "${DETECTED_STACK:-}" ] && [ "$DETECTED_STACK" != "node" ]; then
  echo "" && echo "  Stack: $DETECTED_STACK — see docs/bring-your-own-stack.md"
fi
