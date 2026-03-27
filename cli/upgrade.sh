#!/usr/bin/env bash
# upgrade.sh — upgrades a lean project to full mode
# Run from inside the project directory (not the kit root)
# Usage: bash /path/to/cli/upgrade.sh
set -euo pipefail

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  cat << 'HELPEOF'
Usage: bash cli/upgrade.sh

Upgrades a lean-mode project to full mode. Run from inside your project directory.

What it does:
  1. Updates AGENTS.md mode declaration from lean to full
  2. Ensures hook scripts are executable
  3. Creates Tier 2 architecture test file if missing
  4. Runs health check to show current state

No options — just run it from your project root.
HELPEOF
  exit 0
fi

echo ""
echo "project-starter-kit upgrade: lean → full"
echo "========================================="
echo ""

if [ ! -f "AGENTS.md" ]; then
  echo "Error: no AGENTS.md found. Run this from inside your project directory."
  exit 1
fi

# ── Update mode declaration ───────────────────────────────────────────────────
echo "==> Updating AGENTS.md mode to 'full'..."
sed -i.bak 's/Default: \*\*lean\*\*/Default: **full**/' AGENTS.md && rm -f AGENTS.md.bak

# ── Activate all hooks ────────────────────────────────────────────────────────
echo "==> Checking hooks..."
if [ ! -f ".claude/settings.json" ]; then
  echo "    Warning: .claude/settings.json not found — hooks may not be wired."
  echo "    Copy it from the kit's base/.claude/settings.json"
fi

# Ensure hook scripts are executable
find .claude/hooks -name "*.sh" -exec chmod +x {} \; 2>/dev/null && echo "    Claude Code hooks: executable" || true
find .opencode/hooks -name "*.sh" -exec chmod +x {} \; 2>/dev/null && echo "    OpenCode hooks: executable" || true

# ── Create architecture test directory if missing ─────────────────────────────
echo "==> Checking Tier 2 architecture test directory..."
if [ ! -d "tests/architecture" ]; then
  mkdir -p tests/architecture
  cat > tests/architecture/health.test.ts << 'TESTEOF'
// Architecture tests — Tier 2
// These enforce structural rules on the codebase itself.
// Run with: make test-arch
import { describe, it, expect } from 'vitest'
import { readFileSync } from 'fs'
import { globSync } from 'glob'

const SRC_GLOB = 'src/**/*.{ts,tsx}'
const EXCLUDE_TEST = (f: string) => !f.includes('.test.') && !f.includes('.spec.')

describe('file size limits', () => {
  it('no source file exceeds 350 LOC', () => {
    const violations: string[] = []
    globSync(SRC_GLOB).filter(EXCLUDE_TEST).forEach(f => {
      const lines = readFileSync(f, 'utf8').split('\n').length
      if (lines > 350) violations.push(`${f}: ${lines} lines`)
    })
    expect(violations, `Files over 350 LOC:\n${violations.join('\n')}`).toEqual([])
  })
})

describe('code quality', () => {
  it('no console.log in production source files', () => {
    const violations: string[] = []
    globSync(SRC_GLOB).filter(EXCLUDE_TEST).forEach(f => {
      const content = readFileSync(f, 'utf8')
      if (content.includes('console.log')) violations.push(f)
    })
    expect(violations, `Files with console.log:\n${violations.join('\n')}`).toEqual([])
  })
})
TESTEOF
  echo "    Created tests/architecture/health.test.ts"
fi

# ── Run health check ──────────────────────────────────────────────────────────
echo ""
echo "==> Running health check..."
if [ -f "scripts/health-check.sh" ]; then
  bash scripts/health-check.sh || true
else
  echo "    scripts/health-check.sh not found — skipping"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "✓ Upgrade complete. You are now in full mode."
echo ""
echo "Checklist before your first 'make check':"
echo "  [ ] Review health check output above and fix hard failures"
echo "  [ ] Ensure 'make test' passes (Tier 1 feature tests)"
echo "  [ ] Ensure 'make deadcode' passes (or note known exceptions)"
echo "  [ ] Add a CHANGES.md entry for this upgrade session"
