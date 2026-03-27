# AGENTS.md — mobile-app variant

Extends base AGENTS.md. Read that first, then this file.

## This variant covers

Mobile app development targeting iOS and Android from a single codebase.
The rules and docs below are **framework-agnostic** where possible. The example commands use
React Native + Expo as a concrete starting point — adapt them to your stack.

> **Using Flutter, .NET MAUI, or another framework?** The patterns (test both platforms,
> handle offline, async-first) carry over. See `docs/stack-choice.md` for mapping guidance.
> If your stack isn't covered, please open a PR — see CONTRIBUTING.md.

---

## Quick start (React Native + Expo)

```bash
npx create-expo-app@latest my-app --template blank-typescript
cd my-app
npm install
npx expo start
```

For EAS (cloud builds, OTA updates — no Xcode/Android Studio required locally):
```bash
npm install -g eas-cli
eas login
eas build:configure
```

---

## Variant-specific docs — read on demand

| Doc | Read when |
|-----|-----------|
| `docs/rn-expo-setup.md` | Starting a new RN+Expo project or configuring EAS |
| `docs/mobile-testing.md` | Writing tests for mobile code |
| `docs/navigation.md` | Setting up Expo Router or React Navigation |
| `docs/offline-and-storage.md` | Implementing offline support, local storage |
| `docs/push-notifications.md` | Adding push notification support |
| `docs/stack-choice.md` | Evaluating RN vs Flutter vs other frameworks |
| `docs/ota-updates.md` | Over-the-air update strategy with EAS Update |

---

## Mobile-specific rules (extend base rules)

1. **Test on both platforms.** iOS and Android behave differently. Simulator/emulator counts.
2. **No hardcoded dimensions.** Use `Dimensions`, `useWindowDimensions`, or `%` units.
3. **Async everything.** Mobile storage, permissions, and network are always async — no sync fallbacks.
4. **Handle offline.** Assume network is unreliable. Cache aggressively, fail gracefully.
5. **EAS for builds.** Don't require contributors to have Xcode or Android Studio. Use EAS Build.

## LOC budget override

Mobile components tend to be larger than web components. Adjust in `scripts/health-check.sh`:
```
SOFT_FILE_LOC=300
HARD_FILE_LOC=400
LOC_BUDGET=20000
```

---

## Why React Native + Expo as the example

We need a concrete example to show patterns. We chose RN + Expo because:
- JS/TS ecosystem — same toolchain as the rest of this starter kit
- Expo is the officially recommended way to start RN projects as of 2026
- EAS removes the need for native build environments
- Best AI tooling support (Claude Code, Cursor, Copilot all have strong RN training data)

**This is a recommendation, not a requirement.** The kit works with any mobile framework.
See `docs/stack-choice.md` for when Flutter or another framework is the better call, and how
to map the kit patterns to your chosen stack.
