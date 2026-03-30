# Game architecture

Structuring game code for maintainability.

## Scene-based organization

Every distinct game screen is its own scene:

```
src/
  scenes/
    Boot.ts           # Load minimal assets, show loading screen
    Preloader.ts      # Load all game assets
    MainMenu.ts       # Title screen, settings
    GamePlay.ts       # Main game loop
    GameOver.ts       # Score display, retry
  entities/
    Player.ts         # Player logic and state
    Enemy.ts          # Enemy behavior
    Projectile.ts     # Bullets, arrows, etc.
  systems/
    Physics.ts        # Collision detection, movement
    Scoring.ts        # Score tracking, combos
    Audio.ts          # Sound effect management
  config/
    constants.ts      # Game constants (speed, sizes, tuning)
    assets.ts         # Asset keys and paths
  main.ts             # Game initialization
```

## Separate logic from rendering

Game logic (state, rules, physics) should be testable without a canvas:

```typescript
// GOOD — pure logic, testable
class Player {
  health = 100
  takeDamage(amount: number) {
    this.health = Math.max(0, this.health - amount)
    return this.health <= 0  // returns true if dead
  }
}

// Rendering is separate
class PlayerSprite {
  constructor(scene: Phaser.Scene, private player: Player) {
    // Create sprite, animations, etc.
  }
  update() {
    // Sync sprite position/state with player logic
  }
}
```

## Entity-Component-System (ECS)

For complex games, consider ECS:
- **Entity** — a unique ID (the "thing")
- **Component** — data attached to an entity (Position, Health, Renderable)
- **System** — logic that operates on entities with specific components

ECS scales better than deep inheritance hierarchies. Libraries: bitECS, miniplex.

## State management

- Keep game state in a central store or on entities — not scattered in UI code
- Save/load game state by serializing the state object
- Use events/signals for communication between systems, not direct references

## Constants file ordering

If constants reference other constants (e.g. `SPAWN_CHANCE = DEBUG_MODE ? 0.5 : 0.08`),
declaration order matters. Put debug flags and base values at the very top, derived values below.

## Anti-exploit design for scoring

Any idle or repetitive action that awards points will be exploited. Design countermeasures:
- Stagnation timer — penalize staying in one area (crumble platforms, disable bonuses)
- Diminishing returns — repeated actions in the same zone yield less
- Height/progress gates — only award meaningful score for forward progress

## Canvas UI hit detection

DOM event listeners and framework `stopPropagation` don't reliably prevent canvas clicks
from reaching game logic. Use coordinate-based hit detection instead:
- Check if click coordinates fall within UI element bounds
- Process UI hits first, skip game input if a UI element was hit
- For toggle text (e.g. "SFX: ON"), use separate text objects for label and value
  so only the value portion changes style

## Particle and effect systems

Without hard limits, particle systems accumulate and tank FPS. Always enforce:
- Maximum particle count (pool with fixed size)
- Maximum effect duration (force-kill after timeout)
- Immediate cleanup on particle death (return to pool, don't just hide)

## Audio: Web Audio API is sufficient

For casual game SFX, the Web Audio API with procedural oscillator-based sounds is
lightweight and zero-dependency. No need for Howler.js or @pixi/sound. Pattern:
- Lazy `AudioContext` creation on first user gesture
- Oscillator + gain envelope per sound effect
- Keep a small library of generator functions (jump, collect, hit, explosion)

## Countdown and transitions

Starting a game with a black screen + countdown, then suddenly showing everything
feels jarring. Instead: render the full scene (frozen) during countdown. Call `render()`
during countdown ticks but skip `update()` logic. The player sees the world they're
about to play in.
