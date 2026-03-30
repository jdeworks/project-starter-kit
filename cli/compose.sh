#!/usr/bin/env bash
# compose.sh — copies base + a chosen variant into an existing (empty or new) repo
# Usage: bash cli/compose.sh --variant website --mode full --target /path/to/repo
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"
source "$SCRIPT_DIR/_helpers.sh"

VARIANT="" MODE="full" TARGET="" STARTER="" DRY_RUN=false AUTO_YES=false

show_help() {
  cat << 'HELPEOF'
Usage: bash cli/compose.sh --variant <name> [--starter <id>] [--mode full|lean] --target <path>

Options:
  --variant <name>   Variant (required). --starter <id>  Starter template (e.g. pixijs).
  --mode <mode>      full or lean (default: full).  --target <path>  Target dir (required).
  --dry-run          Preview only.  --yes|-y  Skip prompt.  --help|-h  This help.
HELPEOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --variant)  VARIANT="$2";  shift 2 ;;
    --starter)  STARTER="$2";  shift 2 ;;
    --mode)     MODE="$2";     shift 2 ;;
    --target)   TARGET="$2";   shift 2 ;;
    --dry-run)  DRY_RUN=true; shift ;;
    --yes|-y)   AUTO_YES=true; shift ;;
    --help|-h)  show_help ;;
    *) echo "Unknown argument: $1. Use --help for usage."; exit 1 ;;
  esac
done

VALID_VARIANTS="website saas api-service monorepo game-dev mcp-server cli-tool mobile-app desktop-app/cross-platform desktop-app/native"

# ── Interactive mode (if missing required args) ──────────────────────────────
if [ -z "$VARIANT" ] || [ -z "$TARGET" ]; then
  [ ! -t 0 ] && { echo "Error: --variant and --target are required in non-interactive mode."; exit 1; }
  echo "" && echo "project-starter-kit compose (interactive)" && echo "=========================================="
  if [ -z "$VARIANT" ]; then
    echo "Available variants:"; i=1
    for v in $VALID_VARIANTS; do printf "  %2d) %s\n" "$i" "$v"; i=$((i+1)); done
    echo "" && read -r -p "Pick a variant (number or name): " variant_input
    [[ "$variant_input" =~ ^[0-9]+$ ]] && VARIANT=$(echo "$VALID_VARIANTS" | tr ' ' '\n' | sed -n "${variant_input}p") || VARIANT="$variant_input"
  fi
  [ -z "$TARGET" ] && read -r -p "Target directory: " TARGET
  read -r -p "Mode (full/lean) [full]: " mode_input && MODE="${mode_input:-full}"
fi

# ── Interactive starter selection ────────────────────────────────────────────
STARTERS_JSON="$KIT_ROOT/$VARIANT/starters/starters.json"
if [ -z "$STARTER" ] && [ -f "$STARTERS_JSON" ] && [ -t 0 ]; then
  echo ""
  echo "$(get_starters_prompt "$STARTERS_JSON")"
  list_starters "$STARTERS_JSON"
  echo ""
  read -r -p "Pick a starter (number or id): " starter_input
  if [[ "$starter_input" =~ ^[0-9]+$ ]]; then
    STARTER=$(get_starter_id "$STARTERS_JSON" "$starter_input")
  else
    STARTER="$starter_input"
  fi
fi

# ── Validate ─────────────────────────────────────────────────────────────────
[ ! -d "$KIT_ROOT/$VARIANT" ] && { echo "Error: variant '$VARIANT' not found."; exit 1; }
[[ "$MODE" != "full" && "$MODE" != "lean" ]] && { echo "Error: --mode must be 'full' or 'lean'"; exit 1; }
if [ -n "$STARTER" ] && [ ! -d "$KIT_ROOT/$VARIANT/starters/$STARTER" ]; then
  echo "Error: starter '$STARTER' not found for variant '$VARIANT'."
  [ -f "$STARTERS_JSON" ] && echo "Available:" && list_starters "$STARTERS_JSON"
  exit 1
fi

# ── Confirm ──────────────────────────────────────────────────────────────────
echo ""
echo "project-starter-kit compose"
echo "==========================="
echo "  Variant : $VARIANT"
[ -n "$STARTER" ] && echo "  Starter : $STARTER"
echo "  Mode    : $MODE"
echo "  Target  : $TARGET"
echo ""

