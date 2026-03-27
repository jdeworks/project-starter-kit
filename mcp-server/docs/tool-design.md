# Tool design

How to design effective MCP tools.

## Tool definition anatomy

```typescript
{
  name: "search_documents",
  description: "Search documents by keyword. Returns matching documents with title, snippet, and relevance score. Use when the user asks to find or look up documents.",
  inputSchema: {
    type: "object",
    properties: {
      query: { type: "string", description: "Search keywords" },
      limit: { type: "number", description: "Max results (default: 10)" }
    },
    required: ["query"]
  }
}
```

## Description writing guide

The description is the most important part — the AI reads it to decide when to use your tool.

**Good descriptions:**
- Explain what the tool does and what it returns
- Mention when to use it ("Use when the user asks to...")
- Note important constraints ("Only searches the current workspace")

**Bad descriptions:**
- Too vague: "Searches things"
- Too technical: "Executes a BM25 query against the inverted index"
- Missing return info: doesn't say what the tool returns

## Naming conventions

- Use `verb_noun` format: `search_documents`, `create_file`, `get_user`
- Be specific: `list_recent_orders` not just `list`
- Group related tools with a prefix: `db_query`, `db_insert`, `db_delete`

## Input schemas

- Mark required fields as `required`
- Provide `description` for every property — the AI reads these too
- Use sensible defaults for optional parameters
- Validate inputs in your handler, not just in the schema

## Return values

- Return structured data (JSON objects), not prose
- Include only relevant information — don't dump entire database rows
- For lists, include total count and whether there are more results
- For errors, return a clear message the AI can relay to the user

## One tool = one action

- Don't create "god tools" that do everything based on a `mode` flag
- Split into focused tools: `create_issue`, `update_issue`, `close_issue`
- It's better to have 10 focused tools than 1 complex tool

## Error handling

```typescript
if (!result) {
  return {
    content: [{
      type: "text",
      text: "Document not found. Check the ID and try again."
    }],
    isError: true
  }
}
```
