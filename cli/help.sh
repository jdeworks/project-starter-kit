#!/usr/bin/env bash
# help.sh — unified help for project-starter-kit CLI
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"

VALID_VARIANTS="website saas api-service monorepo game-dev mcp-server cli-tool mobile-app desktop-app/cross-platform desktop-app/native"

cat << 'EOF'
project-starter-kit — AI-agent quality layer for any project type
=================================================================

Quick start (navigate to your project folder, then):

  bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh)

Commands (run from inside the kit repo):

  bash cli/get.sh        One-command setup: download + compose (no git history)
  bash cli/init.sh       Create a new project (git init + compose)
  bash cli/compose.sh    Copy base + variant + starter into a directory
  bash cli/migrate.sh    Analyze existing repo and generate migration guide
  bash cli/upgrade.sh    Upgrade lean mode to full mode
  bash cli/update.sh     Update starter-kit files to latest version
  bash cli/status.sh     Show kit status and variant details
  bash cli/validate.sh   Verify doc references and run hook smoke tests
  bash cli/test.sh       Run CLI integration tests
  bash cli/bundle.sh     Generate bundle.xml for online AI agents
  bash cli/help.sh       Show this help

EOF

echo "Available variants:"
echo ""
for v in $VALID_VARIANTS; do
  doc_count=0
  if [ -d "$KIT_ROOT/$v/.kit" ]; then
    doc_count=$(find "$KIT_ROOT/$v/.kit" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
  fi
  printf "  %-32s %s\n" "$v" "${doc_count} docs"
done

cat << 'EOF'

Modes:

  full    All enforcement active (3 test tiers, all hooks, CHANGES.md required)
  lean    Reduced enforcement (feature tests only, optional CHANGES.md)

Examples:

  # Quickest way — interactive, picks variant + starter
  bash <(curl -sL .../cli/get.sh)

  # With variant + starter specified
  bash <(curl -sL .../cli/get.sh) game-dev --starter pixijs

  # New project (from inside the kit repo)
  bash cli/init.sh --variant website --starter vanilla --mode full --name my-site

  # Existing repo
  bash cli/compose.sh --variant api-service --starter hono --mode lean --target /path/to/repo

  # Preview without writing
  bash cli/compose.sh --variant website --starter react --target ./my-site --dry-run

For more info: https://github.com/jdeworks/project-starter-kit
EOF
