#!/usr/bin/env bash
# get.sh — one-command setup: clone sparse, compose, clean up
# Usage: bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) website my-site
# Or:    bash get.sh <variant> [project-name] [--mode full|lean]
set -euo pipefail

VARIANT="${1:-}"
NAME="${2:-}"
MODE="full"
REPO_URL="https://github.com/jdeworks/project-starter-kit.git"
BRANCH="dev"

show_help() {
  cat << 'EOF'
Usage: bash get.sh <variant> [project-name] [--mode full|lean]

Downloads the starter kit and sets up a new project with only the files you need.
No git history, no extra variants — just a clean project directory.

Examples:
  bash get.sh website my-site
  bash get.sh api-service my-api --mode lean
  bash get.sh saas my-saas

Variants: website, api-service, saas, monorepo, cli-tool, mcp-server,
           mobile-app, game-dev, desktop-app/cross-platform, desktop-app/native
EOF
  exit 0
}

for arg in "$@"; do
  case "$arg" in
    --help|-h) show_help ;;
    --mode) shift; MODE="${1:-full}" ;;
    --lean) MODE="lean" ;;
  esac
done

if [ -z "$VARIANT" ]; then
  echo "Usage: bash get.sh <variant> [project-name] [--mode full|lean]"
  echo "Run with --help for more info."
  exit 1
fi

NAME="${NAME:-my-project}"
TARGET="$(pwd)/$NAME"

if [ -d "$TARGET" ]; then
  echo "Error: directory '$TARGET' already exists."
  exit 1
fi

# Check prerequisites
if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required. Install it first."
  exit 1
fi

echo ""
echo "project-starter-kit"
echo "==================="
echo "  Variant : $VARIANT"
echo "  Mode    : $MODE"
echo "  Target  : $TARGET"
echo ""

# ── Clone sparse into temp dir ───────────────────────────────────────────────
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "==> Downloading base + $VARIANT..."
if ! git clone --filter=blob:none --no-checkout --depth=1 -b "$BRANCH" \
  "$REPO_URL" "$TMPDIR/kit" 2>&1 | tail -1; then
  echo "Error: failed to clone repository. Check your network connection."
  exit 1
fi

cd "$TMPDIR/kit"
if ! git sparse-checkout init --cone 2>&1; then
  echo "Error: sparse-checkout failed. Requires git 2.25+."
  exit 1
fi
git sparse-checkout set base "$VARIANT" cli
git checkout "$BRANCH"

# Verify files were actually downloaded
if [ ! -f "cli/compose.sh" ]; then
  echo "Error: download incomplete — cli/compose.sh not found."
  exit 1
fi

# ── Compose into target ─────────────────────────────────────────────────────
echo "==> Composing project..."
mkdir -p "$TARGET"
bash cli/compose.sh --variant "$VARIANT" --mode "$MODE" --target "$TARGET" --yes

cd "$TARGET"

echo ""
echo "Done. Your project is at: $TARGET"
echo ""
echo "Next steps:"
echo "  cd $NAME"
echo "  Tell your agent: 'Read AGENTS.md and tell me what mode we're in'"
