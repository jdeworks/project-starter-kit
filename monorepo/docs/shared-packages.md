# Shared packages

Creating and consuming shared libraries within the monorepo.

## Creating a shared package

```
packages/ui/
  src/
    Button.tsx
    Card.tsx
    index.ts        # Public API — re-exports all components
  package.json
  tsconfig.json
```

### package.json

```json
{
  "name": "@myapp/ui",
  "version": "0.0.0",
  "private": true,
  "exports": {
    ".": "./src/index.ts"
  },
  "scripts": {
    "build": "tsc",
    "test": "vitest run"
  }
}
```

### Public API (index.ts)

```typescript
// Only export what consumers need
export { Button } from './Button'
export { Card } from './Card'
export type { ButtonProps, CardProps } from './types'
```

## Consuming a shared package

```typescript
// In apps/web/src/pages/Home.tsx
import { Button, Card } from '@myapp/ui'
```

## Internal-only vs published packages

| Aspect | Internal only | Published to npm |
|--------|--------------|-----------------|
| `private` | `true` | `false` |
| `version` | `0.0.0` (doesn't matter) | Managed by Changesets |
| `exports` | Point to source (`./src/index.ts`) | Point to built output (`./dist/index.js`) |
| Build step | Optional (bundler resolves source) | Required (consumers need built files) |

## Common shared packages

| Package | Contains |
|---------|----------|
| `@myapp/ui` | Shared UI components |
| `@myapp/db` | Database schema, client, migrations |
| `@myapp/utils` | Shared utility functions |
| `@myapp/config` | Shared ESLint, TypeScript, Tailwind configs |
| `@myapp/types` | Shared TypeScript types/interfaces |
| `@myapp/auth` | Auth helpers used by multiple apps |
