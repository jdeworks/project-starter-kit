import { describe, it, expect } from "vitest";
import { greet, formatDate } from "../src/index.js";

describe("greet", () => {
  it("returns a greeting with the given name", () => {
    expect(greet("World")).toBe("Hello, World!");
  });

  it("handles empty string", () => {
    expect(greet("")).toBe("Hello, !");
  });
});

describe("formatDate", () => {
  it("formats a date as YYYY-MM-DD", () => {
    const date = new Date(2025, 0, 15); // Jan 15, 2025
    expect(formatDate(date)).toBe("2025-01-15");
  });

  it("pads single-digit month and day", () => {
    const date = new Date(2025, 2, 5); // Mar 5, 2025
    expect(formatDate(date)).toBe("2025-03-05");
  });
});
