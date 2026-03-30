# Native desktop app starter

Native desktop applications using platform-native UI frameworks.

**Example stack:** C# / .NET MAUI (works with WPF, SwiftUI, GTK — see [.kit/stack-choice.md](.kit/stack-choice.md))

## Get started

```bash
# Navigate to your project folder, then:
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) desktop-app/native
```

The CLI will prompt you to pick a starter. To skip the prompt:

```bash
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) desktop-app/native --starter dotnet-maui
```

**Available starters:** `dotnet-maui` (.NET MAUI)

<details>
<summary>Manual setup</summary>

```bash
git clone --filter=blob:none --no-checkout --depth=1 -b dev \
  https://github.com/jdeworks/project-starter-kit.git /tmp/_psk
cd /tmp/_psk && git sparse-checkout init --cone
git sparse-checkout set base desktop-app/native/AGENTS.md desktop-app/native/docs desktop-app/native/starters/dotnet-maui cli && git checkout dev
bash cli/compose.sh --variant desktop-app/native --starter dotnet-maui --target ~/my-native-app --yes
rm -rf /tmp/_psk && cd ~/my-native-app
```

</details>

## What you get

```
my-native-app/
├── AGENTS.md
├── Makefile
├── src/                     # From starter — app entry point and views
├── tests/                   # From starter — test setup
├── .kit/
│   ├── mvvm-pattern.md        # Model-View-ViewModel structure
│   ├── platform-apis.md       # Native features, platform-conditional code
│   ├── packaging-native.md    # Installers, code signing, store distribution
│   └── stack-choice.md        # .NET MAUI vs WPF vs SwiftUI vs GTK
├── scripts/
└── .claude/
```

## Next step

> Read AGENTS.md and tell me what mode we're in and what commands are available.
