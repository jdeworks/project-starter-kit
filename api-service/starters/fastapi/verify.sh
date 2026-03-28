#!/usr/bin/env bash
set -euo pipefail

cleanup() {
  find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
  rm -rf .pytest_cache *.egg-info src/*.egg-info
}
trap cleanup EXIT

if command -v python3 &>/dev/null && command -v pip &>/dev/null; then
  echo "==> Running with local Python"
  pip install -e ".[dev]" --quiet
  pytest
elif command -v docker &>/dev/null; then
  echo "==> Running with Docker (python:3.12-slim)"
  docker run --rm -v "$(pwd):/app" -w /app python:3.12-slim \
    sh -c "pip install -e '.[dev]' --quiet && pytest"
else
  echo "SKIP: neither python3+pip nor docker found"
  exit 0
fi
