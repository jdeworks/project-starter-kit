# Distribution

Packaging and distributing your CLI tool.

## Distribution channels

| Channel | Best for | Language |
|---------|----------|----------|
| **npm** (`npx my-cli`) | JS/TS CLIs, Node.js users | Node.js |
| **Homebrew** | macOS/Linux users | Any (binary or formula) |
| **GitHub Releases** | Universal, manual install | Any (attach binaries) |
| **pip** (`pipx install my-cli`) | Python CLIs | Python |
| **cargo install** | Rust ecosystem users | Rust |
| **go install** | Go ecosystem users | Go |
| **Docker** | Isolation, complex dependencies | Any |

## npm distribution (Node.js)

### package.json setup

```json
{
  "name": "my-cli",
  "version": "1.0.0",
  "bin": {
    "my-cli": "./bin/cli.js"
  },
  "files": ["bin/", "src/", "dist/"],
  "engines": {
    "node": ">=20"
  }
}
```

### Shebang line

The entry point script needs a shebang:
```javascript
#!/usr/bin/env node
import { program } from 'commander'
// ...
```

### Publish

```bash
npm publish            # public package
npm publish --access public  # scoped package (@scope/my-cli)
```

## Single-binary distribution (Go, Rust)

### Cross-compile

**Go:**
```bash
GOOS=linux GOARCH=amd64 go build -o my-cli-linux-amd64
GOOS=darwin GOARCH=arm64 go build -o my-cli-darwin-arm64
GOOS=windows GOARCH=amd64 go build -o my-cli-windows-amd64.exe
```

**Rust:**
```bash
cargo build --release --target x86_64-unknown-linux-gnu
cargo build --release --target aarch64-apple-darwin
```

### GitHub Releases

Attach binaries to a GitHub release. Use GoReleaser (Go) or `cargo-dist` (Rust) to automate.

## Versioning

- Follow semver: `major.minor.patch`
- Bump major for breaking CLI changes (removed flags, changed output format)
- Bump minor for new commands/flags
- Bump patch for bug fixes
- Your CLI should report its version via `--version`
