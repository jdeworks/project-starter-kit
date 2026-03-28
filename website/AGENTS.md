# AGENTS.md — website variant

Extends base AGENTS.md. Read that first, then this file.

## This variant covers

Static sites, server-rendered websites, blogs, portfolios, landing pages, and content-driven sites.
The rules and docs below are **framework-agnostic**. They apply whether you're using vanilla
HTML/CSS/JS, Astro, Next.js, Nuxt, SvelteKit, or anything else. The example commands use
Vite + vanilla JS as a concrete starting point — adapt them to your stack.

> **Using a different framework?** The patterns (test after changes, validate input, deploy
> with CI) carry over. See `docs/stack-choice.md` for mapping guidance.
> If your stack isn't covered, please open a PR — see CONTRIBUTING.md.

---

## Quick start

Pick a starter when composing your project — each gives you a working hello-world:

- `vanilla` — Plain HTML/CSS/TypeScript with Vite, no framework
- `astro` — Astro content-focused static site generator with island architecture
- `react` — React SPA with TypeScript and Vite bundler

Then: `npm install && npm run dev`

See `docs/stack-choice.md` for a full comparison.

---

## Variant-specific docs — read on demand

| Doc | Read when |
|-----|-----------|
| `docs/getting-started.md` | Starting a new website project — guided workflow from idea to setup |
| `docs/stack-choice.md` | Choosing between vanilla, React, Astro, Next.js, or other frameworks |
| `docs/project-structure.md` | Organizing files for static, SPA, or server-rendered sites |
| `docs/design-and-styling.md` | Styling approach, Tailwind CSS, responsive design, accessibility |
| `docs/security.md` | Security essentials — secrets, input validation, dependencies |
| `docs/hosting-static.md` | Deploying static sites (GitHub Pages, Vercel, Netlify, Cloudflare Pages) |
| `docs/hosting-server.md` | Deploying server-rendered sites (Railway, Fly.io, containers) |
| `docs/cicd.md` | CI/CD with GitHub Actions — lint, test, build, deploy |
| `docs/react-upgrade.md` | Upgrading a vanilla JS project to React |
| `docs/prerequisites.md` | Setup checklist — Node.js, editor, Git (for beginners) |

---

## Website-specific rules (extend base rules)

1. **Mobile-first.** Design for small screens first, enhance for larger ones. Test at 320px minimum.
2. **Semantic HTML.** Use proper heading hierarchy, landmarks, and elements. Accessibility is not optional.
3. **No inline secrets.** API keys, tokens, and credentials go in `.env`. See `docs/security.md`.
4. **Test after changes.** Run tests after every significant change. Don't ship broken code.
5. **Assets in `public/`.** Static assets (images, fonts, favicon) go in `public/`, not `src/`.

## LOC budget override

Websites tend to have smaller codebases. Keep files lean:
```
SOFT_FILE_LOC=200
HARD_FILE_LOC=300
LOC_BUDGET=10000
```

---

## Why Vite + vanilla JS as the example

We need a concrete example to show patterns. We chose Vite + vanilla JS because:
- Zero framework learning curve — just HTML, CSS, and JS
- Vite provides HMR, build optimization, and plugin ecosystem
- Easy upgrade paths to React, Vue, Svelte, or Astro when needed
- Works for beginners through advanced users

**This is a recommendation, not a requirement.** The kit works with any web framework.
See `docs/stack-choice.md` for when Astro, Next.js, or another framework is the better call.
