#!/usr/bin/env bash
# test.sh — integration tests for the CLI scripts
# Usage: bash cli/test.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(dirname "$SCRIPT_DIR")"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  cat << 'HELPEOF'
Usage: bash cli/test.sh

Runs integration tests for init.sh, compose.sh, migrate.sh, and upgrade.sh
against temporary directories. Cleans up after itself.
HELPEOF
  exit 0
fi

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }

echo ""
echo "project-starter-kit CLI tests"
echo "=============================="
echo "Temp dir: $TMPDIR"
echo ""

# ── Test 1: compose.sh — basic compose ───────────────────────────────────────
echo "--- Test: compose.sh (website, full) ---"
TEST_DIR="$TMPDIR/test-compose"
mkdir -p "$TEST_DIR"
bash "$SCRIPT_DIR/compose.sh" --variant website --mode full --target "$TEST_DIR" --yes > /dev/null 2>&1

[ -f "$TEST_DIR/AGENTS.md" ] && pass "AGENTS.md created" || fail "AGENTS.md missing"
[ -f "$TEST_DIR/Makefile" ] && pass "Makefile created" || fail "Makefile missing"
[ -f "$TEST_DIR/.claude/settings.json" ] && pass ".claude/settings.json created" || fail ".claude/settings.json missing"
[ -d "$TEST_DIR/.kit" ] && pass ".kit/ created" || fail ".kit/ missing"
[ -d "$TEST_DIR/scripts" ] && pass "scripts/ created" || fail "scripts/ missing"
[ -x "$TEST_DIR/scripts/health-check.sh" ] && pass "health-check.sh is executable" || fail "health-check.sh not executable"
grep -q "Default: \*\*full\*\*" "$TEST_DIR/AGENTS.md" && pass "Mode set to full" || fail "Mode not set to full"

# Check variant docs were merged
[ -f "$TEST_DIR/.kit/stack-choice.md" ] && pass "Variant .kit/ merged" || fail "Variant .kit/ missing"
echo ""

# ── Test: compose.sh — with starter ─────────────────────────────────────────
echo "--- Test: compose.sh (game-dev + pixijs starter) ---"
TEST_DIR="$TMPDIR/test-starter"
mkdir -p "$TEST_DIR"
bash "$SCRIPT_DIR/compose.sh" --variant game-dev --starter pixijs --mode full --target "$TEST_DIR" --yes > /dev/null 2>&1

[ -f "$TEST_DIR/package.json" ] && pass "Starter package.json copied" || fail "Starter package.json missing"
[ -d "$TEST_DIR/src" ] && pass "Starter src/ copied" || fail "Starter src/ missing"
[ -f "$TEST_DIR/AGENTS.md" ] && pass "Base AGENTS.md present with starter" || fail "AGENTS.md missing"
[ ! -d "$TEST_DIR/starters" ] && pass "No starters/ dir in target" || fail "starters/ dir leaked to target"
echo ""

# ── Test: compose.sh — without starter (no starter files) ──────────────────
echo "--- Test: compose.sh (website, no starter) ---"
TEST_DIR="$TMPDIR/test-no-starter"
mkdir -p "$TEST_DIR"
bash "$SCRIPT_DIR/compose.sh" --variant website --mode full --target "$TEST_DIR" --yes > /dev/null 2>&1

[ ! -f "$TEST_DIR/package.json" ] && pass "No package.json without starter" || fail "Unexpected package.json"
[ ! -d "$TEST_DIR/starters" ] && pass "No starters/ dir without starter" || fail "starters/ dir leaked"
echo ""

# ── Test 2: compose.sh — lean mode ──────────────────────────────────────────
echo "--- Test: compose.sh (api-service, lean) ---"
TEST_DIR="$TMPDIR/test-lean"
mkdir -p "$TEST_DIR"
bash "$SCRIPT_DIR/compose.sh" --variant api-service --mode lean --target "$TEST_DIR" --yes > /dev/null 2>&1

grep -q "Default: \*\*lean\*\*" "$TEST_DIR/AGENTS.md" && pass "Mode set to lean" || fail "Mode not set to lean"
echo ""

# ── Test 3: compose.sh — non-destructive merge ──────────────────────────────
echo "--- Test: compose.sh (non-destructive merge) ---"
TEST_DIR="$TMPDIR/test-merge"
mkdir -p "$TEST_DIR"
echo "existing content" > "$TEST_DIR/AGENTS.md"
bash "$SCRIPT_DIR/compose.sh" --variant website --mode full --target "$TEST_DIR" --yes > /dev/null 2>&1

content=$(cat "$TEST_DIR/AGENTS.md")
if [ "$content" = "existing content" ]; then
  pass "Existing AGENTS.md preserved (not overwritten)"
