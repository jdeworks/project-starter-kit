#!/usr/bin/env node

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { registerEchoTool } from "./tools/echo.js";
import { registerWordCountTool } from "./tools/word-count.js";

const server = new McpServer({
  name: "my-mcp-server",
  version: "1.0.0",
});

registerEchoTool(server);
registerWordCountTool(server);

async function main(): Promise<void> {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((error) => {
  console.error("Server error:", error);
  process.exit(1);
});
