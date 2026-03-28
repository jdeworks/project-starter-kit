#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# Expo build requires native tooling — verify install + tests only
if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
  echo "Using local node $(node -v)"
  echo "--- Installing dependencies ---"
  npm install
  echo "--- Running tests ---"
  npm test
  echo "--- Cleaning up ---"
  rm -rf node_modules
elif command -v docker >/dev/null 2>&1; then
  echo "node/npm not found; using docker node:20"
  docker run --rm -v "$DIR":/app -w /app node:20 bash -c 'npm install && npm test && rm -rf node_modules'
else
  echo "SKIP: neither node/npm nor docker available"
  exit 0
fi

echo "verify.sh passed"
