# CI strategy for monorepos

Building and testing monorepos efficiently in CI.

## Core principle: only build what changed

Full rebuilds on every PR don't scale. Use affected detection:

```yaml
# Turborepo example
- run: npx turbo build test --filter=...[origin/main]

# Nx example
- run: npx nx affected -t build test --base=origin/main
```

## Caching

### Local cache

Turborepo and Nx cache task outputs locally. In CI, this means:
- Cache `node_modules/.cache/turbo` (Turborepo) or `.nx/cache` (Nx) between runs
- Use GitHub Actions cache or your CI's built-in caching

### Remote cache

For team-wide cache sharing:
- **Turborepo:** Vercel Remote Cache (free for Vercel users)
- **Nx:** Nx Cloud (free tier available)

## Example CI workflow

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # needed for affected detection
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
      - run: npm ci
      - run: npx turbo build test lint --filter=...[origin/main]
```

## Tips

- `fetch-depth: 0` is required for affected detection (needs git history)
- Keep CI under 5 minutes for PRs — use caching and affected detection
- Run full builds on main branch pushes (not just affected) to catch integration issues
- Parallelize independent package builds (Turborepo and Nx do this automatically)
