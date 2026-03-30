# CLI design

Designing commands, subcommands, flags, and arguments.

## Command structure

```
my-cli <command> [subcommand] [flags] [arguments]

my-cli init --name my-project
my-cli deploy --env production ./dist
my-cli config set key value
```

## Naming conventions

- Commands and subcommands: lowercase, hyphenated — `my-cli create-user`
- Flags: `--long-name` with optional `-s` short form — `--output`, `-o`
- Boolean flags: `--verbose`, `--no-color` (no value needed)
- Value flags: `--name <value>`, `--count <number>`

## Required vs optional

- **Arguments** are typically required (positional): `my-cli deploy <directory>`
- **Flags** are typically optional: `my-cli deploy --env staging`
- If a required value is missing, show a clear error and the relevant `--help`

## Global flags

Every CLI should support:
- `--help`, `-h` — show help (built into most frameworks)
- `--version`, `-V` — show version
- `--verbose`, `-v` — increase output detail
- `--quiet`, `-q` — suppress non-essential output
- `--no-color` — disable colored output (respect `NO_COLOR` env var too)

## Subcommand pattern

For CLIs with multiple features, use subcommands:

```
my-cli init          # create a new project
my-cli build         # build the project
my-cli deploy        # deploy to production
my-cli config get    # get a config value
my-cli config set    # set a config value
```

Group related subcommands (like `config get`/`config set`) under a parent command.

## Default command

If your CLI has an obvious primary action, make it the default:
```bash
my-cli              # runs the default command (e.g., start, run)
my-cli --help       # shows all commands
```

## Error messages

```
Error: missing required flag --name

Usage: my-cli init --name <project-name> [--template <template>]

Run 'my-cli init --help' for more information.
```

Always show: what went wrong, what the correct usage looks like, how to get more help.
