import { describe, it, expect } from "vitest";
import { wordCount } from "../src/tools/word-count.js";

describe("wordCount", () => {
  it("counts words in a simple sentence", () => {
    expect(wordCount("hello world")).toBe(2);
  });

  it("returns 0 for an empty string", () => {
    expect(wordCount("")).toBe(0);
  });

  it("returns 0 for whitespace-only string", () => {
    expect(wordCount("   ")).toBe(0);
  });

  it("handles multiple spaces between words", () => {
    expect(wordCount("one   two   three")).toBe(3);
  });

  it("counts a single word", () => {
    expect(wordCount("hello")).toBe(1);
  });

  it("handles tabs and newlines", () => {
    expect(wordCount("one\ttwo\nthree")).toBe(3);
  });
});
