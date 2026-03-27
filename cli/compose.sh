#!/usr/bin/env bash
# compose.sh — copies base + a chosen variant into an existing (empty or new) repo
# Usage: bash cli/compose.sh --variant website --mode full --target /path/to/repo
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"

# ── Defaults ──────────────────────────────────────────────────────────────────
VARIANT=""
MODE="full"
TARGET=""
DRY_RUN=false
AUTO_YES=false

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

# ── Argument parsing ──────────────────────────────────────────────────────────
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

# ── Validation ────────────────────────────────────────────────────────────────
VALID_VARIANTS="website saas api-service monorepo game-dev mcp-server cli-tool mobile-app desktop-app/cross-platform desktop-app/native"

# ── Interactive mode (if missing required args) ──────────────────────────────
if [ -z "$VARIANT" ] || [ -z "$TARGET" ]; then
  if [ ! -t 0 ]; then
    echo "Error: --variant and --target are required in non-interactive mode."
    echo "Run with --help for usage."
    exit 1
  fi
  echo ""
  echo "project-starter-kit compose (interactive)"
  echo "=========================================="
  echo ""
  if [ -z "$VARIANT" ]; then
    echo "Available variants:"
    i=1
    for v in $VALID_VARIANTS; do
      printf "  %2d) %s\n" "$i" "$v"
      i=$((i+1))
    done
    echo ""
    read -r -p "Pick a variant (number or name): " variant_input
    if [[ "$variant_input" =~ ^[0-9]+$ ]]; then
      VARIANT=$(echo "$VALID_VARIANTS" | tr ' ' '\n' | sed -n "${variant_input}p")
    else
      VARIANT="$variant_input"
    fi
  fi
  if [ -z "$TARGET" ]; then
    read -r -p "Target directory: " TARGET
  fi
  if [ "$MODE" = "full" ]; then
    read -r -p "Mode (full/lean) [full]: " mode_input
    MODE="${mode_input:-full}"
  fi
fi

if [ ! -d "$KIT_ROOT/$VARIANT" ]; then
  echo "Error: variant '$VARIANT' not found in $KIT_ROOT"
  echo "Valid variants: $VALID_VARIANTS"
  exit 1
fi

if [[ "$MODE" != "full" && "$MODE" != "lean" ]]; then
  echo "Error: --mode must be 'full' or 'lean'"
  exit 1
fi

# ── Confirmation ──────────────────────────────────────────────────────────────
echo ""
echo "project-starter-kit compose"
echo "==========================="
echo "  Variant : $VARIANT"
echo "  Mode    : $MODE"
echo "  Target  : $TARGET"
echo ""

existing_files=$(ls -A "$TARGET" 2>/dev/null | { grep -v '^\.' || true; } | wc -l | tr -d ' ')
if [ "$existing_files" -gt 0 ]; then
  echo "Warning: target directory is not empty ($existing_files files/dirs found)."
  echo "Files will be merged. Existing files will NOT be overwritten."
  echo ""
fi

# ── Dry run ───────────────────────────────────────────────────────────────────
if [ "$DRY_RUN" = true ]; then
  echo ""
  echo "[dry-run] Would copy from base/:"
  find "$KIT_ROOT/base" -type f -not -path '*/.git/*' | sed "s|$KIT_ROOT/base/|  |" | sort
  echo ""
  echo "[dry-run] Would copy from $VARIANT/:"
  find "$KIT_ROOT/$VARIANT" -type f -not -path '*/.git/*' | sed "s|$KIT_ROOT/$VARIANT/|  |" | sort
  echo ""
  echo "[dry-run] Mode would be set to: $MODE"
  echo "[dry-run] No files were written."
  exit 0
fi

if [ "$AUTO_YES" = false ] && [ -t 0 ]; then
  read -r -p "Continue? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }
fi

# ── Copy base layer ───────────────────────────────────────────────────────────
echo ""
echo "==> Copying base layer..."
cp -rn "$KIT_ROOT/base/." "$TARGET/" 2>/dev/null || true

# ── Copy variant layer (does not overwrite base files) ────────────────────────
echo "==> Copying $VARIANT variant..."
cp -rn "$KIT_ROOT/$VARIANT/." "$TARGET/" 2>/dev/null || true

