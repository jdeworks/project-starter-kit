# Stack choice — API frameworks

This project uses Node.js + Hono as its primary example. This doc explains when
to choose a different framework instead.

## Choose Hono when

- You want to deploy to edge runtimes (Cloudflare Workers, Vercel Edge, Deno Deploy)
- TypeScript-first matters — Hono's type inference covers routes, params, and middleware
- You need a single codebase that runs on Node.js, Bun, Deno, or serverless without changes
- Performance matters and you want minimal overhead
- Your team is comfortable with a newer framework (stable since 2023, v4+ in 2025)

## Choose Express when

- Your team already knows Express and migration cost isn't justified
- You depend on Express-specific middleware that hasn't been ported (rare but possible)
- Your project is a quick internal tool where ecosystem maturity outweighs performance
- Note: Express 5 (2025) added async error handling, but the core is still callback-era design

## Choose Fastify when

- You need a plugin-based architecture with strong encapsulation
- JSON Schema-based validation and serialization is a priority (built-in, zero config)
- You want Express-level maturity with better performance
- Your API is exclusively Node.js (Fastify doesn't target edge runtimes)

## Choose a non-JS stack when

- **Go** — high-throughput services, small binaries, team knows Go. Use `net/http` or Chi.
- **Rust (Axum/Actix)** — extreme performance requirements, memory-critical services.
- **Python (FastAPI)** — ML/data-heavy APIs, team is Python-first. FastAPI's Pydantic validation is excellent.
- **C# (.NET Minimal APIs)** — enterprise environment, Azure-first, team knows .NET.

---

## Migrating this starter kit to a different framework

If you chose a different stack, the base layer still applies fully:
- AGENTS.md, CHANGES.md, SESSION_SUMMARY.md, hooks — all carry over
- Replace the test tier with your framework's test runner (`go test`, `pytest`, `dotnet test`)
- Replace knip with your language's dead code tool (`deadcode` for Go, `vulture` for Python)
- The Makefile targets map directly — `make test`, `make check`, `make health` just call different commands

Document your stack-specific conventions in the relevant variant doc and reference
it from AGENTS.md's doc table.
