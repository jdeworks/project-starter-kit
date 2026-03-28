#!/usr/bin/env bash
# init.sh — creates a new project directory and composes the kit into it
# Usage: bash cli/init.sh --variant website --mode full --name my-project
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"

VARIANT=""
STARTER=""
MODE="full"
NAME=""
PARENT_DIR="$(pwd)"

VALID_VARIANTS="website saas api-service monorepo game-dev mcp-server cli-tool mobile-app desktop-app/cross-platform desktop-app/native"

show_help() {
  cat << 'HELPEOF'
Usage: bash cli/init.sh --variant <variant> --name <project-name> [options]

Creates a new project directory with git init and composes the kit into it.

Options:
  --variant <name>   Variant to use (required). See bash cli/help.sh for list.
  --starter <id>     Starter template (e.g. pixijs, hono). See starters.json per variant.
  --name <name>      Project name / directory name (required)
  --mode <mode>      full or lean (default: full)
  --parent <path>    Parent directory (default: current directory)
  --help, -h         Show this help
HELPEOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --variant) VARIANT="$2";  shift 2 ;;
    --starter) STARTER="$2"; shift 2 ;;
    --mode)    MODE="$2";    shift 2 ;;
    --name)    NAME="$2";    shift 2 ;;
    --parent)  PARENT_DIR="$2"; shift 2 ;;
    --help|-h) show_help ;;
    *) echo "Unknown argument: $1. Use --help for usage."; exit 1 ;;
  esac
done

# ── Interactive mode ─────────────────────────────────────────────────────────
if [ -z "$VARIANT" ] || [ -z "$NAME" ]; then
  if [ ! -t 0 ]; then
    echo "Error: --variant and --name are required in non-interactive mode."
    echo "Run with --help for usage."
    exit 1
  fi
  echo ""
  echo "project-starter-kit init (interactive)"
  echo "======================================="
  echo ""
  if [ -z "$NAME" ]; then
    read -r -p "Project name: " NAME
  fi
  if [ -z "$VARIANT" ]; then
    echo ""
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
  read -r -p "Mode (full/lean) [full]: " mode_input
  MODE="${mode_input:-full}"
fi

if [ -z "$VARIANT" ] || [ -z "$NAME" ]; then
  echo "Error: variant and name are required."
  exit 1
fi

TARGET="$PARENT_DIR/$NAME"

if [ -d "$TARGET" ]; then
  echo "Error: directory '$TARGET' already exists. Use compose.sh for existing directories."
  exit 1
fi

echo ""
echo "project-starter-kit init"
echo "========================"
echo "  Name    : $NAME"
echo "  Variant : $VARIANT"
echo "  Mode    : $MODE"
echo "  Location: $TARGET"
echo ""
read -r -p "Create project? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

mkdir -p "$TARGET"
git init "$TARGET" -b dev

COMPOSE_ARGS="--variant $VARIANT --mode $MODE --target $TARGET --yes"
[ -n "$STARTER" ] && COMPOSE_ARGS="$COMPOSE_ARGS --starter $STARTER"
bash "$SCRIPT_DIR/compose.sh" $COMPOSE_ARGS

# Create initial .gitignore
cat > "$TARGET/.gitignore" << 'EOF'
node_modules/
dist/
build/
.next/
out/
coverage/
*.local
.env
.env.*
!.env.example
*.log
.DS_Store
EOF

echo ""
echo "✓ Project '$NAME' created at $TARGET"
echo "  Git initialized on branch 'dev'"
