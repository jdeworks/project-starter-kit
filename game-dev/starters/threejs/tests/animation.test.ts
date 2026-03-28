import { describe, it, expect } from "vitest";
import {
  createRotation,
  applyRotation,
  normalizeAngle,
} from "../src/animation";

describe("createRotation", () => {
  it("starts at zero", () => {
    const rot = createRotation();
    expect(rot.x).toBe(0);
    expect(rot.y).toBe(0);
    expect(rot.z).toBe(0);
  });
});

describe("applyRotation", () => {
  it("adds delta to rotation", () => {
    const rot = createRotation();
    const next = applyRotation(rot, 0.1, 0.2);
    expect(next.x).toBeCloseTo(0.1);
    expect(next.y).toBeCloseTo(0.2);
    expect(next.z).toBe(0);
  });

  it("accumulates over multiple calls", () => {
    let rot = createRotation();
    rot = applyRotation(rot, 0.01, 0.01);
    rot = applyRotation(rot, 0.01, 0.01);
    expect(rot.x).toBeCloseTo(0.02);
    expect(rot.y).toBeCloseTo(0.02);
  });
});

describe("normalizeAngle", () => {
  it("keeps small angles unchanged", () => {
    expect(normalizeAngle(1)).toBeCloseTo(1);
  });

  it("wraps angles beyond PI", () => {
    const result = normalizeAngle(Math.PI + 0.5);
    expect(result).toBeCloseTo(-Math.PI + 0.5);
  });

  it("wraps negative angles beyond -PI", () => {
    const result = normalizeAngle(-Math.PI - 0.5);
    expect(result).toBeCloseTo(Math.PI - 0.5);
  });
});
