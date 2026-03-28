#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

HAS_NODE=false
HAS_CARGO=false
command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1 && HAS_NODE=true
command -v cargo >/dev/null 2>&1 && HAS_CARGO=true

if ! $HAS_NODE && ! command -v docker >/dev/null 2>&1; then
  echo "SKIP: neither node/npm nor docker available"
  exit 0
fi

if ! $HAS_CARGO; then
  echo "WARNING: cargo not found — skipping Rust backend build"
fi

run_frontend() {
  local npm_cmd="${1:-npm}"
  echo "--- Installing dependencies ---"
  $npm_cmd install
  if node -e "process.exit(Object.keys(require('./package.json').scripts||{}).includes('build')?0:1)" 2>/dev/null; then
    echo "--- Running build ---"
    $npm_cmd run build
  fi
  echo "--- Running tests ---"
  $npm_cmd test
  echo "--- Cleaning up ---"
  rm -rf node_modules
}

if $HAS_NODE; then
  echo "Using local node $(node -v)"
  run_frontend npm
else
  echo "node/npm not found; using docker node:20"
  docker run --rm -v "$DIR":/app -w /app node:20 bash -c '
    npm install &&
    if node -e "process.exit(Object.keys(require(\"./package.json\").scripts||{}).includes(\"build\")?0:1)"; then
      npm run build
    fi &&
    npm test &&
    rm -rf node_modules
  '
fi

echo "verify.sh passed"
