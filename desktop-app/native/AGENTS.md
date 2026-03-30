# AGENTS.md — desktop-app/native variant

Extends base AGENTS.md. Read that first, then this file.

## This variant covers

Native desktop applications using platform-native UI frameworks. The rules and docs below
focus on C# / .NET MAUI as the primary example but the patterns apply to other native
frameworks (WPF, WinUI 3, SwiftUI, GTK). Native apps use platform-native controls instead
of a web view.

> **Using a different framework?** The patterns (MVVM, platform APIs, packaging) carry over.
> See `.kit/stack-choice.md` for mapping guidance.
> If your stack isn't covered, please open a PR — see CONTRIBUTING.md.

---

## Quick start

Pick a starter when composing your project — each gives you a working hello-world:

- `dotnet-maui` — .NET MAUI cross-platform native app with C# and XAML

Then: `dotnet build && dotnet run`

See `.kit/stack-choice.md` for a full comparison.

---

## Variant-specific docs — read on demand

| Doc | Read when |
|-----|-----------|
| `.kit/mvvm-pattern.md` | Structuring app code with Model-View-ViewModel |
| `.kit/platform-apis.md` | Accessing native platform features (filesystem, notifications, etc.) |
| `.kit/packaging-native.md` | Building installers, code signing, store distribution |
| `.kit/stack-choice.md` | Choosing between .NET MAUI, WPF, WinUI 3, SwiftUI |

---

## Native desktop-specific rules (extend base rules)

1. **MVVM pattern.** Separate UI (View) from logic (ViewModel) and data (Model). ViewModels should be unit-testable without UI.
2. **Platform-conditional code.** Use `#if` directives or dependency injection to handle platform differences. Don't scatter platform checks through business logic.
3. **Async UI.** Never block the UI thread. All I/O, network, and heavy computation must be async.
4. **Native look and feel.** Use platform-native controls and conventions. Don't fight the OS.
5. **Test ViewModels, not Views.** Business logic lives in ViewModels and services — test those. Visual testing is manual.

## LOC budget override

Native apps tend to have more boilerplate:
```
SOFT_FILE_LOC=300
HARD_FILE_LOC=400
LOC_BUDGET=20000
```

---

## Why .NET MAUI as the example

We need a concrete example to show patterns. We chose .NET MAUI because:
- Single codebase for Windows, macOS, iOS, and Android
- C# is widely known with excellent tooling (Visual Studio, Rider)
- Mature ecosystem (NuGet, Entity Framework, ML.NET)
- Strong MVVM support with CommunityToolkit.Mvvm

**This is a recommendation, not a requirement.** WPF is better for Windows-only apps.
SwiftUI is better for Apple-only apps. See `.kit/stack-choice.md` for guidance.
