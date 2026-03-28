/** Pure bounce logic — no Babylon.js imports. */

export interface BounceState {
  y: number;
  vy: number;
}

export function createBounceState(startY: number): BounceState {
  return { y: startY, vy: 0 };
}

export function applyBounce(
  state: BounceState,
  gravity: number,
  floor: number,
  bounceFactor: number,
): BounceState {
  let { y, vy } = state;

  vy += gravity;
  y -= vy;

  if (y <= floor) {
    y = floor;
    vy = -vy * bounceFactor;
  }

  return { y, vy };
}

/** Compute kinetic energy (for testing conservation). */
export function kineticEnergy(vy: number, mass: number): number {
  return 0.5 * mass * vy * vy;
}
