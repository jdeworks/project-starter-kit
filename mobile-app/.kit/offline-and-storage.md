# Offline support and storage

Handling offline scenarios and local data in mobile apps.

## Storage options

| Storage | Use for | Encrypted | Size limit |
|---------|---------|-----------|------------|
| **AsyncStorage** | User preferences, cache | No | ~6 MB |
| **SecureStore** | Tokens, passwords, API keys | Yes | ~2 KB per item |
| **SQLite** | Structured data, offline-first apps | No | Device storage |
| **MMKV** | High-performance key-value | Optional | Device storage |

## AsyncStorage (simple key-value)

```typescript
import AsyncStorage from '@react-native-async-storage/async-storage'

await AsyncStorage.setItem('user_prefs', JSON.stringify(prefs))
const prefs = JSON.parse(await AsyncStorage.getItem('user_prefs') ?? '{}')
```

## SecureStore (sensitive data)

```typescript
import * as SecureStore from 'expo-secure-store'

await SecureStore.setItemAsync('auth_token', token)
const token = await SecureStore.getItemAsync('auth_token')
```

## Offline-first patterns

### Cache API responses

```typescript
async function fetchWithCache(url: string) {
  try {
    const response = await fetch(url)
    const data = await response.json()
    await AsyncStorage.setItem(`cache:${url}`, JSON.stringify(data))
    return data
  } catch {
    // Offline — return cached data
    const cached = await AsyncStorage.getItem(`cache:${url}`)
    return cached ? JSON.parse(cached) : null
  }
}
```

### Detect connectivity

```typescript
import { useNetInfo } from '@react-native-community/netinfo'

const { isConnected } = useNetInfo()
// Show offline indicator when !isConnected
```

## Best practices

- Assume network is unreliable — always have a fallback
- Show cached data immediately, refresh in the background
- Queue mutations offline, sync when connected (optimistic updates)
- Never store sensitive data in AsyncStorage — use SecureStore
- Show clear offline indicators to the user
