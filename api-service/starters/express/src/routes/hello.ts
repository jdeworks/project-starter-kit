import { Router } from "express";

export const helloRouter = Router();

helloRouter.get("/hello/:name", (req, res) => {
  const { name } = req.params;
  res.json({ message: `Hello, ${name}!` });
});
