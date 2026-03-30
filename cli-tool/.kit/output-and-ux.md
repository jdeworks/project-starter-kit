# Output and UX

Formatting CLI output for humans and machines.

## The two-stream rule

- **stdout:** Machine-readable output (data, results, piped content)
- **stderr:** Human-readable messages (errors, warnings, progress, status)

This lets users pipe your output: `my-cli list | grep active` works because progress
spinners go to stderr, not stdout.

## Colors

- Use colors for emphasis, not decoration
- Respect the `NO_COLOR` environment variable (https://no-color.org)
- Detect `--no-color` flag and non-TTY environments
- Common conventions: red = error, yellow = warning, green = success, cyan = info

## Progress indicators

- **Spinner** — for indeterminate operations (network requests, processing)
- **Progress bar** — for operations with known total (file processing, downloads)
- Only show progress on interactive terminals (TTY) — skip in CI/pipes

## Tables

For structured output, align columns:
```
NAME        STATUS    CREATED
my-project  active    2026-01-15
test-site   stopped   2026-01-10
```

Consider `--json` flag for machine-readable output:
```json
[{"name": "my-project", "status": "active", "created": "2026-01-15"}]
```

## Interactive prompts

Use sparingly. When you do:
- Show a default value in brackets: `Project name [my-project]:`
- Support `--yes` / `-y` flag to accept all defaults (non-interactive mode)
- Never prompt in non-TTY environments — fail with a clear message instead

## Verbosity levels

```
default    Essential output only
--verbose  Include detailed progress and debug info
--quiet    Suppress all output except errors
--debug    Include internal diagnostic information (for bug reports)
```
