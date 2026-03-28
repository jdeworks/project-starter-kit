import { describe, it, expect } from "vitest";
import { increment, decrement } from "../src/counter";

describe("counter", () => {
  it("increments a value", () => {
    expect(increment(0)).toBe(1);
    expect(increment(4)).toBe(5);
    expect(increment(-1)).toBe(0);
  });

  it("decrements a value", () => {
    expect(decrement(1)).toBe(0);
    expect(decrement(0)).toBe(-1);
    expect(decrement(-4)).toBe(-5);
  });
});
