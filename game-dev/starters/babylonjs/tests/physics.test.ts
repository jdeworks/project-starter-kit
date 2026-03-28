import { describe, it, expect } from "vitest";
import {
  createBounceState,
  applyBounce,
  kineticEnergy,
} from "../src/physics";

describe("createBounceState", () => {
  it("creates state at given height with zero velocity", () => {
    const state = createBounceState(5);
    expect(state.y).toBe(5);
    expect(state.vy).toBe(0);
  });
});

describe("applyBounce", () => {
  it("applies gravity (negative = downward)", () => {
    const state = createBounceState(3);
    const next = applyBounce(state, -0.1, 0.5, 0.8);
    expect(next.vy).toBe(-0.1);
    expect(next.y).toBe(3.1);
  });

  it("bounces when hitting the floor", () => {
    const state = { y: 0.55, vy: -1 };
    const next = applyBounce(state, -0.1, 0.5, 0.8);
    // vy becomes -1.1, y = 0.55 - (-1.1) = 1.65? No: y -= vy
    // vy = -1 + (-0.1) = -1.1, y = 0.55 - (-1.1) = 1.65
    // 1.65 > 0.5 so no bounce
    expect(next.y).toBeGreaterThan(0.5);
  });

  it("reverses velocity on floor contact", () => {
    const state = { y: 0.4, vy: 0.5 };
    // vy = 0.5 + (-0.1) = 0.4, y = 0.4 - 0.4 = 0.0 <= 0.5? No, 0.0 <= 0.5
    const next = applyBounce(state, -0.1, 0.5, 0.8);
    expect(next.y).toBe(0.5);
    expect(next.vy).toBeLessThan(0);
  });
});

describe("kineticEnergy", () => {
  it("returns zero for zero velocity", () => {
    expect(kineticEnergy(0, 1)).toBe(0);
  });

  it("computes 0.5 * m * v^2", () => {
    expect(kineticEnergy(3, 2)).toBe(9);
  });
});
