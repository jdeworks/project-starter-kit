/** Pure rotation logic — no Three.js imports. */

export interface Rotation {
  x: number;
  y: number;
  z: number;
}

export function createRotation(): Rotation {
  return { x: 0, y: 0, z: 0 };
}

export function applyRotation(
  rotation: Rotation,
  dx: number,
  dy: number,
): Rotation {
  return {
    x: rotation.x + dx,
    y: rotation.y + dy,
    z: rotation.z,
  };
}

/** Normalize an angle to stay within [-PI, PI]. */
export function normalizeAngle(angle: number): number {
  const TWO_PI = Math.PI * 2;
  let result = angle % TWO_PI;
  if (result > Math.PI) result -= TWO_PI;
  if (result < -Math.PI) result += TWO_PI;
  return result;
}
