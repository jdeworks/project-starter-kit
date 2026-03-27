# MCP server starter

Model Context Protocol servers — tools and resources that AI agents can discover and use.

**Example stack:** TypeScript MCP SDK (also supports Python SDK — see [docs/stack-choice.md](docs/stack-choice.md))

## Get started

```bash
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) mcp-server my-mcp
```

<details>
<summary>Manual setup</summary>

```bash
git clone --filter=blob:none --no-checkout --depth=1 -b dev \
  https://github.com/jdeworks/project-starter-kit.git /tmp/_psk
cd /tmp/_psk && git sparse-checkout init --cone
git sparse-checkout set base mcp-server cli && git checkout dev
bash cli/compose.sh --variant mcp-server --mode full --target ~/my-mcp --yes
rm -rf /tmp/_psk && cd ~/my-mcp
```

</details>

## What you get

```
my-mcp/
├── AGENTS.md
├── Makefile
├── docs/
│   ├── mcp-concepts.md     # Tools, resources, prompts, transports
│   ├── tool-design.md      # Naming, descriptions, input schemas, returns
│   ├── testing-mcp.md      # Unit, integration, manual testing
│   ├── deployment.md       # stdio, SSE, npm, binaries
│   └── stack-choice.md     # TypeScript SDK vs Python SDK vs raw JSON-RPC
├── scripts/
└── .claude/
```

## Next step

> Read AGENTS.md and tell me what mode we're in and what commands are available.
