import express from "express";
import { healthRouter } from "./routes/health.js";
import { helloRouter } from "./routes/hello.js";

export const app = express();

app.use(healthRouter);
app.use(helloRouter);

const port = process.env.PORT || 3000;

if (process.env.NODE_ENV !== "test") {
  app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
  });
}
