---
name: api-design
description: Design or review REST APIs, define endpoints, request/response schemas, or evaluate API contracts. Use when the user is designing a new API, reviewing an existing one, or asking about HTTP conventions.
---

## API Design Guide

### REST Conventions
- Resources are nouns, plural: `/users`, `/orders`, not `/getUser`, `/createOrder`
- HTTP verbs carry the action: GET (read), POST (create), PUT (replace), PATCH (update), DELETE (remove)
- Nested resources only 1 level deep: `/users/{id}/orders`, not `/users/{id}/orders/{id}/items/{id}`
- Query params for filtering, sorting, pagination: `GET /users?role=admin&sort=createdAt&page=2`

### Status Codes
| Code | When to use |
|------|------------|
| 200 | Successful GET, PUT, PATCH |
| 201 | Successful POST (resource created) |
| 204 | Successful DELETE (no body) |
| 400 | Bad request — client error (validation failed) |
| 401 | Unauthenticated |
| 403 | Authenticated but unauthorized |
| 404 | Resource not found |
| 409 | Conflict (duplicate, state mismatch) |
| 422 | Unprocessable entity (semantic validation) |
| 500 | Server error |

### Response Shape
```json
{
  "data": { },         // the actual resource
  "meta": { },         // pagination, totals (optional)
  "errors": [ ]        // present only on error responses
}
```

Error object:
```json
{
  "code": "VALIDATION_ERROR",
  "message": "Human-readable description",
  "field": "email"
}
```

### Versioning
- Prefer path versioning: `/v1/users`
- Never break existing contracts — add, don't change
- Deprecate with a response header: `Deprecation: true`, `Sunset: <date>`

### Review Checklist
- Are all endpoints idempotent where appropriate?
- Is auth required on every non-public route?
- Are inputs validated and sanitized server-side?
- Are error messages safe to expose (no stack traces, no internal details)?
- Is pagination implemented for any collection endpoint?