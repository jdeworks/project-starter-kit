# Monorepo starter

Multiple packages — frontend, backend, shared libraries, workers — in one repository.

**Example stack:** Turborepo (works with Nx, pnpm workspaces, Bazel — see [docs/stack-choice.md](docs/stack-choice.md))

## Get started

```bash
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) monorepo my-monorepo
```

<details>
<summary>Manual setup</summary>

```bash
git clone --filter=blob:none --no-checkout --depth=1 -b dev \
  https://github.com/jdeworks/project-starter-kit.git /tmp/_psk
cd /tmp/_psk && git sparse-checkout init --cone
git sparse-checkout set base monorepo cli && git checkout dev
bash cli/compose.sh --variant monorepo --mode full --target ~/my-monorepo --yes
rm -rf /tmp/_psk && cd ~/my-monorepo
```

</details>

## What you get

```
my-monorepo/
├── AGENTS.md
├── Makefile
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
