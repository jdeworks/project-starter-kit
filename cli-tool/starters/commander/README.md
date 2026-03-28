# my-cli

A CLI tool built with [Commander](https://github.com/tj/commander.js).

## Setup

```bash
npm install
```

## Development

```bash
npm run dev -- greet Alice
npm run dev -- count 5
```

## Build

```bash
npm run build
```

## Test

```bash
npm test
```

## Other scripts

| Script | Description |
|---|---|
| `npm run format` | Format code with Prettier |
| `npm run lint` | Lint with ESLint |
| `npm run typecheck` | Type-check without emitting |

## Commands

- `my-cli greet <name>` — prints "Hello, {name}!"
- `my-cli count <n>` — counts from 1 to n
