#!/usr/bin/env bash
# _helpers.sh — shared functions for CLI scripts
# Source this file: source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

# Detect project stack from files in a target directory
# Usage: detect_stack /path/to/project
# Sets: DETECTED_STACK (node|go|rust|python|dotnet|"")
detect_stack() {
  local target="$1"
  DETECTED_STACK=""

  if [ -f "$target/package.json" ]; then
    DETECTED_STACK="node"
  elif [ -f "$target/go.mod" ]; then
    DETECTED_STACK="go"
  elif [ -f "$target/Cargo.toml" ]; then
    DETECTED_STACK="rust"
  elif [ -f "$target/requirements.txt" ] || [ -f "$target/pyproject.toml" ] || [ -f "$target/setup.py" ]; then
    DETECTED_STACK="python"
  elif ls "$target"/*.csproj "$target"/*.sln >/dev/null 2>&1; then
    DETECTED_STACK="dotnet"
  fi
}

# Apply stack-specific files (Makefile.stack, .gitignore additions)
# Usage: apply_stack /path/to/project /path/to/kit-root
apply_stack() {
  local target="$1"
  local kit_root="$2"

  detect_stack "$target"

  if [ -n "$DETECTED_STACK" ]; then
    echo "    Detected: $DETECTED_STACK"
    if [ -f "$kit_root/base/stacks/$DETECTED_STACK/Makefile.stack" ]; then
      if [ ! -f "$target/Makefile.stack" ]; then
        cp "$kit_root/base/stacks/$DETECTED_STACK/Makefile.stack" "$target/Makefile.stack"
        echo "    Wrote Makefile.stack ($DETECTED_STACK)"
      fi
    fi
    if [ -f "$kit_root/base/stacks/$DETECTED_STACK/gitignore.append" ]; then
      if ! grep -qF "# $DETECTED_STACK (auto-detected)" "$target/.gitignore" 2>/dev/null; then
        echo "" >> "$target/.gitignore"
        cat "$kit_root/base/stacks/$DETECTED_STACK/gitignore.append" >> "$target/.gitignore"
        echo "    Appended $DETECTED_STACK entries to .gitignore"
      fi
    fi
  else
    echo "    No known stack detected — using default Node.js Makefile"
  fi
}

# Detect installed AI agents
# Usage: detect_agents
# Prints detected agents
detect_agents() {
  local agents_found=""

  command -v claude >/dev/null 2>&1 && agents_found="$agents_found Claude-Code"
  { [ -d "$HOME/.cursor" ] || command -v cursor >/dev/null 2>&1; } && agents_found="$agents_found Cursor"
  command -v windsurf >/dev/null 2>&1 && agents_found="$agents_found Windsurf"
  command -v opencode >/dev/null 2>&1 && agents_found="$agents_found OpenCode"
  command -v gh >/dev/null 2>&1 && agents_found="$agents_found Copilot"

  if [ -n "$agents_found" ]; then
    echo "    Detected:$agents_found"
  else
    echo "    No agents detected (all configs kept for portability)"
  fi
  echo "    All agent configs included — remove unused ones manually if desired"
}
