import { describe, it, expect } from "vitest";
import { greet } from "../src/greet";

describe("greet", () => {
  it("greets a named person", () => {
    expect(greet("Alice")).toBe("Hello, Alice!");
  });

  it("trims whitespace from the name", () => {
    expect(greet("  Bob  ")).toBe("Hello, Bob!");
  });

  it("returns a default greeting for empty input", () => {
    expect(greet("")).toBe("Hello, stranger!");
  });

  it("returns a default greeting for whitespace-only input", () => {
    expect(greet("   ")).toBe("Hello, stranger!");
  });
});
