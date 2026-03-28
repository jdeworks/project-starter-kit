import { describe, expect, it } from "vitest";
import request from "supertest";
import { app } from "../src/index.js";

describe("GET /health", () => {
  it("returns status ok", async () => {
    const res = await request(app).get("/health");
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: "ok" });
  });
});

describe("GET /hello/:name", () => {
  it("returns greeting with name", async () => {
    const res = await request(app).get("/hello/World");
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ message: "Hello, World!" });
  });
});
