# IPC and commands

Communicating between the frontend (webview) and backend (native code).

## The IPC boundary

Desktop apps have two layers:
- **Frontend** — web code running in a webview (HTML/CSS/JS)
- **Backend** — native code (Rust/Node.js/Go) with system access

IPC (Inter-Process Communication) bridges these layers. Treat it as a security boundary.

## Tauri commands (example)

### Backend (Rust)

```rust
#[tauri::command]
fn read_file(path: String) -> Result<String, String> {
    std::fs::read_to_string(&path).map_err(|e| e.to_string())
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![read_file])
        .run(tauri::generate_context!())
        .expect("error running app");
}
```

### Frontend (TypeScript)

```typescript
import { invoke } from '@tauri-apps/api/core'

const content = await invoke<string>('read_file', { path: '/tmp/test.txt' })
```

## Events (bidirectional)

For real-time updates (progress, notifications), use events instead of commands:

```typescript
// Frontend listens
import { listen } from '@tauri-apps/api/event'
await listen('download-progress', (event) => {
  console.log(`Progress: ${event.payload}%`)
})

// Backend emits
window.emit("download-progress", 42);
```

## Security rules

- **Validate all inputs** from the frontend in your backend command handlers
- **Don't expose raw shell or filesystem** — create specific commands for specific operations
- **Use Tauri's permission system** to limit what the frontend can access
- **Never pass user input directly to system commands** — sanitize and validate

## Error handling

Always return `Result` types from commands. The frontend should handle both success and error:

```typescript
try {
  const result = await invoke('risky_operation', { input })
} catch (error) {
  showError(`Operation failed: ${error}`)
}
```
