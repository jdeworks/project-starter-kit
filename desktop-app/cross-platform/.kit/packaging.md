# Packaging

Building installers for distribution.

## Installer formats by platform

| Platform | Format | Notes |
|----------|--------|-------|
| Windows | `.msi`, `.exe` (NSIS) | MSI for enterprise, NSIS for consumer |
| macOS | `.dmg`, `.app` | DMG for distribution, sign with Apple Developer ID |
| Linux | `.deb`, `.rpm`, `.AppImage` | AppImage works across distros |

## Tauri build

```bash
npm run tauri build
```

Outputs platform-specific installers to `src-tauri/target/release/bundle/`.

## Electron build

```bash
npx electron-builder --mac --win --linux
```

Configure in `electron-builder.yml` or `package.json`.

## Code signing

**Required for macOS** (unsigned apps are blocked by Gatekeeper):
- Get an Apple Developer ID ($99/year)
- Sign with `codesign` or let your build tool handle it

**Recommended for Windows** (SmartScreen warns on unsigned apps):
- Get an EV code signing certificate
- Sign with `signtool` or your build tool

**Linux** doesn't require signing, but package repositories may have their own signing.

## Auto-update

See `.kit/auto-update.md` for implementing automatic updates.

## CI/CD

Build installers in CI for all platforms:

```yaml
# GitHub Actions — build on all platforms
jobs:
  build:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run tauri build
      - uses: actions/upload-artifact@v4
        with:
          name: installer-${{ matrix.os }}
          path: src-tauri/target/release/bundle/
```

## Distribution

- **GitHub Releases** — attach installers to a release
- **Homebrew Cask** (macOS) — create a formula
- **Microsoft Store** — submit MSIX package
- **Snap Store / Flathub** (Linux) — containerized distribution
