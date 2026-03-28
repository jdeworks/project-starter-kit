import { describe, it, expect } from "vitest";
import { appConfig } from "../src/lib/config";

describe("appConfig", () => {
  it("has a name", () => {
    expect(appConfig.name).toBeTruthy();
    expect(typeof appConfig.name).toBe("string");
  });

  it("has a description", () => {
    expect(appConfig.description).toBeTruthy();
    expect(typeof appConfig.description).toBe("string");
  });

  it("has a version", () => {
    expect(appConfig.version).toBeTruthy();
    expect(appConfig.version).toMatch(/^\d+\.\d+\.\d+$/);
  });
});
