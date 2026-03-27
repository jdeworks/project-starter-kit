# AGENTS.md — monorepo variant

Extends base AGENTS.md. Read that first, then this file.

## This variant covers

Monorepo projects — multiple packages (frontend, backend, shared libraries, workers) in one
repository. The rules and docs below are **tool-agnostic**. They apply whether you're using
Turborepo, Nx, pnpm workspaces, Lerna, or Bazel. The example commands use Turborepo as a
concrete starting point — adapt them to your tooling.

> **Using a different monorepo tool?** The patterns (workspace isolation, shared packages,
> scoped commands) carry over. See `docs/stack-choice.md` for mapping guidance.
> If your tool isn't covered, please open a PR — see CONTRIBUTING.md.

---

## Quick start (example: Turborepo)

```bash
npx create-turbo@latest my-monorepo
cd my-monorepo
npm install
npm run dev
```

<details>
<summary>Other tools</summary>

**Nx:**
```bash
npx create-nx-workspace my-monorepo --preset=ts
cd my-monorepo && npx nx serve
```

**pnpm workspaces (no orchestrator):**
```bash
mkdir my-monorepo && cd my-monorepo
pnpm init && mkdir packages apps
# Add "packages": ["packages/*", "apps/*"] to package.json workspaces
```

See `docs/stack-choice.md` for a full comparison.
</details>

---

## Variant-specific docs — read on demand

| Doc | Read when |
|-----|-----------|
| `docs/workspace-structure.md` | Organizing packages, apps, and shared code |
| `docs/dependency-management.md` | Managing internal and external dependencies |
| `docs/ci-strategy.md` | CI/CD for monorepos — caching, affected detection, parallel builds |
| `docs/shared-packages.md` | Creating and consuming shared libraries within the repo |
| `docs/stack-choice.md` | Choosing between Turborepo, Nx, pnpm workspaces, Bazel |

---

## Monorepo-specific rules (extend base rules)

1. **Package boundaries are real.** Packages import each other through their public API (package.json exports), not via relative paths across package boundaries.
2. **Shared code lives in packages/.** If two apps need the same code, extract it to a shared package. Don't duplicate.
3. **Each package has its own tests.** Tests live next to the code they test. `make test` runs all packages.
4. **Root commands orchestrate, package commands execute.** `npm run build` at root builds everything; each package defines its own `build` script.
5. **CI uses affected detection.** Only build and test packages changed by a PR, not the entire repo.

## LOC budget override

Monorepos are larger by nature. Apply limits per-package, not globally:
```
SOFT_FILE_LOC=250
HARD_FILE_LOC=350
LOC_BUDGET=30000
```

---

## Why Turborepo as the example

We need a concrete example to show patterns. We chose Turborepo because:
- Zero-config for most setups — just add `turbo.json`
- Excellent build caching (local and remote)
- Works with npm, pnpm, and yarn
- Simple mental model compared to Nx

**This is a recommendation, not a requirement.** The kit works with any monorepo tool.
See `docs/stack-choice.md` for when Nx, Bazel, or plain workspaces is the better call.
