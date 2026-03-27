# AGENTS.md — cli-tool variant

Extends base AGENTS.md. Read that first, then this file.

## This variant covers

Command-line tools and utilities — argument parsing, interactive prompts, output formatting,
and distribution. The rules and docs below are **language-agnostic**. They apply whether you're
building with Node.js, Go, Rust, Python, or anything else. The example commands use Node.js +
Commander as a concrete starting point — adapt them to your stack.

> **Using a different language?** The patterns (subcommands, help text, exit codes, testing CLIs)
> carry over. See `docs/stack-choice.md` for mapping guidance.
> If your stack isn't covered, please open a PR — see CONTRIBUTING.md.

---

## Quick start (example: Node.js + Commander)

```bash
mkdir my-cli && cd my-cli
npm init -y
npm install commander chalk
```

<details>
<summary>Other stacks</summary>

**Go + Cobra:**
```bash
mkdir my-cli && cd my-cli
go mod init my-cli
go get github.com/spf13/cobra/cobra@latest
```

**Rust + clap:**
```bash
cargo new my-cli
cd my-cli
cargo add clap --features derive
```

**Python + Click:**
```bash
mkdir my-cli && cd my-cli
pip install click
```

See `docs/stack-choice.md` for a full comparison.
</details>

---

## Variant-specific docs — read on demand

| Doc | Read when |
|-----|-----------|
| `docs/cli-design.md` | Designing commands, subcommands, flags, and arguments |
| `docs/output-and-ux.md` | Formatting output, colors, progress indicators, interactive prompts |
| `docs/testing-clis.md` | Testing CLI tools — unit, integration, snapshot testing |
| `docs/distribution.md` | Packaging and distributing your CLI (npm, homebrew, binaries) |
| `docs/stack-choice.md` | Choosing between Node.js, Go, Rust, Python for CLI tools |

---

## CLI-specific rules (extend base rules)

1. **Every command has `--help`.** Users should never have to guess. Use your framework's built-in help generation.
2. **Exit codes are meaningful.** `0` = success, `1` = general error, `2` = usage error. Never exit `0` on failure.
3. **Stderr for errors, stdout for output.** Errors, warnings, and progress go to stderr. Machine-parseable output goes to stdout. This allows piping.
4. **No interactive prompts in CI.** Detect non-interactive environments (`!process.stdin.isTTY` or equivalent) and fail with a clear message instead of hanging.
5. **Config files are optional.** CLI works with just flags. Config files (`.myrc`, `myconfig.json`) are a convenience, not a requirement.

## LOC budget override

CLIs are typically compact:
```
SOFT_FILE_LOC=200
HARD_FILE_LOC=300
LOC_BUDGET=8000
```

---

## Why Node.js + Commander as the example

We need a concrete example to show patterns. We chose Node.js + Commander because:
- Largest ecosystem for CLI utilities (chalk, ora, inquirer, etc.)
- Commander is the most widely used CLI framework for Node.js
- Easy distribution via npm (`npx my-cli`)
- Same language as much of the starter kit

**This is a recommendation, not a requirement.** Go and Rust produce single binaries
(no runtime needed), which is often better for distribution. Python has excellent CLI
libraries (Click, Typer). See `docs/stack-choice.md` for guidance.
