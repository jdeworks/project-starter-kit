# API design

Guidelines for designing endpoints in this project.

## REST conventions

### URL structure
```
GET    /resources          → list
GET    /resources/:id      → get one
POST   /resources          → create
PATCH  /resources/:id      → partial update
DELETE /resources/:id      → delete
```

- Use plural nouns (`/users`, not `/user`)
- Nest only one level deep (`/users/:id/posts`, not `/users/:id/posts/:pid/comments`)
- Use query params for filtering, sorting, pagination: `?status=active&sort=-created_at&limit=20&offset=0`

### Status codes

| Code | When |
|------|------|
| 200 | Successful GET, PATCH, DELETE |
| 201 | Successful POST (resource created) |
| 204 | Successful DELETE with no body |
| 400 | Validation error, malformed request |
| 401 | Missing or invalid authentication |
| 403 | Authenticated but not authorized |
| 404 | Resource not found |
| 409 | Conflict (duplicate, version mismatch) |
| 422 | Request is well-formed but semantically invalid |
| 500 | Unexpected server error |

### Response shape

Successful responses return the resource directly:
```json
{ "id": "abc", "name": "Example", "created_at": "2026-01-01T00:00:00Z" }
```

List responses include pagination metadata:
```json
{ "data": [...], "total": 42, "limit": 20, "offset": 0 }
```

Error responses always use the standard shape:
```json
{ "error": "User not found", "code": "NOT_FOUND", "status": 404 }
```

## GraphQL

If using GraphQL instead of REST:
- One endpoint: `POST /graphql`
- Use code-first schema generation (e.g., Pothos, TypeGraphQL)
- Keep resolvers thin — same service layer as REST
- Limit query depth to prevent abuse (default: 5 levels)
- Use DataLoader for N+1 prevention

## Versioning

Prefer URL versioning (`/v1/resources`) only when breaking changes are unavoidable.
For most projects, evolve the API additively (add fields, don't remove them) and avoid
versioning altogether.
