# Testing MCP servers

How to test your MCP server at different levels.

## Unit tests

Test tool handler functions in isolation:

```typescript
import { handleSearchDocuments } from '../src/tools/search.js'

test('returns matching documents', async () => {
  const result = await handleSearchDocuments({ query: 'testing', limit: 5 })
  expect(result.content).toHaveLength(1)
  expect(result.content[0].text).toContain('testing')
})

test('returns empty for no matches', async () => {
  const result = await handleSearchDocuments({ query: 'nonexistent' })
  expect(result.content[0].text).toContain('No results')
})
```

## Integration tests

Test the full MCP protocol flow using the SDK's test utilities:

```typescript
import { Client } from '@modelcontextprotocol/sdk/client/index.js'
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js'

test('server lists tools correctly', async () => {
  const transport = new StdioClientTransport({
    command: 'node',
    args: ['./src/index.js'],
  })
  const client = new Client({ name: 'test', version: '1.0' })
  await client.connect(transport)

  const tools = await client.listTools()
  expect(tools.tools.map(t => t.name)).toContain('search_documents')

  await client.close()
})
```

## Manual testing with Claude Code

The fastest way to test your MCP server end-to-end:

1. Add your server to Claude Code's MCP config
2. Ask Claude to use the tool
3. Verify the tool executes correctly and returns useful results

## Testing checklist

- [ ] Every tool has at least one happy-path test
- [ ] Every tool has an error-case test (bad input, missing data)
- [ ] Tool descriptions are accurate (manually verify)
- [ ] Input validation rejects invalid inputs with clear errors
- [ ] Server starts and responds to `initialize` correctly
- [ ] `tools/list` returns all expected tools
