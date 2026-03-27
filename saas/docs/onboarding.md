# Onboarding

Signup flows, trials, and user activation for SaaS products.

## Signup flow

Keep it minimal — reduce friction:

1. **Email + password** (or social login) — one form, no multi-step wizard
2. **Email verification** — send a confirmation link
3. **Create tenant** — auto-create an organization for the user
4. **First-use experience** — guide them to their first meaningful action

## Free trials

- Offer 14-day trial (most common and effective length)
- No credit card required for trial start (higher conversion to trial)
- Show remaining trial days in the UI
- Send reminders at 7 days, 3 days, and 1 day before expiry
- Downgrade gracefully — don't delete data, restrict access

## Activation metrics

Track whether users reach their "aha moment" — the first action that delivers value:

| Product type | Example activation event |
|-------------|------------------------|
| Project management | Created first project and added a task |
| Analytics | Connected a data source |
| Communication | Sent first message |
| E-commerce | Listed first product |

## Onboarding checklist pattern

Show new users a checklist of 3–5 setup steps:

```
□ Complete your profile
□ Invite a team member
□ Create your first [thing]
□ Connect your [integration]
```

Dismiss the checklist once all steps are completed or the user explicitly closes it.

## Invitations

- Owner/admin can invite members by email
- Invitation link expires after 7 days
- Invited user joins the existing tenant (doesn't create a new one)
- Handle edge case: invited email already has an account on a different tenant
