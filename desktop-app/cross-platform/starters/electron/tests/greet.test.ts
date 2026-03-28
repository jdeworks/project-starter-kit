import { describe, it, expect } from "vitest";
import { greet } from "../src/shared/greet";

describe("greet", () => {
  it("greets a named person", () => {
    expect(greet("Alice")).toBe("Hello, Alice!");
  });

  it("trims whitespace", () => {
    expect(greet("  Bob  ")).toBe("Hello, Bob!");
  });

  it("returns default greeting for empty string", () => {
    expect(greet("")).toBe("Hello, stranger!");
  });

  it("returns default greeting for whitespace-only string", () => {
    expect(greet("   ")).toBe("Hello, stranger!");
  });
});