existing=$(ls -A "$TARGET" 2>/dev/null | { grep -v '^\.' || true; } | wc -l | tr -d ' ')
[ "$existing" -gt 0 ] && echo "Warning: target not empty ($existing items). Existing files NOT overwritten." && echo ""

if [ "$DRY_RUN" = true ]; then
  echo "[dry-run] base/:"; find "$KIT_ROOT/base" -type f -not -path '*/.git/*' | sed "s|$KIT_ROOT/base/|  |" | sort
  echo "[dry-run] $VARIANT/:"; find "$KIT_ROOT/$VARIANT" -type f -not -path '*/.git/*' -not -path '*/starters/*' | sed "s|$KIT_ROOT/$VARIANT/|  |" | sort
  [ -n "$STARTER" ] && echo "[dry-run] starter $STARTER/:" && find "$KIT_ROOT/$VARIANT/starters/$STARTER" -type f | sed "s|$KIT_ROOT/$VARIANT/starters/$STARTER/|  |" | sort
  echo "[dry-run] Mode: $MODE. No files written."; exit 0
fi

if [ "$AUTO_YES" = false ] && [ -t 0 ]; then
  read -r -p "Continue? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }
fi

# ── Copy layers (exclude kit-internal files, variant AGENTS.md replaces base) ─
echo "==> Copying base layer..."
copy_layer "$KIT_ROOT/base" "$TARGET" "stacks/*" "repomix.config.json" "README.md" \
  "HOOKS.md" "CONTRIBUTING.md" "docs/architecture.md" "docs/bring-your-own-stack.md" "scripts/verify-changes.sh"

echo "==> Copying $VARIANT variant..."
copy_layer "$KIT_ROOT/$VARIANT" "$TARGET" "README.md" "starters/*"

# Merge variant AGENTS.md into base AGENTS.md
VAGENTS="$KIT_ROOT/$VARIANT/AGENTS.md"
if [ -f "$VAGENTS" ]; then
  dest="$TARGET/AGENTS.md"
  if [ -e "$dest" ] && grep -q '<!-- FILL IN' "$dest" 2>/dev/null; then
    echo "" >> "$dest"
    sed '1,/^---$/d' "$VAGENTS" >> "$dest" 2>/dev/null || cat "$VAGENTS" >> "$dest"
  elif [ ! -e "$dest" ]; then
    cp "$VAGENTS" "$dest"
  fi
fi

# ── Copy starter template + verify ──────────────────────────────────────────
if [ -n "$STARTER" ]; then
  echo "==> Copying $STARTER starter..."
  copy_layer "$KIT_ROOT/$VARIANT/starters/$STARTER" "$TARGET"
  if [ -x "$TARGET/verify.sh" ]; then
    echo "==> Verifying starter..." && (cd "$TARGET" && bash verify.sh) || true; rm -f "$TARGET/verify.sh"
  fi
fi

# ── Set mode ─────────────────────────────────────────────────────────────────
if [ "$MODE" = "lean" ] && grep -q "Default: \*\*full\*\*" "$TARGET/AGENTS.md" 2>/dev/null; then
  sed -i.bak 's/Default: \*\*full\*\*/Default: **lean**/' "$TARGET/AGENTS.md" && rm -f "$TARGET/AGENTS.md.bak"
fi

# ── Make scripts executable ──────────────────────────────────────────────────
find "$TARGET/scripts" "$TARGET/.claude/hooks" "$TARGET/.opencode/hooks" \
  -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# ── Stack + agent detection ──────────────────────────────────────────────────
echo "==> Detecting stack..." && apply_stack "$TARGET" "$KIT_ROOT"
echo "==> Checking agent configs..." && detect_agents

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo "Done. Files written to: $TARGET"
echo ""
echo "Next steps:"
echo "  cd $TARGET"
echo "  Tell your agent: 'Read AGENTS.md and tell me what mode we're in'"
[ "$MODE" = "lean" ] && echo "  Lean mode. Upgrade anytime: bash cli/upgrade.sh"
if [ -n "${DETECTED_STACK:-}" ] && [ "$DETECTED_STACK" != "node" ]; then echo "  Stack: $DETECTED_STACK — see docs/bring-your-own-stack.md"; fi
