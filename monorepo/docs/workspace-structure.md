# Workspace structure

How to organize a monorepo.

## Standard layout

```
my-monorepo/
  apps/               # Deployable applications
    web/              # Frontend app
    api/              # Backend API
    worker/           # Background job processor
  packages/           # Shared libraries
    ui/               # Shared UI components
    db/               # Database schema and client
    config/           # Shared configs (ESLint, TS, Tailwind)
    utils/            # Shared utility functions
  turbo.json          # Build orchestration config
  package.json        # Root package.json (workspaces)
```

## Naming conventions

- Use `@scope/package-name` for internal packages: `@myapp/ui`, `@myapp/db`
- Apps are named by their function: `web`, `api`, `admin`, `worker`
- Config packages: `@myapp/eslint-config`, `@myapp/tsconfig`

## Package anatomy

Every package should have:
```
packages/ui/
  src/              # Source code
  package.json      # Name, exports, dependencies
  tsconfig.json     # Extends root tsconfig
  README.md         # What this package does and how to use it
```

## When to create a new package

- Code is used by 2+ apps → extract to `packages/`
- Code has a distinct responsibility (auth, email, analytics)
- Code could be tested independently

## When NOT to split

- Code is only used in one app → keep it in that app
- The "shared" code is just a few utility functions → use a single `packages/utils/`
- Splitting would create circular dependencies
