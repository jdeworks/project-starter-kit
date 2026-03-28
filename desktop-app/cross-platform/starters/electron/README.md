# My App — Electron

A cross-platform desktop app built with Electron, Vite, and TypeScript.

## Prerequisites

- Node.js 18+

## Getting started

```bash
npm install
npm run dev
```

## Scripts

| Command              | Description                        |
| -------------------- | ---------------------------------- |
| `npm run dev`        | Build and launch the app           |
| `npm run build`      | Package with electron-builder      |
| `npm test`           | Run tests with Vitest              |
| `npm run format`     | Format code with Prettier          |
| `npm run lint`       | Lint with ESLint                   |
| `npm run typecheck`  | Type-check with TypeScript         |

## Project structure

```
src/
  main/index.ts        — Electron main process
  renderer/index.html  — Renderer page
  renderer/main.ts     — Renderer JS, sends IPC
  shared/greet.ts      — Pure greeting logic (shared)
tests/
  greet.test.ts        — Tests for shared logic
```
