# Database

Guidelines for database setup, migrations, and data access.

## ORM recommendation

**Drizzle ORM** (TypeScript): type-safe, SQL-like syntax, lightweight, supports Postgres/MySQL/SQLite.

Alternatives:
- **Prisma** — heavier, generates client from schema file, strong for rapid prototyping
- **Kysely** — query builder only (no migrations), maximum type safety
- **Raw SQL** — acceptable for simple projects or when ORM overhead isn't justified

## Migrations

1. Generate a migration: `npx drizzle-kit generate`
2. Apply migrations: `npx drizzle-kit migrate`
3. **Never edit an existing migration.** Create a new one.
4. Name migrations descriptively: `0003_add-user-email-index.sql`
5. Every migration must be reversible in development. In production, forward-only.

## Schema conventions

- Primary keys: use `uuid` or `cuid2`, not auto-increment integers (avoids enumeration attacks)
- Timestamps: `created_at` and `updated_at` on every table, stored as UTC
- Soft deletes: add `deleted_at` column instead of `DELETE` when audit trail matters
- Indexes: add indexes for every column used in `WHERE` or `ORDER BY` clauses

## Connection management

- Use a connection pool (default: pool size = 10 for development, tune for production)
- Close connections on process exit — handle `SIGTERM` and `SIGINT`
- For serverless: use connection pooling services (Neon, PlanetScale, Supabase pooler)

## Testing

- Feature tests hit a real database (SQLite in-memory or test container)
- Seed data goes in `tests/fixtures/`, not hardcoded in tests
- Each test suite gets a clean database — use transactions that roll back
