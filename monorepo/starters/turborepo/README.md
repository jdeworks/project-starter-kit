# Turborepo Starter

A monorepo powered by [Turborepo](https://turbo.build/) with three packages:

| Package | Description |
|---------|-------------|
| `apps/web` | Vite web app (port 3000) |
| `apps/api` | Node HTTP API (port 4000) |
| `packages/shared` | Shared utilities (`greet`, `formatDate`) |

## Prerequisites

- Node.js 18+
- npm 10+

## Getting started

```bash
npm install
npm run build   # build all packages
npm run dev     # start all dev servers in parallel
```

## Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start all apps in dev mode |
| `npm run build` | Build all packages |
| `npm run test` | Run tests across all packages |
| `npm run format` | Format code with Prettier |
| `npm run lint` | Lint with ESLint |
| `npm run typecheck` | Type-check all packages |

## Running tests

```bash
npm run test
```

Tests live in `packages/shared/tests/` and use [Vitest](https://vitest.dev/).

## Project structure

```
.
├── apps/
│   ├── api/          # Node HTTP server
│   └── web/          # Vite web app
├── packages/
│   └── shared/       # Shared library
├── turbo.json        # Turborepo pipeline config
├── tsconfig.base.json
└── package.json      # Workspace root
```
