# Native APIs

Accessing platform features from your desktop app.

## Common native capabilities

| Feature | Tauri 2 | Electron | Notes |
|---------|---------|----------|-------|
| Filesystem | `@tauri-apps/plugin-fs` | `fs` module | Read/write files |
| Dialogs | `@tauri-apps/plugin-dialog` | `dialog` module | Open/save file dialogs |
| Notifications | `@tauri-apps/plugin-notification` | `Notification` API | System notifications |
| System tray | `TrayIcon` API | `Tray` module | Tray icon + menu |
| Clipboard | `@tauri-apps/plugin-clipboard` | `clipboard` module | Copy/paste |
| Shell | `@tauri-apps/plugin-shell` | `child_process` | Run system commands |
| Auto-start | `@tauri-apps/plugin-autostart` | `auto-launch` | Start on login |
| Global shortcuts | `@tauri-apps/plugin-global-shortcut` | `globalShortcut` | System-wide hotkeys |

## File paths

Use platform-appropriate paths — never hardcode:

```typescript
import { appDataDir, homeDir } from '@tauri-apps/api/path'

const dataDir = await appDataDir()    // ~/.local/share/my-app (Linux)
                                       // ~/Library/Application Support/my-app (macOS)
                                       // C:\Users\X\AppData\Roaming\my-app (Windows)
```

## Platform differences to handle

- **File paths:** `/` vs `\`, case sensitivity
- **Menu bar:** macOS has a global menu bar; Windows/Linux have per-window menus
- **Window controls:** macOS has traffic lights on the left; Windows has buttons on the right
- **Notifications:** Different permission models per OS
- **Tray icons:** Different sizes and formats per platform

## Best practices

- Request only the permissions you need (especially in Tauri)
- Gracefully handle denied permissions
- Test native features on all target platforms
- Provide fallbacks where possible (e.g., if notifications are denied, show in-app)