else
  fail "Existing AGENTS.md was overwritten"
fi
echo ""

# ── Test 4: compose.sh — dry run ────────────────────────────────────────────
echo "--- Test: compose.sh (--dry-run) ---"
TEST_DIR="$TMPDIR/test-dryrun"
mkdir -p "$TEST_DIR"
output=$(bash "$SCRIPT_DIR/compose.sh" --variant saas --mode full --target "$TEST_DIR" --dry-run 2>&1)

echo "$output" | grep -q '\[dry-run\]' && pass "Dry run output contains [dry-run]" || fail "No dry-run markers"
[ "$(ls -A "$TEST_DIR" 2>/dev/null | wc -l)" -eq 0 ] && pass "No files written in dry run" || fail "Files written during dry run"
echo ""

# ── Test 5: compose.sh — help ───────────────────────────────────────────────
echo "--- Test: compose.sh (--help) ---"
output=$(bash "$SCRIPT_DIR/compose.sh" --help 2>&1)
echo "$output" | grep -q "Usage:" && pass "--help shows usage" || fail "--help missing usage"
echo ""

# ── Test 6: migrate.sh ──────────────────────────────────────────────────────
echo "--- Test: migrate.sh ---"
TEST_DIR="$TMPDIR/test-migrate"
mkdir -p "$TEST_DIR"
echo '{"dependencies":{"vitest":"^4"}}' > "$TEST_DIR/package.json"
mkdir -p "$TEST_DIR/src"
echo "console.log('test')" > "$TEST_DIR/src/index.ts"

bash "$SCRIPT_DIR/migrate.sh" --variant api-service --target "$TEST_DIR" > /dev/null 2>&1

[ -f "$TEST_DIR/MIGRATION.md" ] && pass "MIGRATION.md created" || fail "MIGRATION.md missing"
grep -q "Source LOC" "$TEST_DIR/MIGRATION.md" && pass "MIGRATION.md has LOC analysis" || fail "MIGRATION.md missing LOC"
echo ""

# ── Test 7: migrate.sh — dry run ────────────────────────────────────────────
echo "--- Test: migrate.sh (--dry-run) ---"
TEST_DIR="$TMPDIR/test-migrate-dry"
mkdir -p "$TEST_DIR"
echo '{}' > "$TEST_DIR/package.json"
output=$(bash "$SCRIPT_DIR/migrate.sh" --variant website --target "$TEST_DIR" --dry-run 2>&1)

echo "$output" | grep -q '\[dry-run\]' && pass "Dry run output present" || fail "No dry-run markers"
[ ! -f "$TEST_DIR/MIGRATION.md" ] && pass "No MIGRATION.md written" || fail "MIGRATION.md written during dry run"
echo ""

# ── Test 8: upgrade.sh ──────────────────────────────────────────────────────
echo "--- Test: upgrade.sh ---"
TEST_DIR="$TMPDIR/test-upgrade"
mkdir -p "$TEST_DIR/scripts" "$TEST_DIR/.claude/hooks"
cp "$KIT_ROOT/base/AGENTS.md" "$TEST_DIR/AGENTS.md"
cp "$KIT_ROOT/base/scripts/health-check.sh" "$TEST_DIR/scripts/"
chmod +x "$TEST_DIR/scripts/health-check.sh"
# Set to lean first
sed -i 's/Default: \*\*full\*\*/Default: **lean**/' "$TEST_DIR/AGENTS.md"

(cd "$TEST_DIR" && bash "$SCRIPT_DIR/upgrade.sh") > /dev/null 2>&1

grep -q "Default: \*\*full\*\*" "$TEST_DIR/AGENTS.md" && pass "Mode upgraded to full" || fail "Mode not upgraded"
echo ""

# ── Test 9: health-check.sh — with SRC_EXTENSIONS ───────────────────────────
echo "--- Test: health-check.sh (SRC_EXTENSIONS=py) ---"
TEST_DIR="$TMPDIR/test-health"
mkdir -p "$TEST_DIR/src"
# Create a small python file
printf 'def hello():\n    print("hi")\n' > "$TEST_DIR/src/main.py"
SRC_DIR="$TEST_DIR/src" SRC_EXTENSIONS="py" bash "$KIT_ROOT/base/scripts/health-check.sh" > /dev/null 2>&1 && pass "Health check passes for .py files" || fail "Health check failed for .py"
echo ""

# ── Test 10: validate.sh ────────────────────────────────────────────────────
echo "--- Test: validate.sh ---"
bash "$SCRIPT_DIR/validate.sh" > /dev/null 2>&1 && pass "Validate passes" || fail "Validate failed"
echo ""

# ── Summary ──────────────────────────────────────────────────────────────────
echo "=============================="
echo "Results: $PASS passed, $FAIL failed"
echo ""

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
