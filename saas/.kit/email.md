# Transactional email

Email integration for SaaS products — welcome emails, invoices, password resets.

## Email providers

| Provider | Best for | Notes |
|----------|----------|-------|
| **Resend** | Developer-friendly, React Email | Simple API, generous free tier |
| **Postmark** | Deliverability-critical | Best deliverability, transactional only |
| **SendGrid** | High volume | Part of Twilio, flexible |
| **AWS SES** | Cost-sensitive, high volume | Cheapest at scale, more setup |

## Essential emails

Every SaaS needs these at minimum:
1. **Welcome** — after signup, confirm email
2. **Password reset** — secure token link, expires in 1 hour
3. **Invoice/receipt** — after payment (Stripe can send these automatically)
4. **Trial expiring** — 3 days before trial ends
5. **Team invitation** — when an admin invites a new member

## Best practices

- Use a `from` address on your own domain (not gmail.com)
- Set up SPF, DKIM, and DMARC DNS records for deliverability
- Include an unsubscribe link in marketing emails (legally required)
- Keep transactional emails short and action-oriented
- Test emails in multiple clients (Gmail, Outlook, Apple Mail)
- Use a templating system (React Email, MJML) — don't hand-write HTML email

## Testing

- Use your provider's test mode or sandbox
- Verify emails arrive (check spam folder)
- Test all email templates render correctly
- Verify links in emails point to the right URLs
