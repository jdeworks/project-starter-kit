# Website starter

Static sites, server-rendered websites, blogs, portfolios, and landing pages.

**Example stack:** Vite + vanilla JS (works with any framework — see [docs/stack-choice.md](docs/stack-choice.md))

## Get started

```bash
# One command — copies only the files you need, no git history
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) website my-site
```

Or manually:
```bash
git clone --filter=blob:none --no-checkout --depth=1 -b dev \
  https://github.com/jdeworks/project-starter-kit.git /tmp/_psk
cd /tmp/_psk && git sparse-checkout init --cone
git sparse-checkout set base website cli && git checkout dev
bash cli/compose.sh --variant website --mode full --target ~/my-site --yes
rm -rf /tmp/_psk
cd ~/my-site
```

## What you get

```
my-site/
├── AGENTS.md            # Tell your AI agent to read this first
├── Makefile             # make dev, make check, make test, make health
├── docs/
│   ├── getting-started.md
│   ├── stack-choice.md
│   ├── project-structure.md
│   ├── design-and-styling.md
│   ├── security.md
│   ├── hosting-static.md
│   ├── hosting-server.md
│   ├── cicd.md
│   ├── react-upgrade.md
│   └── prerequisites.md
├── scripts/             # Health check, dead code analysis
├── .claude/             # Claude Code hooks (auto-runs on edit, compact, stop)
├── .opencode/           # OpenCode hooks
└── ...                  # Cursor, Windsurf, Copilot configs
```

## Next step

Open your AI agent and say:

> Read AGENTS.md and tell me what mode we're in and what commands are available.

## Docs in this variant

| Doc | Read when |
|-----|-----------|
| [getting-started.md](docs/getting-started.md) | Starting a new website — guided workflow from idea to setup |
| [stack-choice.md](docs/stack-choice.md) | Choosing between vanilla, React, Astro, Next.js, etc. |
| [project-structure.md](docs/project-structure.md) | Organizing files for static, SPA, or server-rendered sites |
| [design-and-styling.md](docs/design-and-styling.md) | Styling, Tailwind CSS, responsive design, accessibility |
| [security.md](docs/security.md) | Secrets, input validation, dependencies |
| [hosting-static.md](docs/hosting-static.md) | GitHub Pages, Vercel, Netlify, Cloudflare Pages |
| [hosting-server.md](docs/hosting-server.md) | Railway, Fly.io, Docker |
| [cicd.md](docs/cicd.md) | GitHub Actions CI/CD |
| [react-upgrade.md](docs/react-upgrade.md) | Upgrading vanilla JS to React |
| [prerequisites.md](docs/prerequisites.md) | Node.js, editor, Git setup (for beginners) |
