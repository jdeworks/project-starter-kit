# Deployment

Guidelines for deploying this API to production.

## Deployment targets

| Target | Best for | Notes |
|--------|----------|-------|
| **Containers (Docker)** | Any cloud, full control | Recommended default |
| **Serverless (Lambda, CF Workers)** | Low-traffic APIs, edge | Cold starts, connection limits |
| **PaaS (Railway, Render, Fly.io)** | Fast deployment, small teams | Less control, higher per-unit cost |
| **VPS (bare metal)** | Maximum control, fixed cost | You manage everything |

## Docker setup

```dockerfile
FROM node:22-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:22-slim
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY package*.json ./
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

- Multi-stage build to keep image small
- Use `node:*-slim`, not `node:*-alpine` (better compatibility, similar size)
- Pin major Node version, not `latest`
- Run as non-root user in production

## Environment variables

- Use `.env.example` as the template (committed to git)
- Never commit `.env` (already in .gitignore)
- Required vars: `DATABASE_URL`, `PORT`, `NODE_ENV`
- Validate all env vars at startup — fail fast if any are missing

## Health checks

Expose `GET /health` returning:
```json
{ "status": "ok", "uptime": 12345, "version": "1.0.0" }
```

Add a deep health check at `GET /health/ready` that verifies database connectivity.

## CI/CD

Minimum pipeline:
1. `make check` — lint, types, tests, health
2. `docker build` — verify the image builds
3. Deploy to staging
4. Run smoke tests against staging
5. Deploy to production
