# Stack choice — MCP server SDKs

This variant uses the TypeScript MCP SDK as its primary example.

## Official SDKs

| SDK | Language | Maintained by | Status |
|-----|----------|--------------|--------|
| `@modelcontextprotocol/sdk` | TypeScript | MCP project | Stable |
| `mcp` | Python | MCP project | Stable |

## Choose TypeScript when

- You're building tools that interact with web APIs or Node.js ecosystem
- Your team knows TypeScript
- You want Zod-based input validation with automatic JSON Schema generation
- You're deploying alongside other Node.js services

## Choose Python when

- Your tools wrap Python libraries (ML models, data processing, scientific computing)
- Your team is Python-first
- You're building tools for data analysis or file processing

## Raw implementation (any language)

MCP is JSON-RPC 2.0 over stdio or HTTP+SSE. You can implement it in any language:
1. Read JSON-RPC messages from stdin (or HTTP request body)
2. Handle `initialize`, `tools/list`, `tools/call`, `resources/list`, `resources/read`
3. Write JSON-RPC responses to stdout (or HTTP response)

This is more work but gives you maximum flexibility. Good for Go, Rust, C#, etc.

## Mapping kit patterns to your stack

| Kit concept | TypeScript SDK | Python SDK |
|-------------|---------------|------------|
| Server setup | `new Server()` | `Server()` |
| Tool definition | `server.setRequestHandler(ListToolsRequestSchema, ...)` | `@server.list_tools()` |
| Input validation | Zod schemas | Pydantic models |
| Test runner | Vitest | pytest |
| Transport | stdio or SSE | stdio or SSE |
