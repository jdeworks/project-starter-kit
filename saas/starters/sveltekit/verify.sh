#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

run_node_verify() {
  local npm_cmd="${1:-npm}"
  echo "--- Installing dependencies ---"
  $npm_cmd install
  if $npm_cmd run --silent env 2>/dev/null | grep -q build || \
     node -e "process.exit(Object.keys(require('./package.json').scripts||{}).includes('build')?0:1)" 2>/dev/null; then
    echo "--- Running build ---"
    $npm_cmd run build
  fi
  echo "--- Running tests ---"
  $npm_cmd test
  echo "--- Cleaning up ---"
  rm -rf node_modules
}

if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
  echo "Using local node $(node -v)"
  run_node_verify npm
elif command -v docker >/dev/null 2>&1; then
  echo "node/npm not found; using docker node:20"
  docker run --rm -v "$DIR":/app -w /app node:20 bash -c '
    npm install &&
    if node -e "process.exit(Object.keys(require(\"./package.json\").scripts||{}).includes(\"build\")?0:1)"; then
      npm run build
    fi &&
    npm test &&
    rm -rf node_modules
  '
else
  echo "SKIP: neither node/npm nor docker available"
  exit 0
fi

echo "verify.sh passed"
