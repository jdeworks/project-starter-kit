# Testing CLI tools

Strategies for testing command-line applications.

## Unit tests

Test individual functions in isolation — argument parsing, data transformation, formatting:

```javascript
import { parseConfig } from '../src/config.js'

test('parses valid config file', () => {
  const config = parseConfig('{ "name": "test" }')
  expect(config.name).toBe('test')
})
```

## Integration tests

Test complete command execution — run the CLI as a subprocess and assert on output and exit code:

```javascript
import { execSync } from 'child_process'

test('init creates project directory', () => {
  const result = execSync('node ./bin/cli.js init --name test-project', {
    encoding: 'utf8',
  })
  expect(result).toContain('Project created')
})

test('exits with code 1 on invalid input', () => {
  expect(() => {
    execSync('node ./bin/cli.js init', { encoding: 'utf8' })
  }).toThrow()
})
```

## Snapshot tests

For CLIs with formatted output (tables, help text), use snapshot tests:

```javascript
test('help output matches snapshot', () => {
  const result = execSync('node ./bin/cli.js --help', { encoding: 'utf8' })
  expect(result).toMatchSnapshot()
})
```

Update snapshots when output intentionally changes: `vitest --update`

## Testing exit codes

Exit codes are part of your API. Test them:
- `0` — command succeeded
- `1` — general error (bad input, operation failed)
- `2` — usage error (wrong flags, missing arguments)

## Tips

- Use a temp directory for tests that create files — clean up after each test
- Test both interactive (TTY) and non-interactive (pipe) modes
- Test `--no-color` output separately if you use colors
- Test error messages, not just happy paths
