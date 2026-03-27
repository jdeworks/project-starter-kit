# AGENTS.md — desktop-app/cross-platform variant

Extends base AGENTS.md. Read that first, then this file.

## This variant covers

Cross-platform desktop applications for Windows, macOS, and Linux. The rules and docs below
are **framework-agnostic** where possible. They apply whether you're using Tauri, Electron,
or another cross-platform desktop framework. The example commands use Tauri 2 as a concrete
starting point — adapt them to your stack.

> **Using a different framework?** The patterns (IPC boundaries, native API access, packaging)
> carry over. See `docs/stack-choice.md` for mapping guidance.
> If your stack isn't covered, please open a PR — see CONTRIBUTING.md.

---

## Quick start (example: Tauri 2)

```bash
npm create tauri-app@latest my-app -- --template vanilla-ts
cd my-app
npm install
npm run tauri dev
```

<details>
<summary>Other stacks</summary>

**Electron:**
```bash
npm init electron-app@latest my-app -- --template=vite-typescript
cd my-app && npm start
```

**Wails (Go + web frontend):**
```bash
wails init -n my-app -t vanilla-ts
cd my-app && wails dev
```

See `docs/stack-choice.md` for a full comparison.
</details>

---

## Variant-specific docs — read on demand

| Doc | Read when |
|-----|-----------|
| `docs/ipc-and-commands.md` | Communicating between frontend (webview) and backend (native) |
| `docs/native-apis.md` | Accessing filesystem, notifications, system tray, clipboard |
| `docs/packaging.md` | Building installers for Windows (.msi), macOS (.dmg), Linux (.deb/.AppImage) |
| `docs/auto-update.md` | Implementing automatic updates |
| `docs/stack-choice.md` | Choosing between Tauri, Electron, Wails, or other frameworks |

---

## Desktop-specific rules (extend base rules)

1. **IPC is a security boundary.** The frontend (webview) is untrusted. Validate all data crossing the IPC bridge. Never expose raw filesystem or shell access to the frontend.
2. **Test on all target platforms.** macOS, Windows, and Linux behave differently for file paths, permissions, tray icons, and notifications. Test on all platforms you ship to.
3. **Handle offline gracefully.** Desktop apps are expected to work offline. Don't assume network availability.
4. **Respect OS conventions.** Use native file dialogs, follow platform menu conventions, support system dark mode.
5. **Keep the backend thin.** Most logic should live in the frontend (web) layer. Use the native backend only for things the browser can't do (filesystem, system APIs).

## LOC budget override

Desktop apps can be larger:
```
SOFT_FILE_LOC=300
HARD_FILE_LOC=400
LOC_BUDGET=20000
```

---

## Why Tauri 2 as the example

We need a concrete example to show patterns. We chose Tauri 2 because:
- Rust backend — small binaries (~5 MB vs Electron's ~150 MB), lower memory usage
- Uses the OS webview (no bundled Chromium)
- Strong security model with explicit permissions
- Supports any web framework for the frontend

**This is a recommendation, not a requirement.** Electron is more mature with a larger
ecosystem. Wails is excellent for Go teams. See `docs/stack-choice.md` for guidance.
