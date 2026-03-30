# Error handling

Guidelines for consistent error responses and validation.

## Standard error shape

Every error response uses this format:
```json
{
  "error": "Human-readable message",
  "code": "MACHINE_READABLE_CODE",
  "status": 400
}
```

Validation errors include field-level details:
```json
{
  "error": "Validation failed",
  "code": "VALIDATION_ERROR",
  "status": 400,
  "details": [
    { "field": "email", "message": "Invalid email format" },
    { "field": "age", "message": "Must be at least 18" }
  ]
}
```

## Error codes

Define error codes as constants, not inline strings:
```typescript
export const ErrorCode = {
  NOT_FOUND: "NOT_FOUND",
  VALIDATION_ERROR: "VALIDATION_ERROR",
  UNAUTHORIZED: "UNAUTHORIZED",
  FORBIDDEN: "FORBIDDEN",
  CONFLICT: "CONFLICT",
  INTERNAL: "INTERNAL_ERROR",
} as const;
```

## Input validation

- Validate at the boundary — in middleware or at the top of route handlers
- Use Zod or Valibot for schema validation
- Parse, don't validate: `const data = schema.parse(req.body)` gives you a typed result
- Return all validation errors at once, not one at a time

## Global error handler

Register a single error handler that:
1. Catches all unhandled errors
2. Logs the full error (stack trace, request context)
3. Returns the standard error shape to the client
4. Never leaks stack traces, SQL errors, or internal details in production

## Operational vs programmer errors

- **Operational** (expected): validation failure, auth failure, not found → return appropriate status
- **Programmer** (bugs): null reference, type error, unhandled rejection → log, return 500, fix
- Don't catch programmer errors and return 400 — that hides bugs
