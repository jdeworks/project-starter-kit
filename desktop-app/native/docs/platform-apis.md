# Platform APIs

Accessing native platform features from .NET MAUI and other native frameworks.

## Common native capabilities (.NET MAUI)

| Feature | API | Notes |
|---------|-----|-------|
| Filesystem | `FileSystem.AppDataDirectory` | Platform-appropriate paths |
| Preferences | `Preferences.Set/Get` | Key-value storage |
| Secure storage | `SecureStorage.SetAsync` | Encrypted storage for secrets |
| File picker | `FilePicker.PickAsync` | Native file dialog |
| Notifications | `Plugin.LocalNotification` | Local notifications |
| Clipboard | `Clipboard.SetTextAsync` | Copy/paste |
| Connectivity | `Connectivity.NetworkAccess` | Network status |
| Geolocation | `Geolocation.GetLocationAsync` | GPS/location |

## Platform-conditional code

When behavior differs by platform, use partial classes or conditional compilation:

```csharp
// Shared interface
public interface IPlatformService
{
    string GetAppVersion();
}

// Platform-specific implementation
#if WINDOWS
public class PlatformService : IPlatformService
{
    public string GetAppVersion() => Package.Current.Id.Version.ToString();
}
#elif MACCATALYST
public class PlatformService : IPlatformService
{
    public string GetAppVersion() => NSBundle.MainBundle.InfoDictionary["CFBundleVersion"].ToString();
}
#endif
```

Or use dependency injection:
```csharp
builder.Services.AddSingleton<IPlatformService, PlatformService>();
```

## File paths

Never hardcode paths. Use platform-appropriate APIs:

```csharp
var appData = FileSystem.AppDataDirectory;
// Windows: C:\Users\X\AppData\Local\MyApp
// macOS: ~/Library/Application Support/MyApp
// Linux: ~/.local/share/MyApp
```

## Async everything

All platform API calls must be async. Never block the UI thread:

```csharp
// WRONG
var location = Geolocation.GetLocationAsync().Result;  // blocks UI

// RIGHT
var location = await Geolocation.GetLocationAsync();
```
