#!/usr/bin/env bash
set -euo pipefail

if command -v dotnet &>/dev/null; then
  echo "==> Running with local .NET SDK"
  cd Tests && dotnet test
elif command -v docker &>/dev/null; then
  echo "==> Running with Docker (dotnet/sdk:8.0)"
  docker run --rm -v "$(pwd):/app" -w /app mcr.microsoft.com/dotnet/sdk:8.0 \
    sh -c "cd Tests && dotnet test"
else
  echo "SKIP: neither dotnet nor docker found"
  exit 0
fi
