# Stack choice — SaaS frameworks

This variant uses Next.js + Stripe as its primary example. This doc explains when
to choose a different stack.

## Choose Next.js when

- Your team knows React and wants full-stack capabilities
- You need SSR for SEO-critical pages (marketing, pricing)
- You want API routes alongside your frontend
- Vercel deployment is appealing (zero-config)

## Choose Nuxt when

- Your team prefers Vue over React
- You want auto-imports, built-in state management, and a gentler learning curve
- Same SSR/SSG capabilities as Next.js

## Choose Rails when

- Speed of development is the priority — Rails has mature solutions for auth, billing, email, jobs
- Your team knows Ruby
- Convention-over-configuration appeals to you
- You want built-in generators for models, controllers, migrations

## Choose Laravel when

- Your team knows PHP
- Cashier (Stripe integration), Sanctum (auth), and Horizon (queues) cover your needs out of the box
- You want Forge or Vapor for deployment

## Choose SvelteKit when

- Performance is critical and you want minimal client-side JS
- Your team is comfortable with a smaller ecosystem
- You prefer Svelte's reactive syntax

## Billing providers

| Provider | Best for | Notes |
|----------|----------|-------|
| **Stripe** | Most SaaS products | Best docs, largest ecosystem, global |
| **Lemon Squeezy** | Indie/solo projects | Simpler API, handles tax/VAT as merchant of record |
| **Paddle** | EU-focused SaaS | Merchant of record, handles VAT |

## Mapping kit patterns to your stack

| Kit concept | Next.js | Rails | Laravel | Nuxt |
|-------------|---------|-------|---------|------|
| Dev server | `next dev` | `rails server` | `php artisan serve` | `nuxt dev` |
| Test runner | Vitest/Jest | Minitest/RSpec | PHPUnit/Pest | Vitest |
| Migrations | Drizzle/Prisma | `rails db:migrate` | `php artisan migrate` | Drizzle/Prisma |
| Auth | Clerk/NextAuth | Devise | Sanctum/Breeze | Clerk/Sidebase |
| Billing | Stripe SDK | Pay gem | Cashier | Stripe SDK |
