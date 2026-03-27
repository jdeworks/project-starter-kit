# Dependency management

Managing internal and external dependencies in a monorepo.

## Internal dependencies

Packages reference each other via `package.json`:

```json
{
  "name": "@myapp/web",
  "dependencies": {
    "@myapp/ui": "workspace:*",
    "@myapp/utils": "workspace:*"
  }
}
```

The `workspace:*` protocol tells the package manager to resolve from the local workspace,
not from npm.

## External dependencies

### Shared dependencies

Dependencies used across multiple packages should have the **same version** to avoid
bundle duplication and compatibility issues:

- Pin shared dependencies in the root `package.json` or use a tool like `syncpack`
- Example: React, TypeScript, and ESLint should be the same version everywhere

### Package-specific dependencies

Dependencies used by only one package belong in that package's `package.json`, not the root.

## Hoisting

- **pnpm:** Strict by default (no phantom dependencies). Recommended.
- **npm workspaces:** Hoists to root. Can cause phantom dependency issues.
- **yarn:** Configurable hoisting.

## Version management

For internal packages that are NOT published to npm:
- Use `"version": "0.0.0"` — the version doesn't matter for workspace-only packages

For published packages:
- Use Changesets (`@changesets/cli`) for version management and changelogs
- Each PR that changes a published package should include a changeset
