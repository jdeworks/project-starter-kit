import { describe, it, expect } from "vitest";
import { createGameState, update } from "../src/game";

describe("createGameState", () => {
  it("places sprite at center", () => {
    const state = createGameState(800, 600, 50);
    expect(state.x).toBe(400);
    expect(state.y).toBe(300);
    expect(state.size).toBe(50);
  });
});

describe("update", () => {
  it("moves sprite by velocity", () => {
    const state = createGameState(800, 600, 50);
    const next = update(state, 800, 600);
    expect(next.x).toBe(state.x + state.vx);
    expect(next.y).toBe(state.y + state.vy);
  });

  it("bounces off right wall", () => {
    const state = { x: 760, y: 100, vx: 5, vy: 0, size: 50 };
    const next = update(state, 800, 600);
    expect(next.vx).toBe(-5);
  });

  it("bounces off bottom wall", () => {
    const state = { x: 100, y: 560, vx: 0, vy: 5, size: 50 };
    const next = update(state, 800, 600);
    expect(next.vy).toBe(-5);
  });

  it("bounces off left wall", () => {
    const state = { x: -1, y: 100, vx: -5, vy: 0, size: 50 };
    const next = update(state, 800, 600);
    expect(next.vx).toBe(5);
    expect(next.x).toBe(0);
  });
});
