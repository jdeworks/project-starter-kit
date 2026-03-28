import { Hono } from "hono";

export const helloRoute = new Hono();

helloRoute.get("/hello/:name", (c) => {
  const name = c.req.param("name");
  return c.json({ message: `Hello, ${name}!` });
});
