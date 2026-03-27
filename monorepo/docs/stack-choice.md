# Stack choice — monorepo tools

This variant uses Turborepo as its primary example. This doc explains when to choose
a different tool.

## Choose Turborepo when

- You want simple, fast build orchestration with minimal config
- Remote caching (Vercel) is appealing for CI speedups
- Your monorepo is primarily JavaScript/TypeScript
- You prefer convention over configuration

## Choose Nx when

- You need granular task graph and dependency analysis
- You want generators and schematics for scaffolding
- Your monorepo includes non-JS languages (Go, Rust, Python)
- You need fine-grained affected detection and distributed task execution

## Choose pnpm workspaces (no orchestrator) when

- Your monorepo is small (2–5 packages)
- You don't need build caching or affected detection
- You want minimal tooling overhead
- pnpm's strict dependency isolation is important to you

## Choose Bazel when

- Your monorepo is very large (100+ packages) or multi-language
- Hermetic builds are a requirement
- You have the engineering capacity to maintain Bazel configs
- Build correctness matters more than setup simplicity

## Choose Lerna when

- You're managing a collection of published npm packages
- Versioning and publishing are the primary concern (use Lerna + Changesets)
- Note: Lerna is now maintained by Nx, so consider Nx directly

## Mapping kit patterns to your tool

| Kit concept | Turborepo | Nx | pnpm workspaces |
|-------------|-----------|-----|-----------------|
| Build all | `turbo build` | `nx run-many -t build` | `pnpm -r build` |
| Test all | `turbo test` | `nx run-many -t test` | `pnpm -r test` |
| Affected only | `turbo build --filter=...[HEAD^]` | `nx affected -t build` | Manual |
| Dependency graph | `turbo run build --graph` | `nx graph` | N/A |
| Remote cache | Vercel Remote Cache | Nx Cloud | N/A |
