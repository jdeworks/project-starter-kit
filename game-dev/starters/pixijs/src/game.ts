/** Pure game state logic — no PixiJS imports. */

export interface GameState {
  x: number;
  y: number;
  vx: number;
  vy: number;
  size: number;
}

export function createGameState(
  width: number,
  height: number,
  size: number = 50,
): GameState {
  return {
    x: width / 2,
    y: height / 2,
    vx: 3,
    vy: 2,
    size,
  };
}

export function update(
  state: GameState,
  boundsWidth: number,
  boundsHeight: number,
): GameState {
  let { x, y, vx, vy } = state;
  const { size } = state;

  x += vx;
  y += vy;

  if (x + size > boundsWidth || x < 0) {
    vx = -vx;
    x = Math.max(0, Math.min(x, boundsWidth - size));
  }

  if (y + size > boundsHeight || y < 0) {
    vy = -vy;
    y = Math.max(0, Math.min(y, boundsHeight - size));
  }

  return { x, y, vx, vy, size };
}
