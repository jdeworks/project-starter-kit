# React Native + Expo setup

Getting started with React Native using Expo.

## New project

```bash
npx create-expo-app@latest my-app --template blank-typescript
cd my-app
npm install
npx expo start
```

Scan the QR code with Expo Go (iOS/Android) or press `i`/`a` for simulator/emulator.

## EAS (Expo Application Services)

EAS provides cloud builds, OTA updates, and app store submissions — no Xcode or Android Studio required locally.

```bash
npm install -g eas-cli
eas login
eas build:configure
```

### Build profiles

Configure in `eas.json`:
```json
{
  "build": {
    "development": { "developmentClient": true, "distribution": "internal" },
    "preview": { "distribution": "internal" },
    "production": {}
  }
}
```

### Build commands

```bash
eas build --platform ios --profile development
eas build --platform android --profile preview
eas build --platform all --profile production
```

## Key dependencies

```bash
npm install expo-router          # File-based routing
npm install expo-secure-store    # Encrypted key-value storage
npm install @react-native-async-storage/async-storage  # Unencrypted storage
npm install expo-notifications   # Push notifications
```

## TypeScript

Expo templates come with TypeScript pre-configured. Use strict mode in `tsconfig.json`:
```json
{
  "extends": "expo/tsconfig.base",
  "compilerOptions": { "strict": true }
}
```

## Other frameworks

If using Flutter, .NET MAUI, or another framework, see `.kit/stack-choice.md` for setup guidance.