# ── Mark mode in AGENTS.md ────────────────────────────────────────────────────
echo "==> Setting mode to '$MODE' in AGENTS.md..."
if grep -q "Default: \*\*full\*\*" "$TARGET/AGENTS.md" 2>/dev/null; then
  if [ "$MODE" = "lean" ]; then
    sed -i.bak 's/Default: \*\*full\*\*/Default: **lean**/' "$TARGET/AGENTS.md" && rm -f "$TARGET/AGENTS.md.bak"
  fi
fi

# ── Make scripts executable ───────────────────────────────────────────────────
echo "==> Making scripts executable..."
find "$TARGET/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find "$TARGET/.claude/hooks" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find "$TARGET/.opencode/hooks" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# ── Detect stack and write Makefile.stack ─────────────────────────────────────
echo "==> Detecting stack..."
DETECTED_STACK=""

if [ -f "$TARGET/package.json" ]; then
  DETECTED_STACK="node"
elif [ -f "$TARGET/go.mod" ]; then
  DETECTED_STACK="go"
elif [ -f "$TARGET/Cargo.toml" ]; then
  DETECTED_STACK="rust"
elif [ -f "$TARGET/requirements.txt" ] || [ -f "$TARGET/pyproject.toml" ] || [ -f "$TARGET/setup.py" ]; then
  DETECTED_STACK="python"
elif ls "$TARGET"/*.csproj "$TARGET"/*.sln >/dev/null 2>&1; then
  DETECTED_STACK="dotnet"
fi

if [ -n "$DETECTED_STACK" ]; then
  echo "    Detected: $DETECTED_STACK"
  if [ -f "$KIT_ROOT/base/stacks/$DETECTED_STACK/Makefile.stack" ]; then
    if [ ! -f "$TARGET/Makefile.stack" ]; then
      cp "$KIT_ROOT/base/stacks/$DETECTED_STACK/Makefile.stack" "$TARGET/Makefile.stack"
      echo "    Wrote Makefile.stack ($DETECTED_STACK)"
    fi
  fi
  if [ -f "$KIT_ROOT/base/stacks/$DETECTED_STACK/gitignore.append" ]; then
    if ! grep -qF "# $DETECTED_STACK (auto-detected)" "$TARGET/.gitignore" 2>/dev/null; then
      echo "" >> "$TARGET/.gitignore"
      cat "$KIT_ROOT/base/stacks/$DETECTED_STACK/gitignore.append" >> "$TARGET/.gitignore"
      echo "    Appended $DETECTED_STACK entries to .gitignore"
    fi
  fi
else
  echo "    No known stack detected — using default Node.js Makefile"
fi

# ── Detect installed agents and clean up unused configs ──────────────────────
echo "==> Checking agent configs..."
# Keep all configs by default — only note what's detected
has_claude=false; has_cursor=false; has_windsurf=false; has_opencode=false; has_copilot=false
command -v claude >/dev/null 2>&1 && has_claude=true
[ -d "$HOME/.cursor" ] || command -v cursor >/dev/null 2>&1 && has_cursor=true
command -v windsurf >/dev/null 2>&1 && has_windsurf=true
command -v opencode >/dev/null 2>&1 && has_opencode=true
command -v gh >/dev/null 2>&1 && has_copilot=true

agents_found=""
$has_claude && agents_found="$agents_found Claude-Code"
$has_cursor && agents_found="$agents_found Cursor"
$has_windsurf && agents_found="$agents_found Windsurf"
$has_opencode && agents_found="$agents_found OpenCode"
$has_copilot && agents_found="$agents_found Copilot"

if [ -n "$agents_found" ]; then
  echo "    Detected:$agents_found"
else
  echo "    No agents detected (all configs kept for portability)"
fi
echo "    All agent configs included — remove unused ones manually if desired"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "✓ Done. Files written to: $TARGET"
echo ""
echo "Next steps:"
echo "  1. cd $TARGET"
echo "  2. Fill in the project overview and tech stack sections in AGENTS.md"
echo "  3. Run: make help"
echo "  4. Tell your agent: 'Read AGENTS.md and tell me what mode we're in'"
if [ "$MODE" = "lean" ]; then
  echo ""
  echo "  You're in lean mode. When ready for full enforcement: bash cli/upgrade.sh"
fi
if [ -n "$DETECTED_STACK" ] && [ "$DETECTED_STACK" != "node" ]; then
  echo ""
  echo "  Stack detected: $DETECTED_STACK — check Makefile.stack and update targets if needed."
  echo "  See docs/bring-your-own-stack.md for guidance."
fi
