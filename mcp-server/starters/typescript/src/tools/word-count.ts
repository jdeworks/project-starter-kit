import { z } from "zod";
import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";

/** Pure function: count the number of words in a text string. */
export function wordCount(text: string): number {
  const trimmed = text.trim();
  if (trimmed.length === 0) return 0;
  return trimmed.split(/\s+/).length;
}

export function registerWordCountTool(server: McpServer): void {
  server.tool(
    "word_count",
    "Counts the number of words in the provided text",
    { text: z.string().describe("The text to count words in") },
    async ({ text }) => ({
      content: [{ type: "text", text: String(wordCount(text)) }],
    })
  );
}
