# Browser testing — monorepo variant

In a monorepo, browser tests serve double duty: they verify individual apps AND catch
breakage caused by shared package changes. This is critical — a passing unit test in
`packages/shared` does not mean the consuming app still works.

---

## Setup per app

Each app with a UI gets its own Playwright config:

```
apps/
  web/
    playwright.config.ts    ← each UI app has its own
    e2e/
      smoke.spec.ts
      core-flows.spec.ts
  admin/
    playwright.config.ts
    e2e/
      smoke.spec.ts
```

Shared test utilities go in a package:

```
packages/
  test-utils/
    src/
      browser-helpers.ts    ← shared Playwright helpers
```

---

## Cross-app verification rule

**After changing a shared package, run e2e tests for ALL consuming apps.**

Not just the app you're currently working on. A change to `packages/shared` might break
`apps/web`, `apps/admin`, and `apps/mobile-web` simultaneously.

```bash
# Run all e2e tests across the monorepo
make e2e

# Or target specific apps
npx playwright test --config apps/web/playwright.config.ts
npx playwright test --config apps/admin/playwright.config.ts
```

The Makefile `e2e` target auto-discovers all `playwright.config.*` files in `apps/`.

---

## Required: console error gate per app

Every app with a UI must have this test at minimum:

```ts
import { test, expect } from '@playwright/test'

test('no console errors on page load', async ({ page }) => {
  const errors: string[] = []
  page.on('pageerror', err => errors.push(err.message))
  await page.goto('/')
  await page.waitForTimeout(2000)
  expect(errors, `Console errors:\n${errors.join('\n')}`).toHaveLength(0)
})
```

---

## Shared package change checklist

When you modify a file in `packages/`:

1. Run the package's own tests: `npm test --workspace=packages/<name>`
2. Run type checking: `make types` (catches broken imports)
3. Run e2e for ALL consuming apps: `make e2e`
4. Check for console errors in each app

A shared package change that passes unit tests but breaks an app's UI is the most common
monorepo failure mode. The `make verify` target catches this by running check + e2e together.

---

## Core flow tests

Same patterns as website variant (see `website/.kit/testing-browser.md`), but organized per app:

```ts
// apps/web/e2e/core-flows.spec.ts
test.describe('Web app core flows', () => {
  test('user can complete signup', async ({ page }) => { /* ... */ })
  test('user can navigate dashboard', async ({ page }) => { /* ... */ })
})

// apps/admin/e2e/core-flows.spec.ts
test.describe('Admin core flows', () => {
  test('admin can view user list', async ({ page }) => { /* ... */ })
  test('admin can edit settings', async ({ page }) => { /* ... */ })
})
```

---

## Running

```bash
make e2e            # all apps' Playwright tests
make verify         # full pipeline: check + e2e
npx playwright test --config apps/web/playwright.config.ts  # single app
```
