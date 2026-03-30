# ROADMAP

Tracks what's done, what's next, and what's planned for project-starter-kit.

---

## Completed

- [x] **Base layer** — AGENTS.md, hooks, scripts, docs, Makefile, CHANGES.md, SESSION_SUMMARY.md
- [x] **Claude Code integration** — full hook support (4 lifecycle events, 5 scripts)
- [x] **OpenCode integration** — session start/end hooks, health-check command
- [x] **Cursor / Windsurf configs** — minimal redirects to AGENTS.md
- [x] **CLI: init.sh** — create new project with git init + compose
- [x] **CLI: compose.sh** — copy base + variant, set mode, make scripts executable
- [x] **CLI: migrate.sh** — analyze existing repo, generate MIGRATION.md
- [x] **CLI: upgrade.sh** — lean-to-full upgrade with arch test scaffolding
- [x] **Variant: mobile-app** — full AGENTS.md + stack-choice doc
- [x] **Variant: api-service** — AGENTS.md + 6 docs (api-design, database, auth, error-handling, deployment, stack-choice)
- [x] **Variant: website** — AGENTS.md + 10 docs (getting-started, stack-choice, project-structure, design, security, hosting-static, hosting-server, cicd, react-upgrade, prerequisites). Preserves all make-a-website content.
- [x] **Variant: saas** — AGENTS.md + 6 docs (auth-and-users, billing, multi-tenancy, onboarding, email, stack-choice)
- [x] **Variant: monorepo** — AGENTS.md + 5 docs (workspace-structure, dependency-management, ci-strategy, shared-packages, stack-choice)
- [x] **Variant: cli-tool** — AGENTS.md + 5 docs (cli-design, output-and-ux, testing-clis, distribution, stack-choice)
- [x] **Variant: mcp-server** — AGENTS.md + 5 docs (mcp-concepts, tool-design, testing-mcp, deployment, stack-choice)
- [x] **Variant: game-dev** — AGENTS.md + 5 docs (game-architecture, asset-management, game-loop, testing-games, stack-choice)
- [x] **Variant: desktop-app/cross-platform** — AGENTS.md + 5 docs (ipc-and-commands, native-apis, packaging, auto-update, stack-choice)
- [x] **Variant: desktop-app/native** — AGENTS.md + 4 docs (mvvm-pattern, platform-apis, packaging-native, stack-choice)
- [x] **Self-hosting** — repo dogfoods its own base layer via root symlinks
- [x] **Framework-agnostic philosophy** — variants recommend but don't require specific stacks

---

## Planned

### CLI improvements

- [x] **`cli/help.sh`** — unified help command listing all scripts, variants, and examples
- [x] **`--help` flag** — added to all CLI scripts (init, compose, migrate, upgrade)
- [x] **`--dry-run` flag** — compose.sh and migrate.sh show what would happen without doing it
- [x] **`cli/status.sh`** — show variant details, doc counts, and self-hosting health
- [x] **`cli/validate.sh`** — verify doc references and run hook smoke tests
- [x] **Interactive mode** — init.sh and compose.sh walk through selection when no flags passed

### Framework extensibility

- [x] **Stack-specific health-check overrides** — health-check.sh reads `SRC_EXTENSIONS` from env for .py, .go, .cs, .rs, etc.
- [x] **"Bring your own stack" guide** — `.kit/bring-your-own-stack.md` with Makefile mapping examples

### Agent support

- [x] **`.github/copilot-instructions.md`** — created in base/
- [x] **`repomix.config.json`** — created in base/ for bundle.xml generation

### Testing the kit itself

- [x] **Variant validation** — `cli/validate.sh` checks all AGENTS.md doc references + orphaned docs
- [x] **Hook smoke tests** — `cli/validate.sh --hooks` runs all hooks in temp directory

### Documentation

- [x] **Architecture doc** — `.kit/architecture.md` explains layering for contributors
- [x] **"Bring your own stack" guide** — `.kit/bring-your-own-stack.md` with step-by-step

---

### Stack and runtime support

- [x] **Stack detection** — compose.sh detects stack from project files (package.json, go.mod, Cargo.toml, etc.) and auto-configures Makefile.stack + .gitignore
- [x] **Stack mappings** — `base/stacks/` has Makefile.stack + gitignore.append for Node, Go, Python, Rust, .NET
- [x] **Makefile adapter pattern** — base Makefile `-include Makefile.stack` for pluggable stack-specific commands
- [x] **Agent detection** — compose.sh detects installed agents (Claude Code, Cursor, Windsurf, OpenCode, Copilot)
- [x] **bundle.xml generation** — `cli/bundle.sh` generates repomix bundles per variant
- [x] **CLI integration tests** — `cli/test.sh` runs 20 tests covering compose, migrate, upgrade, health-check, validate
- [x] **Git and GitHub doc** — `.kit/git-and-github.md` covers commit hygiene, pre-commit hooks, fast test subsets, PR best practices, branch protection

---

## Future / community contributions

- [ ] **More stack mappings** — Ruby, Java, PHP stack files in `base/stacks/`
- [ ] **Template files per variant** — starter project templates (like make-a-website's `template/`) for each variant
- [ ] **CI workflow templates** — `.github/workflows/ci.yml` per variant, auto-selected by compose.sh

---

## Contributing

Pick any unchecked item above. See [CONTRIBUTING.md](CONTRIBUTING.md) for standards and PR checklist.
If your stack or framework isn't represented, a PR adding stack-choice guidance or quick-start
examples is the single most valuable contribution you can make.
