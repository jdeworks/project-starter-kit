# Game dev starter

Browser-native 2D and 3D games running in the browser.

**Example stack:** Phaser 3 (works with PixiJS, Three.js, Babylon.js — see [docs/stack-choice.md](docs/stack-choice.md))

## Get started

```bash
# Navigate to your project folder, then:
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) game-dev
```

The CLI will prompt you to pick a starter. To skip the prompt:

```bash
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) game-dev --starter pixijs
```

**Available starters:** `pixijs` (PixiJS), `phaser` (Phaser 3), `threejs` (Three.js), `babylonjs` (Babylon.js)

<details>
<summary>Manual setup</summary>

```bash
git clone --filter=blob:none --no-checkout --depth=1 -b dev \
  https://github.com/jdeworks/project-starter-kit.git /tmp/_psk
cd /tmp/_psk && git sparse-checkout init --cone
git sparse-checkout set base game-dev/AGENTS.md game-dev/docs game-dev/starters/pixijs cli && git checkout dev
bash cli/compose.sh --variant game-dev --starter pixijs --target ~/my-game --yes
rm -rf /tmp/_psk && cd ~/my-game
```

</details>

## What you get

```
my-game/
├── AGENTS.md
├── Makefile
├── package.json           # From starter — dependencies pre-configured
├── src/                   # From starter — game entry point and scaffolding
├── tests/                 # From starter — test setup
├── docs/
│   ├── game-architecture.md   # Scenes, entities, systems, ECS
│   ├── asset-management.md    # Loading, organizing, optimizing assets
│   ├── game-loop.md           # Update/render cycle, delta time, fixed timestep
│   ├── testing-games.md       # Testing logic without a canvas
│   └── stack-choice.md        # Phaser vs PixiJS vs Three.js vs Babylon.js
├── scripts/
└── .claude/
```

## Next step

> Read AGENTS.md and tell me what mode we're in and what commands are available.
