# Authentication and users

## Don't build auth from scratch

Use a service or your framework's built-in auth module:

| Service | Best for | Notes |
|---------|----------|-------|
| **Clerk** | React/Next.js apps | Full-featured: social login, MFA, org management |
| **Auth0** | Enterprise, multi-framework | Flexible, complex pricing |
| **Supabase Auth** | If already using Supabase | Simple, row-level security |
| **NextAuth / Auth.js** | Next.js, lightweight | Open source, bring your own database |
| **Devise** (Rails) | Rails apps | Mature, convention-based |
| **Sanctum** (Laravel) | Laravel apps | Token + session auth |

## User model essentials

At minimum, your user table needs:
- `id` — UUID or CUID (never auto-increment for public-facing IDs)
- `email` — unique, lowercase, validated
- `role` — enum: `owner`, `admin`, `member`, `viewer`
- `tenant_id` — foreign key to the organization/tenant
- `created_at`, `updated_at` — timestamps

## Roles and permissions

Start simple — don't over-engineer permissions:
1. **Owner** — can delete org, manage billing, invite admins
2. **Admin** — can manage members, change settings
3. **Member** — can use the product, create/edit own content
4. **Viewer** — read-only access

Add granular permissions only when a real use case demands it. RBAC covers 90% of SaaS needs.

## Session management

- Access token TTL: 15 minutes
- Refresh token TTL: 7–30 days
- Invalidate all sessions on password change
- Store refresh tokens in the database, not just JWTs

## Security checklist

- [ ] Passwords hashed with bcrypt or argon2
- [ ] Rate-limit login and signup endpoints
- [ ] Email verification required before accessing the product
- [ ] Password reset tokens expire after 1 hour
- [ ] MFA available for all users (at minimum TOTP)
