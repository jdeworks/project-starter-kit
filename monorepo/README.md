# Monorepo starter

Multiple packages — frontend, backend, shared libraries, workers — in one repository.

**Example stack:** Turborepo (works with Nx, pnpm workspaces, Bazel — see [docs/stack-choice.md](docs/stack-choice.md))

## Get started

```bash
# Navigate to your project folder, then:
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) monorepo
```

The CLI will prompt you to pick a starter. To skip the prompt:

```bash
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) monorepo --starter turborepo
```

**Available starters:** `turborepo` (Turborepo)

<details>
<summary>Manual setup</summary>

```bash
git clone --filter=blob:none --no-checkout --depth=1 -b dev \
  https://github.com/jdeworks/project-starter-kit.git /tmp/_psk
cd /tmp/_psk && git sparse-checkout init --cone
git sparse-checkout set base monorepo/AGENTS.md monorepo/docs monorepo/starters/turborepo cli && git checkout dev
bash cli/compose.sh --variant monorepo --starter turborepo --target ~/my-monorepo --yes
rm -rf /tmp/_psk && cd ~/my-monorepo
```

</details>

## What you get

```
my-monorepo/
├── AGENTS.md
├── Makefile
├── package.json                   # From starter — workspace root config
├── apps/                          # From starter — application packages
├── packages/                      # From starter — shared libraries
├── docs/
│   ├── workspace-structure.md     # apps/, packages/, naming conventions
│   ├── dependency-management.md   # Internal deps, hoisting, versioning
│   ├── ci-strategy.md             # Affected detection, caching, parallel builds
│   ├── shared-packages.md         # Creating and consuming shared libraries
│   └── stack-choice.md            # Turborepo vs Nx vs pnpm workspaces vs Bazel
├── scripts/
└── .claude/
```

## Next step

> Read AGENTS.md and tell me what mode we're in and what commands are available.
