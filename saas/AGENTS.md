# AGENTS.md — saas variant

Extends base AGENTS.md. Read that first, then this file.

## This variant covers

SaaS products — web applications with user authentication, subscription billing, multi-tenancy,
and onboarding flows. The rules and docs below are **framework-agnostic**. They apply whether
you're using Next.js, Nuxt, SvelteKit, Rails, Laravel, or anything else. The example commands
use Next.js + Stripe as a concrete starting point — adapt them to your stack.

> **Using a different framework?** The patterns (auth via service, webhook-driven billing,
> tenant isolation) carry over. See `docs/stack-choice.md` for mapping guidance.
> If your stack isn't covered, please open a PR — see CONTRIBUTING.md.

---

## Quick start

Pick a starter when composing your project — each gives you a working hello-world:

- `nextjs` — Next.js with App Router, SSR, and API routes
- `sveltekit` — SvelteKit with server-side rendering and form actions

Then: `npm install && npm run dev`

See `docs/stack-choice.md` for a full comparison.

---

## Variant-specific docs — read on demand

| Doc | Read when |
|-----|-----------|
| `docs/auth-and-users.md` | Setting up authentication, user management, roles |
| `docs/billing.md` | Integrating subscription billing (Stripe, Lemon Squeezy, etc.) |
| `docs/multi-tenancy.md` | Isolating data per tenant/organization |
| `docs/onboarding.md` | Building signup flows, trials, activation |
| `docs/stack-choice.md` | Evaluating full-stack frameworks for SaaS |
| `docs/email.md` | Transactional email (welcome, invoice, password reset) |

---

## SaaS-specific rules (extend base rules)

1. **Auth via a service.** Don't build authentication from scratch. Use Clerk, Auth0, Supabase Auth, or your framework's auth module.
2. **Billing is webhook-driven.** Never trust client-side payment state. Stripe (or equivalent) webhooks are the source of truth for subscription status.
3. **Tenant isolation by default.** Every database query must be scoped to the current tenant. No query should ever return data from another tenant.
4. **Idempotent webhooks.** Webhook handlers must be idempotent — Stripe and other providers may deliver the same event multiple times.
5. **Audit trail for billing events.** Log every subscription change, payment, and access-level change. You will need this for support and compliance.

## LOC budget override

SaaS apps have more moving parts. Budget accordingly:
```
SOFT_FILE_LOC=250
HARD_FILE_LOC=350
LOC_BUDGET=20000
```

---

## Why Next.js + Stripe as the example

We need a concrete example to show patterns. We chose Next.js + Stripe because:
- Full-stack React framework with API routes, SSR, and middleware
- Stripe is the most widely used billing platform with excellent docs
- Large ecosystem of SaaS boilerplates and examples for reference
- Strong AI tooling support

**This is a recommendation, not a requirement.** The kit works with any SaaS stack.
See `docs/stack-choice.md` for when Rails, Laravel, or another framework is the better call.
