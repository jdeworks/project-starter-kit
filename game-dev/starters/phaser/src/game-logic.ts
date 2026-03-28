/** Pure game state logic — no Phaser imports. */

const COLORS = [0xe94560, 0x0f3460, 0x16213e, 0x53d8fb, 0xf5a623];

export function nextColor(currentIndex: number): number {
  return (currentIndex + 1) % COLORS.length;
}

export function getColor(index: number): number {
  return COLORS[index % COLORS.length];
}

export interface BounceState {
  y: number;
  vy: number;
}

export function applyBounce(
  state: BounceState,
  gravity: number,
  floor: number,
  bounceFactor: number,
): BounceState {
  let { y, vy } = state;
  vy += gravity;
  y += vy;

  if (y >= floor) {
    y = floor;
    vy = -vy * bounceFactor;
  }

  return { y, vy };
}
