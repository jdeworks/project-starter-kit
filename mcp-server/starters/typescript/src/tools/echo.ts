import { z } from "zod";
import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";

/** Pure function: returns the input text unchanged. */
export function echo(text: string): string {
  return text;
}

export function registerEchoTool(server: McpServer): void {
  server.tool(
    "echo",
    "Returns the input text unchanged",
    { text: z.string().describe("The text to echo back") },
    async ({ text }) => ({
      content: [{ type: "text", text: echo(text) }],
    })
  );
}
