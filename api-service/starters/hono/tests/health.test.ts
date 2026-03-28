import { describe, expect, it } from "vitest";
import app from "../src/app.js";

describe("GET /health", () => {
  it("returns status ok", async () => {
    const res = await app.request("/health");
    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({ status: "ok" });
  });
});

describe("GET /hello/:name", () => {
  it("returns greeting with name", async () => {
    const res = await app.request("/hello/World");
    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({ message: "Hello, World!" });
  });
});
