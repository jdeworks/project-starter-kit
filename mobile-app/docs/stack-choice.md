# Stack choice — mobile frameworks

This project uses React Native + Expo as its primary example. This doc explains when
to choose a different framework instead.

## Choose React Native + Expo when

- Your team knows JavaScript or TypeScript
- You want to share code with a web app (Expo Router supports web)
- OTA updates (shipping JS changes without App Store review) matter to your release process
- You need the largest ecosystem of third-party libraries
- Hiring speed matters — RN devs significantly outnumber Flutter devs

## Choose Flutter when

- Your app requires heavy custom animations or pixel-perfect cross-platform UI
- You're targeting mobile, web, AND desktop from one codebase with visual consistency
- Your team is willing to invest in Dart (typically 2–4 weeks to productivity)
- Raw rendering performance is the primary metric (games, graphics-heavy apps)

## Choose native (Swift/Kotlin) when

- Deep system integration is required (CarPlay, watchOS, complex Bluetooth, ML on-device)
- Your app's primary value is in platform-specific UI/UX that cross-platform can't match
- You have dedicated iOS and Android engineers

## Choose a web-based wrapper (Capacitor, Ionic) when

- You already have a working web app and want it in the app stores quickly
- Native feel is not a priority
- Budget is very tight and the team is web-only

---

## Migrating this starter kit to Flutter

If you chose Flutter, the base layer still applies fully:
- AGENTS.md, CHANGES.md, SESSION_SUMMARY.md, hooks — all carry over
- Replace the test tier with Flutter's test framework (`flutter test`)
- Replace knip with Dart's `dart analyze` for dead code
- Replace Vitest architecture tests with equivalent Dart test patterns
- The Makefile targets map to `flutter build`, `flutter test`, `flutter analyze`

Document your Flutter-specific conventions in `docs/flutter-conventions.md` and reference
it from AGENTS.md's doc table.
