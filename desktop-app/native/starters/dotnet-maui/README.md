# My App — .NET MAUI

A cross-platform native app built with .NET MAUI targeting Android, iOS, macOS, and Windows.

## Prerequisites

- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0) with MAUI workload

```bash
dotnet workload install maui
```

## Getting started

```bash
# Run on default platform
dotnet build
dotnet run

# Run on a specific platform
dotnet build -t:Run -f net8.0-android
dotnet build -t:Run -f net8.0-ios
dotnet build -t:Run -f net8.0-maccatalyst
dotnet build -t:Run -f net8.0-windows10.0.19041.0
```

## Running tests

```bash
cd Tests
dotnet test
```

## Project structure

```
MyApp.csproj              — MAUI project file
MauiProgram.cs            — App builder
App.xaml / App.xaml.cs    — Application entry
MainPage.xaml / .cs       — Main page with counter UI
ViewModels/
  MainViewModel.cs        — MVVM view model with counter logic
Platforms/
  Android/                — Android entry points
  iOS/                    — iOS entry points
  Windows/                — Windows entry points
Tests/
  Tests.csproj            — xUnit test project
  MainViewModelTests.cs   — View model unit tests
```
