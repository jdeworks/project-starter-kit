# my-cli

A CLI tool built with [Click](https://click.palletsprojects.com/).

## Setup

```bash
pip install -e ".[dev]"
```

## Usage

```bash
my-cli greet Alice
my-cli count 5
```

## Development

```bash
# Run directly without installing
python -m src.cli greet Alice
python -m src.cli count 5
```

## Test

```bash
pytest
```

## Commands

- `my-cli greet <name>` — prints "Hello, {name}!"
- `my-cli count <n>` — counts from 1 to n
