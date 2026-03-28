# My App — Tauri 2

A desktop app with a web frontend and Rust backend, built with Tauri 2.

## Prerequisites

- Node.js 18+
- Rust toolchain (install via [rustup](https://rustup.rs/))
- System dependencies for Tauri — see [prerequisites](https://v2.tauri.app/start/prerequisites/)

## Getting started

```bash
npm install
npm run dev
```

## Scripts

| Command              | Description                        |
| -------------------- | ---------------------------------- |
| `npm run dev`        | Start Tauri dev mode (hot-reload)  |
| `npm run build`      | Build frontend (vite)              |
| `npm run build:app`  | Build full Tauri app (needs Rust)  |
| `npm test`           | Run frontend tests with Vitest     |
| `npm run format`     | Format code with Prettier          |
| `npm run lint`       | Lint with ESLint                   |
| `npm run typecheck`  | Type-check with TypeScript         |

## Project structure

```
src/
  main.ts          — Frontend JS, calls Tauri IPC
  greet.ts         — Pure greeting logic (no Tauri deps)
src-tauri/
  src/main.rs      — Tauri app entry point
  src/lib.rs       — Rust command handlers
  Cargo.toml       — Rust dependencies
  tauri.conf.json  — Tauri configuration
tests/
  greet.test.ts    — Tests for pure JS greeting logic
```
