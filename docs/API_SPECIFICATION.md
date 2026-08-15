# MIZAN — API Specification

Base URL: `/api/v1`. All endpoints (except health check) require `Authorization: Bearer <Firebase ID Token>`. The backend verifies the token and resolves the internal `user_id`.

## 1. Conventions
- JSON request/response bodies.
- Dates: ISO 8601 (`YYYY-MM-DD`), timestamps: RFC 3339.
- Money: numeric string or number with 2 decimal places, in the account/transaction's `currency` field — never floats truncated silently.
- Pagination: `?page=1&page_size=20`, response includes `{ "items": [...], "page": 1, "page_size": 20, "total": 123 }`.

## 2. Auth
Authentication itself is handled client-side via Firebase Auth SDK. The backend does not issue its own tokens; it verifies Firebase ID tokens.

| Endpoint | Method | Description |
|---|---|---|
| `/auth/sync-profile` | POST | Called after first Firebase sign-in to create/update the corresponding `users` row. Body: `{ display_name, preferred_language }` |
| `/users/me` | GET | Current user profile |
| `/users/me` | PATCH | Update profile fields |
| `/users/me` | DELETE | Deletes account (triggers soft-delete + purge job) |

## 3. Transactions

| Endpoint | Method | Description |
|---|---|---|
| `/transactions` | GET | List transactions. Filters: `type`, `category_id`, `date_from`, `date_to`, `account_id` |
| `/transactions` | POST | Create a transaction (income/expense/transfer/savings_contribution) |
| `/transactions/{id}` | GET | Get one |
| `/transactions/{id}` | PATCH | Edit |
| `/transactions/{id}` | DELETE | Delete |

**POST /transactions** request example:
```json
{
  "type": "expense",
  "amount": 150.00,
  "currency": "AED",
  "category_id": "uuid",
  "source_account_id": "uuid",
  "occurred_at": "2026-08-15",
  "notes": "Groceries",
  "is_recurring": false
}
```

## 4. Budgets

| Endpoint | Method | Description |
|---|---|---|
| `/budgets` | GET | List active/archived budgets with computed status |
| `/budgets` | POST | Create budget |
| `/budgets/{id}` | GET | Get one, including `spent_amount`, `remaining_amount`, `percent_used` |
| `/budgets/{id}` | PATCH | Edit |
| `/budgets/{id}` | DELETE | Archive |

## 5. Accounts

| Endpoint | Method | Description |
|---|---|---|
| `/accounts` | GET | List user accounts with cached balances |
| `/accounts` | POST | Create account |
| `/accounts/{id}` | PATCH | Edit |
| `/accounts/{id}` | DELETE | Delete (blocked if it has transaction history; must archive instead) |

## 6. Bills

| Endpoint | Method | Description |
|---|---|---|
| `/bills` | GET | List, filter by `status` |
| `/bills` | POST | Create |
| `/bills/{id}` | PATCH | Edit |
| `/bills/{id}/mark-paid` | POST | Marks paid, creates linked expense transaction |
| `/bills/{id}` | DELETE | Delete |

## 7. Goals

| Endpoint | Method | Description |
|---|---|---|
| `/goals` | GET | List |
| `/goals` | POST | Create |
| `/goals/{id}` | PATCH | Edit |
| `/goals/{id}/contribute` | POST | Adds a savings_contribution transaction and updates `current_amount` |

## 8. Notifications

| Endpoint | Method | Description |
|---|---|---|
| `/notifications` | GET | List, paginated, newest first |
| `/notifications/{id}/read` | POST | Mark one as read |
| `/notifications/read-all` | POST | Mark all as read |
| `/notifications/preferences` | GET/PATCH | Notification category preferences |

## 9. AI Assistant

| Endpoint | Method | Description |
|---|---|---|
| `/ai/ask` | POST | Body: `{ "question": "..." }`. Returns streamed or complete grounded answer + `tools_used` metadata |
| `/ai/insights` | GET | Returns current proactive insight(s) for dashboard surfacing |

## 10. Standardized Error Envelope

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "amount must be greater than 0",
    "field": "amount"
  }
}
```

| HTTP Status | Meaning |
|---|---|
| 400 | Validation error |
| 401 | Missing/invalid auth token |
| 403 | Authenticated but not authorized for this resource |
| 404 | Resource not found |
| 409 | Conflict (e.g., duplicate) |
| 422 | Semantically invalid request |
| 429 | Rate limited (applies to `/ai/ask`) |
| 500 | Unhandled server error (never leaks internals in the message) |

## 11. Rate Limiting
`/ai/ask` is rate-limited per user (e.g., 20 requests/minute) to control LLM cost and abuse, per `SECURITY_REQUIREMENTS.md`.
