import { describe, it, expect } from "vitest";
import { nextColor, getColor, applyBounce } from "../src/game-logic";

describe("nextColor", () => {
  it("cycles to next color index", () => {
    expect(nextColor(0)).toBe(1);
    expect(nextColor(3)).toBe(4);
  });

  it("wraps around to 0", () => {
    expect(nextColor(4)).toBe(0);
  });
});

describe("getColor", () => {
  it("returns a number for valid index", () => {
    expect(typeof getColor(0)).toBe("number");
  });

  it("wraps for out-of-range index", () => {
    expect(getColor(5)).toBe(getColor(0));
  });
});

describe("applyBounce", () => {
  it("applies gravity to velocity", () => {
    const result = applyBounce({ y: 100, vy: 0 }, 1, 500, 0.8);
    expect(result.vy).toBe(1);
    expect(result.y).toBe(101);
  });

  it("bounces off the floor", () => {
    const result = applyBounce({ y: 499, vy: 10 }, 1, 500, 0.8);
    expect(result.y).toBe(500);
    expect(result.vy).toBeLessThan(0);
  });
});
