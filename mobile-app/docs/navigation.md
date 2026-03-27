# Navigation

Setting up navigation in mobile apps.

## Expo Router (recommended for new projects)

Expo Router provides file-based routing (like Next.js for mobile):

```bash
npm install expo-router
```

### File structure

```
app/
  _layout.tsx       # Root layout (wraps all screens)
  index.tsx         # Home screen (/)
  about.tsx         # About screen (/about)
  (tabs)/
    _layout.tsx     # Tab layout
    home.tsx        # Tab: Home
    profile.tsx     # Tab: Profile
  [id].tsx          # Dynamic route (/123)
```

### Root layout

```tsx
import { Stack } from 'expo-router'

export default function RootLayout() {
  return <Stack />
}
```

### Navigation

```tsx
import { Link, useRouter } from 'expo-router'

// Declarative
<Link href="/about">About</Link>

// Programmatic
const router = useRouter()
router.push('/about')
router.replace('/login')  // no back button
router.back()
```

## React Navigation (alternative)

For more control over navigation behavior:

```bash
npm install @react-navigation/native @react-navigation/native-stack
```

Choose React Navigation when you need complex navigation patterns (drawers, custom transitions, deep linking with query params).

## Deep linking

Both Expo Router and React Navigation support deep links:
- Configure URL scheme in `app.json`: `"scheme": "myapp"`
- Handle links: `myapp://path/to/screen`
- Universal links (iOS) and App Links (Android) for `https://` URLs

## Best practices

- Keep navigation structure flat (max 3 levels deep)
- Use tabs for top-level navigation (3–5 tabs max)
- Stack navigation for drill-down flows
- Always provide a way to go back
- Handle deep links for all important screens
