# Cross-platform desktop app starter

Desktop applications for Windows, macOS, and Linux.

**Example stack:** Tauri 2 (works with Electron, Wails — see [.kit/stack-choice.md](.kit/stack-choice.md))

## Get started

```bash
# Navigate to your project folder, then:
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) desktop-app/cross-platform
```

The CLI will prompt you to pick a starter. To skip the prompt:

```bash
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) desktop-app/cross-platform --starter tauri
```

**Available starters:** `tauri` (Tauri 2), `electron` (Electron)

<details>
<summary>Manual setup</summary>

```bash
git clone --filter=blob:none --no-checkout --depth=1 -b dev \
  https://github.com/jdeworks/project-starter-kit.git /tmp/_psk
cd /tmp/_psk && git sparse-checkout init --cone
git sparse-checkout set base desktop-app/cross-platform/AGENTS.md desktop-app/cross-platform/docs desktop-app/cross-platform/starters/tauri cli && git checkout dev
bash cli/compose.sh --variant desktop-app/cross-platform --starter tauri --target ~/my-desktop-app --yes
rm -rf /tmp/_psk && cd ~/my-desktop-app
```

</details>

## What you get

```
my-desktop-app/
├── AGENTS.md
├── Makefile
├── package.json           # From starter — dependencies pre-configured
├── src/                   # From starter — app frontend and scaffolding
├── tests/                 # From starter — test setup
├── .kit/
│   ├── ipc-and-commands.md   # Frontend-backend communication
│   ├── native-apis.md        # Filesystem, notifications, tray, clipboard
│   ├── packaging.md          # Installers for Windows, macOS, Linux
│   ├── auto-update.md        # Automatic update mechanisms
│   └── stack-choice.md       # Tauri vs Electron vs Wails vs Flutter
├── scripts/
└── .claude/
```

## Next step

> Read AGENTS.md and tell me what mode we're in and what commands are available.
