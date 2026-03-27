#!/usr/bin/env bash
# bundle.sh — generate bundle.xml for a variant (for online AI agents)
# Usage: bash cli/bundle.sh --variant website --target /path/to/repo
# Requires: npx repomix (npm install -g repomix)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"

VARIANT=""
TARGET=""

show_help() {
  cat << 'HELPEOF'
Usage: bash cli/bundle.sh --variant <variant> [--target <path>]

Generates a bundle.xml file for use with online AI agents (ChatGPT, Gemini, etc.).
Uses repomix to bundle the base layer + variant into a single XML file.

Options:
  --variant <name>   Variant to bundle (required)
  --target <path>    Where to write bundle.xml (default: current directory)
  --help, -h         Show this help

Requires: npx repomix (install with: npm install -g repomix)
HELPEOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --variant)  VARIANT="$2"; shift 2 ;;
    --target)   TARGET="$2";  shift 2 ;;
    --help|-h)  show_help ;;
    *) echo "Unknown argument: $1. Use --help for usage."; exit 1 ;;
  esac
done

if [ -z "$VARIANT" ]; then
  echo "Error: --variant is required."
  exit 1
fi

TARGET="${TARGET:-.}"

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: npx not found. Install Node.js first."
  exit 1
fi

# Build a temporary directory with base + variant merged
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "==> Merging base + $VARIANT for bundling..."
cp -r "$KIT_ROOT/base/." "$TMPDIR/"
cp -r "$KIT_ROOT/$VARIANT/." "$TMPDIR/" 2>/dev/null || true

# Remove files that aren't useful in a bundle
rm -rf "$TMPDIR/.claude" "$TMPDIR/.cursor" "$TMPDIR/.windsurf" "$TMPDIR/.opencode" \
       "$TMPDIR/.github" "$TMPDIR/scripts" "$TMPDIR/stacks" "$TMPDIR/SESSION_SUMMARY.md" \
       "$TMPDIR/CHANGES.md" "$TMPDIR/repomix.config.json" 2>/dev/null || true

echo "==> Generating bundle.xml..."
npx repomix "$TMPDIR" --output "$TARGET/bundle.xml" --style xml 2>/dev/null

echo ""
echo "✓ bundle.xml written to $TARGET/bundle.xml"
echo ""
echo "To use with an online AI agent:"
echo "  1. Copy the contents of bundle.xml"
echo "  2. Paste into ChatGPT, Gemini, or any AI chat"
echo "  3. Say: 'Read this project context and tell me what mode we're in'"
