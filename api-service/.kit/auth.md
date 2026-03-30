# Authentication & authorization

Guidelines for adding auth to this API.

## Authentication approaches

| Approach | When to use |
|----------|-------------|
| **JWT (stateless)** | SPAs, mobile apps, microservices. Short-lived access token + refresh token. |
| **Session cookies** | Server-rendered apps, when you control the client. HttpOnly, Secure, SameSite=Strict. |
| **API keys** | Machine-to-machine, webhooks, third-party integrations. Hash before storing. |
| **OAuth 2.0 / OIDC** | Social login, enterprise SSO. Use a library (e.g., arctic, oslo). |

## JWT implementation

- Access token TTL: 15 minutes
- Refresh token TTL: 7–30 days, stored in database, rotated on use
- Sign with RS256 (asymmetric) for microservices, HS256 (symmetric) for monoliths
- Never store sensitive data in the JWT payload — it's base64, not encrypted
- Validate `iss`, `aud`, `exp` on every request

## Authorization patterns

- **RBAC (Role-Based):** Assign roles (`admin`, `member`, `viewer`), check in middleware
- **ABAC (Attribute-Based):** Check resource ownership (`user.id === resource.owner_id`)
- Keep authorization checks in middleware or service layer, never in route handlers

## Security checklist

- [ ] Passwords hashed with bcrypt or argon2 (never MD5/SHA)
- [ ] Rate-limit login and token refresh endpoints
- [ ] Invalidate all refresh tokens on password change
- [ ] CORS configured to allow only known origins
- [ ] Helmet middleware (or equivalent) for security headers
- [ ] No secrets in environment variables committed to git
