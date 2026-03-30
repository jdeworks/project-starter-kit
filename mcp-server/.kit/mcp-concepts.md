# MCP concepts

Core concepts of the Model Context Protocol.

## What MCP is

MCP (Model Context Protocol) is an open protocol that lets AI assistants discover and use
external tools and data sources. Think of it as a standardized plugin system for AI.

## The three primitives

### Tools

Functions the AI can call to perform actions:
- Read/write files, query databases, call APIs
- Must have a name, description, and input schema
- The AI decides when to call them based on the description

### Resources

Data the AI can read for context:
- Files, database records, API responses, documentation
- Identified by URI (`file:///path`, `db://table/id`, `https://...`)
- Read-only — the AI requests them, you return content

### Prompts

Pre-built prompt templates the server offers:
- Reusable prompt patterns with arguments
- Listed by the server, selected by the user or AI
- Less common than tools and resources

## Transports

How the client and server communicate:

| Transport | How it works | Best for |
|-----------|-------------|----------|
| **stdio** | Client spawns server as subprocess, communicates via stdin/stdout | Local tools, desktop agents |
| **SSE** | HTTP server with Server-Sent Events | Remote servers, web clients |

stdio is simpler and most common for local MCP servers.

## Protocol flow

1. Client sends `initialize` with capabilities
2. Server responds with its capabilities (tools, resources, prompts)
3. Client calls `tools/list` to discover available tools
4. Client calls `tools/call` with tool name and arguments
5. Server executes the tool and returns the result

## JSON-RPC

MCP uses JSON-RPC 2.0. Every message has:
```json
{"jsonrpc": "2.0", "id": 1, "method": "tools/call", "params": {...}}
```

You don't need to handle this directly — the SDKs abstract it.
