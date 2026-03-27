# Billing

Subscription billing integration for SaaS products.

## Core principle: webhooks are the source of truth

Never trust client-side payment state. Your billing flow:

1. User clicks "Subscribe" → redirect to Stripe Checkout (or embedded form)
2. Stripe processes payment → sends webhook to your server
3. Your webhook handler updates the user's subscription status in your database
4. Your app reads subscription status from your database, not from Stripe on every request

## Stripe integration (example)

### Checkout session

```javascript
const session = await stripe.checkout.sessions.create({
  customer: customerId,
  line_items: [{ price: priceId, quantity: 1 }],
  mode: 'subscription',
  success_url: `${baseUrl}/dashboard?session_id={CHECKOUT_SESSION_ID}`,
  cancel_url: `${baseUrl}/pricing`,
})
```

### Webhook handler

```javascript
// Verify webhook signature — never skip this
const event = stripe.webhooks.constructEvent(body, sig, webhookSecret)

switch (event.type) {
  case 'checkout.session.completed':
    // Activate subscription
    break
  case 'invoice.paid':
    // Record payment, extend access
    break
  case 'customer.subscription.deleted':
    // Revoke access
    break
}
```

### Key events to handle

| Event | Action |
|-------|--------|
| `checkout.session.completed` | Create subscription record, grant access |
| `invoice.paid` | Record payment, update billing period |
| `invoice.payment_failed` | Notify user, start grace period |
| `customer.subscription.updated` | Handle plan changes (upgrade/downgrade) |
| `customer.subscription.deleted` | Revoke access after grace period |

## Idempotency

Webhooks may be delivered more than once. Your handlers must be idempotent:
- Check if you've already processed this event (store event IDs)
- Use database transactions to prevent double-processing
- Design state transitions that are safe to repeat

## Pricing page

Keep your pricing simple:
- 2–3 tiers maximum
- Clearly show what each tier includes
- Annual billing option (discount vs monthly)
- Free trial with no credit card required (if possible)

## Testing billing

- Use Stripe test mode (keys starting with `sk_test_`)
- Test cards: `4242424242424242` (success), `4000000000000002` (decline)
- Use Stripe CLI to forward webhooks locally: `stripe listen --forward-to localhost:3000/api/webhooks`
- Test every webhook event type you handle
