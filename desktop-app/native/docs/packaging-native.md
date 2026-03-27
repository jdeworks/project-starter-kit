# Packaging native apps

Building installers, signing, and distributing native desktop applications.

## .NET MAUI packaging

### Windows
```bash
dotnet publish -f net8.0-windows10.0.19041.0 -c Release
```
Outputs MSIX package for Microsoft Store or sideloading.

### macOS
```bash
dotnet publish -f net8.0-maccatalyst -c Release
```
Outputs .app bundle. Sign with Apple Developer ID for distribution.

## Code signing

### Windows
- **Microsoft Store:** MSIX is automatically signed during Store submission
- **Sideloading:** Use a code signing certificate (EV recommended to avoid SmartScreen warnings)

### macOS
- **Required:** macOS blocks unsigned apps (Gatekeeper)
- Get an Apple Developer ID ($99/year)
- Notarize the app for distribution outside the App Store

```bash
# Sign
codesign --deep --force --sign "Developer ID Application: Your Name" MyApp.app

# Notarize
xcrun notarytool submit MyApp.zip --apple-id your@email.com --team-id XXXXX
```

## Distribution channels

| Channel | Platform | Notes |
|---------|----------|-------|
| Microsoft Store | Windows | MSIX format, auto-updates |
| Mac App Store | macOS | Sandboxed, Apple review process |
| GitHub Releases | All | Direct download, manual updates |
| Homebrew Cask | macOS | Community-maintained formulas |
| winget | Windows | Windows Package Manager |
| Website download | All | Direct distribution, you handle updates |

## Auto-updates

For apps distributed outside app stores:
- .NET MAUI: Use Squirrel.Windows or custom update checker
- WPF: ClickOnce (built-in) or Squirrel.Windows
- SwiftUI: Sparkle framework

## CI/CD

Build for all platforms in CI:

```yaml
jobs:
  build-windows:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-dotnet@v4
      - run: dotnet publish -f net8.0-windows10.0.19041.0 -c Release

  build-macos:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-dotnet@v4
      - run: dotnet publish -f net8.0-maccatalyst -c Release
```
