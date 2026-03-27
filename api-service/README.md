# API service starter

Backend API development — REST or GraphQL — without a frontend.

**Example stack:** Node.js + Hono (works with any backend framework — see [docs/stack-choice.md](docs/stack-choice.md))

## Get started

```bash
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) api-service my-api
```

<details>
<summary>Manual setup</summary>

```bash
git clone --filter=blob:none --no-checkout --depth=1 -b dev \
  https://github.com/jdeworks/project-starter-kit.git /tmp/_psk
cd /tmp/_psk && git sparse-checkout init --cone
git sparse-checkout set base api-service cli && git checkout dev
bash cli/compose.sh --variant api-service --mode full --target ~/my-api --yes
rm -rf /tmp/_psk && cd ~/my-api
```

</details>

## What you get

```
my-api/
├── AGENTS.md            # Tell your AI agent to read this first
├── Makefile             # make dev, make check, make test, make health
├── docs/
│   ├── api-design.md       # REST conventions, status codes, response shapes
│   ├── database.md         # ORM, migrations, schema conventions
│   ├── auth.md             # JWT, sessions, API keys, OAuth
│   ├── error-handling.md   # Consistent error responses, validation
│   ├── deployment.md       # Docker, serverless, PaaS, health checks
│   └── stack-choice.md     # Hono vs Express vs Fastify vs non-JS
├── scripts/             # Health check, dead code analysis
└── .claude/             # Claude Code hooks
```

## Next step

> Read AGENTS.md and tell me what mode we're in and what commands are available.
