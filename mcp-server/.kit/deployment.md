# MCP server deployment

Running and distributing your MCP server.

## Local (stdio)

Most common for personal/local tools. The AI client spawns your server as a subprocess.

### Claude Code configuration

Add to `~/.claude.json` or project `.claude/settings.json`:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["/path/to/my-server/src/index.js"]
    }
  }
}
```

### Distribution via npm

Publish to npm so users can install globally:

```bash
npm install -g my-mcp-server
```

Then configure in their client:
```json
{
  "mcpServers": {
    "my-server": {
      "command": "my-mcp-server"
    }
  }
}
```

## Remote (SSE)

For servers that need to be accessible over the network:

```typescript
import { SSEServerTransport } from '@modelcontextprotocol/sdk/server/sse.js'

const transport = new SSEServerTransport('/messages', response)
await server.connect(transport)
```

Deploy like any web server (Docker, Railway, Fly.io).

## Packaging as a binary

For distribution without runtime dependencies:

- **Node.js:** Use `pkg` or `esbuild --bundle` + `node --experimental-sea`
- **Go/Rust:** Compile to a static binary
- **Python:** Use `pyinstaller` or `shiv`

## Environment variables

MCP servers often need API keys or configuration:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["./src/index.js"],
      "env": {
        "API_KEY": "your-key-here"
      }
    }
  }
}
```

Document required environment variables in your README.
