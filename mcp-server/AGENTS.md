# AGENTS.md — mcp-server variant

Extends base AGENTS.md. Read that first, then this file.

## This variant covers

Model Context Protocol (MCP) servers — tools and resources that AI agents can discover and use.
MCP is an open protocol for connecting AI assistants to external capabilities. The rules and
docs below apply whether you're building a tool server, resource server, or both.

The example commands use the TypeScript MCP SDK. Python SDK is also officially supported.

> **Using a different language?** The protocol is language-agnostic (JSON-RPC over stdio or
> SSE). See `.kit/stack-choice.md` for SDK options.
> If your stack isn't covered, please open a PR — see CONTRIBUTING.md.

---

## Quick start

Pick a starter when composing your project — each gives you a working hello-world:

- `typescript` — MCP server with TypeScript SDK, Zod validation, stdio transport

Then: `npm install`

See `.kit/stack-choice.md` for other SDK options.

---

## Variant-specific docs — read on demand

| Doc | Read when |
|-----|-----------|
| `.kit/mcp-concepts.md` | Understanding MCP protocol: tools, resources, prompts, transports |
| `.kit/tool-design.md` | Designing tool definitions — names, descriptions, input schemas |
| `.kit/testing-mcp.md` | Testing MCP servers — unit, integration, and with real clients |
| `.kit/deployment.md` | Running MCP servers — stdio, SSE, packaging for distribution |
| `.kit/stack-choice.md` | Choosing between TypeScript SDK, Python SDK, or raw implementation |

---

## MCP-specific rules (extend base rules)

1. **Tool descriptions are your UX.** The AI reads your tool descriptions to decide when and how to use them. Write them like documentation, not code comments.
2. **Validate all inputs with schemas.** Every tool must define a Zod (or equivalent) input schema. The MCP protocol uses JSON Schema — your SDK generates it from your code.
3. **Tools are idempotent where possible.** An AI might call the same tool multiple times. Design for safe retries.
4. **Return structured data, not prose.** Tools should return data the AI can act on, not paragraphs of text. Keep responses focused and machine-readable.
5. **Fail with clear error messages.** When a tool fails, return an error the AI can understand and relay to the user. Include what went wrong and what to try instead.

## LOC budget override

MCP servers are typically small and focused:
```
SOFT_FILE_LOC=200
HARD_FILE_LOC=300
LOC_BUDGET=6000
```

---

## Why TypeScript MCP SDK as the example

We need a concrete example to show patterns. We chose the TypeScript SDK because:
- Official SDK maintained by the MCP project
- Strong type inference for tool definitions
- Zod integration for input validation
- Same language ecosystem as Claude Code and many MCP clients

**This is a recommendation, not a requirement.** The Python SDK is equally well-supported.
See `.kit/stack-choice.md` for all options.
