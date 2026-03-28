# Mobile app starter

iOS + Android apps from a single codebase.

**Example stack:** React Native + Expo (works with Flutter, .NET MAUI — see [docs/stack-choice.md](docs/stack-choice.md))

## Get started

```bash
# Navigate to your project folder, then:
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) mobile-app
```

The CLI will prompt you to pick a starter. To skip the prompt:

```bash
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) mobile-app --starter expo
```

**Available starters:** `expo` (React Native + Expo)

<details>
<summary>Manual setup</summary>

```bash
git clone --filter=blob:none --no-checkout --depth=1 -b dev \
  https://github.com/jdeworks/project-starter-kit.git /tmp/_psk
cd /tmp/_psk && git sparse-checkout init --cone
git sparse-checkout set base mobile-app/AGENTS.md mobile-app/docs mobile-app/starters/expo cli && git checkout dev
bash cli/compose.sh --variant mobile-app --starter expo --target ~/my-app --yes
rm -rf /tmp/_psk && cd ~/my-app
```

</details>

## What you get

```
my-app/
├── AGENTS.md
├── Makefile
├── package.json               # From starter — dependencies pre-configured
├── src/                       # From starter — app entry point and screens
├── tests/                     # From starter — test setup
├── docs/
│   ├── rn-expo-setup.md          # Project setup, EAS, TypeScript
│   ├── mobile-testing.md         # Unit, component, integration, E2E
│   ├── navigation.md             # Expo Router, React Navigation, deep links
│   ├── offline-and-storage.md    # AsyncStorage, SecureStore, offline patterns
│   ├── push-notifications.md     # Expo Notifications setup
│   ├── ota-updates.md            # EAS Update, branches, channels
│   └── stack-choice.md           # React Native vs Flutter vs .NET MAUI
├── scripts/
└── .claude/
```

## Next step

> Read AGENTS.md and tell me what mode we're in and what commands are available.
