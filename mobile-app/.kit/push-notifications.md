# Push notifications

Adding push notification support to mobile apps.

## Expo Notifications

```bash
npm install expo-notifications expo-device expo-constants
```

### Request permissions

```typescript
import * as Notifications from 'expo-notifications'
import * as Device from 'expo-device'

async function registerForPushNotifications() {
  if (!Device.isDevice) return null  // Notifications don't work in simulators

  const { status } = await Notifications.requestPermissionsAsync()
  if (status !== 'granted') return null

  const token = await Notifications.getExpoPushTokenAsync()
  return token.data  // Send this to your server
}
```

### Handle incoming notifications

```typescript
import { useEffect } from 'react'
import * as Notifications from 'expo-notifications'

useEffect(() => {
  // Foreground notification handler
  const sub = Notifications.addNotificationReceivedListener(notification => {
    console.log('Received:', notification)
  })

  // User tapped notification
  const tapSub = Notifications.addNotificationResponseReceivedListener(response => {
    const data = response.notification.request.content.data
    // Navigate based on data
  })

  return () => { sub.remove(); tapSub.remove() }
}, [])
```

### Send from server

```javascript
await fetch('https://exp.host/--/api/v2/push/send', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    to: pushToken,
    title: 'New message',
    body: 'You have a new message',
    data: { screen: 'chat', id: '123' },
  }),
})
```

## Best practices

- Always check `Device.isDevice` — simulators don't support push
- Handle permission denial gracefully — don't block the app
- Store push tokens on your server, update on every app launch
- Use notification categories for actionable notifications
- Test with real devices, not simulators
