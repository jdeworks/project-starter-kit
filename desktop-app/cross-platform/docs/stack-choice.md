# Stack choice — cross-platform desktop frameworks

This variant uses Tauri 2 as its primary example.

## Choose Tauri when

- Binary size and memory usage matter (~5 MB vs Electron's ~150 MB)
- Security is a priority (Rust backend, permission-based API access)
- You want to use any web framework for the frontend
- You're comfortable with Rust (or willing to learn — the backend is usually simple)

## Choose Electron when

- Maximum ecosystem maturity — largest set of plugins and examples
- Node.js backend (no Rust needed)
- Consistent rendering across platforms (bundles Chromium)
- Your team has Electron experience

## Choose Wails when

- Your backend is Go
- You want Tauri-like architecture (OS webview, small binaries) without Rust
- You prefer Go's simplicity over Rust's complexity

## Choose Flutter when

- You want pixel-perfect UI identical across all platforms
- You're already using Flutter for mobile
- Native look-and-feel is not a priority (Flutter renders its own UI)

## Mapping kit patterns to your framework

| Kit concept | Tauri 2 | Electron | Wails |
|-------------|---------|----------|-------|
| Backend language | Rust | Node.js | Go |
| Frontend | Any web framework | Any web framework | Any web framework |
| IPC | Tauri commands + events | ipcMain/ipcRenderer | Bindings |
| Packaging | `tauri build` | `electron-builder` | `wails build` |
| Auto-update | tauri-plugin-updater | electron-updater | Built-in |
| Binary size | ~5 MB | ~150 MB | ~10 MB |
| Webview | OS native | Bundled Chromium | OS native |
