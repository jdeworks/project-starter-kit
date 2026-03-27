# Game dev starter

Browser-native 2D and 3D games running in the browser.

**Example stack:** Phaser 3 (works with PixiJS, Three.js, Babylon.js — see [docs/stack-choice.md](docs/stack-choice.md))

## Get started

```bash
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) game-dev my-game
```

<details>
<summary>Manual setup</summary>

```bash
git clone --filter=blob:none --no-checkout --depth=1 -b dev \
  https://github.com/jdeworks/project-starter-kit.git /tmp/_psk
cd /tmp/_psk && git sparse-checkout init --cone
git sparse-checkout set base game-dev cli && git checkout dev
bash cli/compose.sh --variant game-dev --mode full --target ~/my-game --yes
rm -rf /tmp/_psk && cd ~/my-game
```

</details>

## What you get

```
my-game/
├── AGENTS.md
├── Makefile
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
