# AGENTS.md — game-dev variant

Extends base AGENTS.md. Read that first, then this file.

## This variant covers

Browser-native game development — 2D and simple 3D games running in the browser with
JavaScript/TypeScript. The rules and docs below are **engine-agnostic**. They apply whether
you're using Phaser, PixiJS, Three.js, Babylon.js, or raw Canvas/WebGL. The example commands
use Phaser as a concrete starting point — adapt them to your engine.

> **Using a different engine?** The patterns (game loop, asset management, scene organization,
> testing) carry over. See `docs/stack-choice.md` for mapping guidance.
> Using Godot, Unity, or Unreal? Those are native engines — this variant focuses on browser
> games. PRs for native engine guidance are welcome — see CONTRIBUTING.md.

---

## Quick start

Pick a starter when composing your project — each gives you a working hello-world:

- `pixijs` — PixiJS lightweight 2D WebGL renderer
- `phaser` — Phaser 3 full 2D game framework with physics, input, audio, tilemaps
- `threejs` — Three.js 3D rendering library
- `babylonjs` — Babylon.js batteries-included 3D engine with physics, GUI, WebXR

Then: `npm install && npm run dev`

See `docs/stack-choice.md` for a full comparison.

---

## Variant-specific docs — read on demand

| Doc | Read when |
|-----|-----------|
| `docs/game-architecture.md` | Structuring game code — scenes, entities, systems |
| `docs/asset-management.md` | Loading, organizing, and optimizing game assets |
| `docs/game-loop.md` | Understanding and implementing the update/render cycle |
| `docs/testing-games.md` | Testing game logic (not rendering) |
| `docs/stack-choice.md` | Choosing between Phaser, PixiJS, Three.js, or other engines |

---

## Game-specific rules (extend base rules)

1. **Separate game logic from rendering.** Game state, physics, and rules should be testable without a canvas. Keep rendering in display/view layers only.
2. **Fixed timestep for game logic.** Use `deltaTime`-based updates, not frame-count-based. Game behavior must be consistent regardless of frame rate.
3. **Assets are not code.** Images, audio, and data files go in `public/assets/`, loaded asynchronously. Never import large binary files into JS bundles.
4. **Scene-based organization.** Each distinct game screen (menu, gameplay, pause, game-over) is its own scene/state.
5. **Performance budget.** Target 60 FPS on mid-range hardware. Profile regularly — don't optimize blindly.

## LOC budget override

Game code tends to grow. Budget accordingly:
```
SOFT_FILE_LOC=300
HARD_FILE_LOC=400
LOC_BUDGET=15000
```

---

## Why Phaser as the example

We need a concrete example to show patterns. We chose Phaser because:
- Most popular browser game framework with the largest community
- Built-in physics, input, audio, animations, tilemaps
- Excellent documentation and tutorials
- TypeScript support

**This is a recommendation, not a requirement.** PixiJS is better for pure rendering without
game framework overhead. Three.js/Babylon.js are better for 3D.
See `docs/stack-choice.md` for guidance.
