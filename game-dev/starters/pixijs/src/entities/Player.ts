/** Pure game logic — no PixiJS imports. */

export interface PlayerState {
  x: number;
  y: number;
  vx: number;
  vy: number;
  size: number;
}

export function createPlayer(
  x: number,
  y: number,
  size: number,
): PlayerState {
  return { x, y, vx: 3, vy: 2, size };
}

export function updatePlayer(
  player: PlayerState,
  boundsWidth: number,
  boundsHeight: number,
): PlayerState {
  let { x, y, vx, vy } = player;
  const { size } = player;

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
