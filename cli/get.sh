#!/usr/bin/env bash
# get.sh — one-command setup: download kit, compose into current directory
# Usage: bash <(curl -sL .../get.sh) [variant] [--starter id] [--mode full|lean]
set -euo pipefail

VARIANT="" STARTER="" MODE="full"
REPO_URL="https://github.com/jdeworks/project-starter-kit.git"
BRANCH="dev"
VALID_VARIANTS="website saas api-service monorepo game-dev mcp-server cli-tool mobile-app desktop-app/cross-platform desktop-app/native"

show_help() {
  cat << 'EOF'
Usage: bash get.sh [variant] [--starter <id>] [--mode full|lean]

Run from the directory where you want your project. Downloads only what you need.

  bash get.sh                          # interactive — pick variant + starter
  bash get.sh game-dev --starter pixijs
  bash get.sh api-service --mode lean

Variants: website, api-service, saas, monorepo, cli-tool, mcp-server,
           mobile-app, game-dev, desktop-app/cross-platform, desktop-app/native
EOF
  exit 0
}

# ── Parse args ───────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) show_help ;;
    --starter) STARTER="$2"; shift 2 ;;
    --mode)    MODE="$2";    shift 2 ;;
    --lean)    MODE="lean";  shift ;;
    -*) echo "Unknown flag: $1. Use --help."; exit 1 ;;
    *) [ -z "$VARIANT" ] && VARIANT="$1" || { echo "Unexpected arg: $1"; exit 1; }; shift ;;
  esac
done

# ── Interactive variant selection ────────────────────────────────────────────
if [ -z "$VARIANT" ]; then
  [ ! -t 0 ] && { echo "Usage: bash get.sh <variant> [--starter id] [--mode full|lean]"; exit 1; }
  echo "" && echo "project-starter-kit" && echo "==================="
  echo "Available variants:"; i=1
  for v in $VALID_VARIANTS; do printf "  %2d) %s\n" "$i" "$v"; i=$((i+1)); done
  echo "" && read -r -p "Pick a variant (number or name): " vi
  if [[ "$vi" =~ ^[0-9]+$ ]]; then
    VARIANT=$(echo "$VALID_VARIANTS" | tr ' ' '\n' | sed -n "${vi}p")
  else VARIANT="$vi"; fi
fi

TARGET="$(pwd)"

# Check prerequisites
command -v git >/dev/null 2>&1 || { echo "Error: git is required."; exit 1; }

echo ""
echo "project-starter-kit"
echo "==================="
echo "  Variant : $VARIANT"
[ -n "$STARTER" ] && echo "  Starter : $STARTER"
echo "  Mode    : $MODE"
echo "  Target  : $TARGET"
echo ""

# ── Clone sparse into temp dir ───────────────────────────────────────────────
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "==> Downloading base + $VARIANT..."
if ! git clone --filter=blob:none --no-checkout --depth=1 -b "$BRANCH" \
  "$REPO_URL" "$TMPDIR/kit" 2>&1 | tail -1; then
  echo "Error: failed to clone. Check your network and access."; exit 1
fi

cd "$TMPDIR/kit"
git sparse-checkout init --cone 2>/dev/null || { echo "Error: requires git 2.25+."; exit 1; }

# Phase 1: fetch variant .kit/ docs + starters manifest (lightweight)
git sparse-checkout set base "$VARIANT/AGENTS.md" "$VARIANT/.kit" "$VARIANT/starters/starters.json" cli
git checkout "$BRANCH" 2>/dev/null

# ── Interactive starter selection (from manifest) ────────────────────────────
source cli/_helpers.sh
STARTERS_JSON="$VARIANT/starters/starters.json"
if [ -z "$STARTER" ] && [ -f "$STARTERS_JSON" ] && [ -t 0 ]; then
  echo ""
  echo "$(get_starters_prompt "$STARTERS_JSON")"
  list_starters "$STARTERS_JSON"
  echo "" && read -r -p "Pick a starter (number or id): " si
  if [[ "$si" =~ ^[0-9]+$ ]]; then
    STARTER=$(get_starter_id "$STARTERS_JSON" "$si")
  else STARTER="$si"; fi
fi

# Phase 2: fetch chosen starter files
if [ -n "$STARTER" ]; then
  echo "==> Downloading $STARTER starter..."
  git sparse-checkout add "$VARIANT/starters/$STARTER"
  git checkout "$BRANCH" 2>/dev/null
fi

# Verify download
[ -f "cli/compose.sh" ] || { echo "Error: download incomplete."; exit 1; }

# ── Compose into target ─────────────────────────────────────────────────────
echo "==> Composing project..."
COMPOSE_ARGS="--variant $VARIANT --mode $MODE --target $TARGET --yes"
[ -n "$STARTER" ] && COMPOSE_ARGS="$COMPOSE_ARGS --starter $STARTER"
bash cli/compose.sh $COMPOSE_ARGS

cd "$TARGET"
echo ""
echo "Done. Your project is ready in: $TARGET"
echo ""
echo "Next steps:"
[ -f "$TARGET/package.json" ] && echo "  npm install"
echo "  Tell your agent: 'Read AGENTS.md and tell me what mode we're in'"
