import { Hono } from "hono";
import { healthRoute } from "./routes/health.js";
import { helloRoute } from "./routes/hello.js";

const app = new Hono();

app.route("/", healthRoute);
app.route("/", helloRoute);

export default app;
