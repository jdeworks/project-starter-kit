import { describe, it, expect } from "vitest";
import { greetMessage } from "../src/commands/greet.js";

describe("greetMessage", () => {
  it("returns a greeting with the given name", () => {
    expect(greetMessage("Alice")).toBe("Hello, Alice!");
  });

  it("handles names with spaces", () => {
    expect(greetMessage("Bob Smith")).toBe("Hello, Bob Smith!");
  });

  it("handles empty string", () => {
    expect(greetMessage("")).toBe("Hello, !");
  });
});
