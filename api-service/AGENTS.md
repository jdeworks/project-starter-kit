# AGENTS.md — api-service variant

Extends base AGENTS.md. Read that first, then this file.

## This variant covers

Backend API development — REST or GraphQL — without a frontend.
The rules and docs below are **framework-agnostic**. They apply whether you're building with
Hono, Express, FastAPI, Go's net/http, or anything else. The example commands use Node.js + Hono
as a concrete starting point — adapt them to your stack.

> **Using a different framework?** The patterns (input validation, layered architecture,
> migration discipline) carry over. Only the specific commands and libraries change.
> See `docs/stack-choice.md` for mapping guidance. If your stack isn't covered,
> please open a PR — see CONTRIBUTING.md.

---

## Quick start (example: Node.js + Hono)

```bash
npm create hono@latest my-api -- --template nodejs
cd my-api
npm install
npm run dev
```

<details>
<summary>Other stacks</summary>

**Go:**
```bash
mkdir my-api && cd my-api && go mod init my-api
# use net/http, Chi, or Echo
```

**Python + FastAPI:**
```bash
pip install fastapi uvicorn
uvicorn main:app --reload
```

**C# / .NET:**
```bash
dotnet new webapi -n MyApi && cd MyApi && dotnet run
```

See `docs/stack-choice.md` for a full comparison.
</details>

---

## Variant-specific docs — read on demand

| Doc | Read when |
|-----|-----------|
| `docs/api-design.md` | Designing new endpoints, choosing REST vs GraphQL |
| `docs/database.md` | Setting up a database, writing migrations, choosing an ORM |
| `docs/auth.md` | Adding authentication or authorization |
| `docs/error-handling.md` | Designing error responses, status codes, validation |
| `docs/deployment.md` | Deploying to a cloud provider, containerizing |
| `docs/stack-choice.md` | Evaluating frameworks, mapping kit patterns to your stack |

---

## API-specific rules (extend base rules)

These rules are stack-agnostic — adapt the specific tools to your language.

1. **Every endpoint needs a test.** At minimum: one happy-path test and one error-case test per route.
2. **Validate all input at the boundary.** Use your language's validation library (Zod, Pydantic, go-playground/validator, FluentValidation, etc.). Never trust raw request data.
3. **No business logic in route handlers.** Handlers call service functions; services call repositories. Keep the layers clean.
4. **Return consistent error shapes.** All errors follow one format. Don't leak stack traces in production.
5. **Migrations are forward-only.** Never edit an existing migration. Create a new one.

## LOC budget override

API services are typically more modular than frontend apps. Keep files small:
```
SOFT_FILE_LOC=200
HARD_FILE_LOC=300
LOC_BUDGET=12000
```

---

## Why Hono as the example

We need a concrete example to show patterns. We chose Hono because:
- TypeScript-first with built-in request/response types
- Runs anywhere — Node.js, Deno, Bun, Cloudflare Workers, AWS Lambda, Vercel
- Fastest Node.js framework in benchmarks (lighter than Express, comparable to Fastify)
- ~12 KB core — no bloat, no hidden magic

**This is a recommendation, not a requirement.** The kit works with any backend stack.
See `docs/stack-choice.md` for when a different framework is the better call, and how to
map the Makefile targets and test patterns to your chosen stack.
