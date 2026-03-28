import http from "node:http";
import { greet, formatDate } from "@repo/shared";

const PORT = Number(process.env.PORT) || 4000;

const server = http.createServer((_req, res) => {
  const body = JSON.stringify({
    message: greet("API"),
    date: formatDate(new Date()),
  });

  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(body);
});

server.listen(PORT, () => {
  process.stdout.write(`API server listening on http://localhost:${PORT}\n`);
});
