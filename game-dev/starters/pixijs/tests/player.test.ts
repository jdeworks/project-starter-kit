import { describe, it, expect } from "vitest";
import { createPlayer, updatePlayer } from "../src/entities/Player";

describe("createPlayer", () => {
  it("creates player at given position", () => {
    const player = createPlayer(400, 300, 50);
    expect(player.x).toBe(400);
    expect(player.y).toBe(300);
    expect(player.size).toBe(50);
  });
});

describe("updatePlayer", () => {
  it("moves player by velocity", () => {
    const player = createPlayer(400, 300, 50);
    const next = updatePlayer(player, 800, 600);
    expect(next.x).toBe(player.x + player.vx);
    expect(next.y).toBe(player.y + player.vy);
  });

  it("bounces off right wall", () => {
    const player = { x: 760, y: 100, vx: 5, vy: 0, size: 50 };
    const next = updatePlayer(player, 800, 600);
    expect(next.vx).toBe(-5);
  });

  it("bounces off bottom wall", () => {
    const player = { x: 100, y: 560, vx: 0, vy: 5, size: 50 };
    const next = updatePlayer(player, 800, 600);
    expect(next.vy).toBe(-5);
  });

  it("bounces off left wall", () => {
    const player = { x: -1, y: 100, vx: -5, vy: 0, size: 50 };
    const next = updatePlayer(player, 800, 600);
    expect(next.vx).toBe(5);
    expect(next.x).toBe(0);
  });
});
