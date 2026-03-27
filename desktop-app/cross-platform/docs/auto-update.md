# Auto-update

Implementing automatic updates for desktop apps.

## How it works

1. App checks for updates on startup (or periodically)
2. Compares current version with latest available version
3. Downloads the update in the background
4. Prompts user to restart (or installs silently on next launch)

## Tauri updater

```rust
// tauri.conf.json
{
  "plugins": {
    "updater": {
      "endpoints": ["https://releases.myapp.com/{{target}}/{{arch}}/{{current_version}}"],
      "pubkey": "YOUR_PUBLIC_KEY"
    }
  }
}
```

```typescript
import { check } from '@tauri-apps/plugin-updater'

const update = await check()
if (update) {
  await update.downloadAndInstall()
  // Prompt user to restart
}
```

## Electron updater

```typescript
import { autoUpdater } from 'electron-updater'

autoUpdater.checkForUpdatesAndNotify()

autoUpdater.on('update-downloaded', () => {
  // Prompt user to restart
  autoUpdater.quitAndInstall()
})
```

## Update server options

| Option | Cost | Notes |
|--------|------|-------|
| **GitHub Releases** | Free | Works with both Tauri and Electron updaters |
| **Self-hosted** | Server cost | Full control, custom update logic |
| **Vercel/Cloudflare** | Free tier | Static JSON endpoint for update manifest |

## Best practices

- Always sign updates (Tauri requires this by default)
- Show update progress to the user
- Don't force-restart — let the user choose when to apply
- Test the full update cycle before releasing (install v1, update to v2)
- Include release notes so users know what changed
- Fall back gracefully if the update server is unreachable
