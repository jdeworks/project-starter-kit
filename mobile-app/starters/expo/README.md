# My App — Expo + React Native

A React Native app built with Expo and expo-router.

## Prerequisites

- Node.js 18+
- Expo CLI (`npx expo`)

## Getting started

```bash
npm install
npm run dev
```

Scan the QR code with Expo Go (iOS/Android) or press `w` for web.

## Scripts

| Command              | Description                  |
| -------------------- | ---------------------------- |
| `npm run dev`        | Start Expo dev server        |
| `npm run build`      | Export production bundle     |
| `npm test`           | Run tests with Vitest        |
| `npm run format`     | Format code with Prettier    |
| `npm run lint`       | Lint with ESLint             |
| `npm run typecheck`  | Type-check with TypeScript   |

## Project structure

```
app/
  _layout.tsx    — Root layout with Stack navigator
  index.tsx      — Home screen with counter
src/
  counter.ts     — Pure counter logic
tests/
  counter.test.ts — Counter unit tests
```
