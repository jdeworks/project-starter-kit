# Contributing to project-starter-kit

## What we need most

1. **Stack-specific examples and mappings** — each variant recommends a default stack but
   should work with anything. PRs that add alternative quick-start examples, Makefile target
   mappings, or stack-choice guidance for other frameworks are very welcome (e.g. FastAPI
   examples in `api-service/`, Flutter guidance in `mobile-app/`)
2. **Hook support for new agents** — Cursor, Windsurf, Copilot have no lifecycle hooks yet;
   if those agents add hook support, PRs are very welcome
3. **Engine contributions for game-dev** — current coverage is Phaser/PixiJS (browser-native);
   contributions for Godot, Unity, or other engines go here
4. **New variants** — if your project type isn't covered, propose a new variant

---

## Adding or improving a variant

1. Work inside the relevant variant folder (e.g. `saas/`)
2. The variant's `AGENTS.md` is the entry point — fill in the doc table and rules section
3. Rules should be **framework-agnostic** (validate input, test endpoints, etc.) — don't
   hardcode a specific library unless offering it as one example among alternatives
4. Add docs to `<variant>/.kit/` — one doc per topic, named clearly
5. Every variant should have a `.kit/stack-choice.md` explaining when to choose alternatives
6. If the variant has a starter template, put it in `<variant>/template/`
7. For online AI use, generate a bundle: `bash cli/bundle.sh --variant <name>`
8. Do not modify `base/` from a variant PR unless the change genuinely applies to all variants

## Adding hook support for a new agent

1. Check what lifecycle events the agent supports
2. Create `base/.agentname/hooks/` mirroring the structure of `base/.claude/hooks/`
3. The shell scripts in `base/.claude/hooks/` are agent-agnostic — reuse them where possible
4. Add the agent's config/wiring file (e.g. `.agentname/config.json`)
5. Add the agent to the tables in `base/HOOKS.md` and the root `README.md`
6. Test that session-start and session-end behaviors work correctly

## Adding a game engine to game-dev

1. Add docs to `game-dev/.kit/<engine-name>/`
2. Update `game-dev/AGENTS.md` to reference the new docs
3. Add a note in the doc table: "Read when using <engine>"
4. If the engine has significantly different testing patterns, document them explicitly
5. Do not break the Phaser/PixiJS primary path

## Code standards for this repo

The starter kit should eat its own cooking. The `base/` layer applies to this repo itself:

- `base/` files should stay lean — AGENTS.md ≤150 lines, individual docs ≤350 lines
- Shell scripts: `set -euo pipefail`, handle missing files gracefully, exit codes matter
- No hardcoded paths — use env vars with sensible defaults (`SRC_DIR=${SRC_DIR:-src}`)
- All hooks must be non-blocking unless there's a strong reason to block

## PR checklist

- [ ] Variant AGENTS.md updated with any new docs in the table
- [ ] New docs are referenced from AGENTS.md (not orphaned)
- [ ] Shell scripts are executable (`chmod +x`)
- [ ] HOOKS.md updated if agent support changed
- [ ] README.md variant table updated if a new variant was added
