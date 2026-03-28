# SaaS starter

SaaS products with user authentication, subscription billing, and multi-tenancy.

**Example stack:** Next.js + Stripe (works with any full-stack framework — see [docs/stack-choice.md](docs/stack-choice.md))

## Get started

```bash
# Navigate to your project folder, then:
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) saas
```

The CLI will prompt you to pick a starter. To skip the prompt:

```bash
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) saas --starter nextjs
```

**Available starters:** `nextjs` (Next.js), `sveltekit` (SvelteKit)

<details>
<summary>Manual setup</summary>

```bash
git clone --filter=blob:none --no-checkout --depth=1 -b dev \
  https://github.com/jdeworks/project-starter-kit.git /tmp/_psk
cd /tmp/_psk && git sparse-checkout init --cone
git sparse-checkout set base saas/AGENTS.md saas/docs saas/starters/nextjs cli && git checkout dev
bash cli/compose.sh --variant saas --starter nextjs --target ~/my-saas --yes
rm -rf /tmp/_psk && cd ~/my-saas
```

</details>

## What you get

```
my-saas/
├── AGENTS.md
├── Makefile
├── package.json           # From starter — dependencies pre-configured
├── src/                   # From starter — app entry point and scaffolding
├── tests/                 # From starter — test setup
├── docs/
│   ├── auth-and-users.md    # Auth services, roles, session management
│   ├── billing.md           # Stripe webhooks, checkout, subscription lifecycle
│   ├── multi-tenancy.md     # Row-level isolation, tenant scoping
│   ├── onboarding.md        # Signup flows, trials, activation
│   ├── email.md             # Transactional email (welcome, invoice, reset)
│   └── stack-choice.md      # Next.js vs Rails vs Laravel vs Nuxt
├── scripts/
└── .claude/
```

## Next step

> Read AGENTS.md and tell me what mode we're in and what commands are available.
