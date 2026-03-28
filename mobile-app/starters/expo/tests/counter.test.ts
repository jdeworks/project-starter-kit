import { describe, it, expect } from "vitest";
import {
  createCounter,
  increment,
  decrement,
  reset,
  getCount,
} from "../src/counter";

describe("counter", () => {
  it("starts at zero by default", () => {
    const c = createCounter();
    expect(getCount(c)).toBe(0);
  });

  it("starts at a custom value", () => {
    const c = createCounter(10);
    expect(getCount(c)).toBe(10);
  });

  it("increments", () => {
    const c = increment(createCounter(5));
    expect(getCount(c)).toBe(6);
  });

  it("decrements", () => {
    const c = decrement(createCounter(5));
    expect(getCount(c)).toBe(4);
  });

  it("resets to zero", () => {
    const c = reset();
    expect(getCount(c)).toBe(0);
  });
});
