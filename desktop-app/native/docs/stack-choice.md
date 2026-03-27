# Stack choice — native desktop frameworks

This variant uses .NET MAUI as its primary example.

## Choose .NET MAUI when

- You need Windows + macOS (+ iOS + Android) from one codebase
- Your team knows C# / .NET
- XAML-based UI is acceptable
- You want access to the full .NET ecosystem (NuGet)

## Choose WPF when

- Windows-only application
- Maximum maturity and ecosystem for Windows desktop
- Complex data-binding scenarios
- Your team has WPF experience (large existing knowledge base)

## Choose WinUI 3 when

- Windows-only with modern Windows 11 design (Fluent Design)
- You want the latest Microsoft UI framework
- Packaging via MSIX for Microsoft Store distribution

## Choose SwiftUI when

- macOS-only (or Apple ecosystem: macOS + iOS + watchOS + visionOS)
- You want the most native Apple experience
- Declarative UI appeals to you
- Your team knows Swift

## Choose GTK / Qt when

- Linux-first development
- True cross-platform native UI (GTK or Qt)
- You prefer C, C++, Python, or Rust
- Open-source licensing matters

## Mapping kit patterns to your framework

| Kit concept | .NET MAUI | WPF | SwiftUI | GTK |
|-------------|-----------|-----|---------|-----|
| UI pattern | MVVM + XAML | MVVM + XAML | MVVM + declarative | MVC |
| Test runner | `dotnet test` | `dotnet test` | XCTest | language-specific |
| Package manager | NuGet | NuGet | SPM | system package manager |
| Build | `dotnet build` | `dotnet build` | `xcodebuild` | `meson` / `cmake` |
| Installer | MSIX / pkg | MSI / MSIX | pkg / DMG | deb / rpm / flatpak |
