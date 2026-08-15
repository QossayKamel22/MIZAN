# MIZAN — Database Design

## 1. Storage Strategy

- **PostgreSQL** is the system of record for all financial data (strong consistency, relational integrity, transactional budget recalculation).
- **Firestore** holds a denormalized `notifications` collection for real-time client delivery convenience; Postgres remains the durable source, with a sync-on-write from the backend.

## 2. Entity-Relationship Overview

```
users ──┬──< accounts
        ├──< transactions >── categories
        ├──< budgets
        ├──< bills
        ├──< goals ──< savings_contributions
        ├──< notifications
        └──< ai_interactions
transactions >── accounts (source_account_id, destination_account_id nullable for transfers)
budgets >── categories (nullable = overall budget)
```

## 3. Core Tables

### 3.1 `users`
| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| firebase_uid | text UNIQUE NOT NULL | links to Firebase Auth identity |
| email | text UNIQUE NOT NULL | |
| display_name | text | |
| preferred_language | text DEFAULT 'ar' | 'ar' \| 'en' |
| base_currency | text DEFAULT 'AED' | |
| created_at | timestamptz | |
| updated_at | timestamptz | |
| deleted_at | timestamptz NULL | soft delete for audit before hard purge |

### 3.2 `accounts`
Represents a tracked money "bucket" (cash, bank account label, wallet) — not a live bank integration in v1.
| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| user_id | UUID FK → users | |
| name | text | e.g. "Main Bank Account", "Cash" |
| type | text | enum: bank, cash, wallet, savings |
| balance_cache | numeric(14,2) | denormalized, recalculated by service layer on write |
| currency | text DEFAULT 'AED' | |
| created_at | timestamptz | |

### 3.3 `categories`
| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| user_id | UUID FK NULL | NULL = system default category, non-null = user-custom |
| name | text | |
| icon | text | |
| type | text | enum: income, expense |

### 3.4 `transactions`
| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| user_id | UUID FK → users | |
| type | text | enum: income, expense, transfer, savings_contribution |
| amount | numeric(14,2) NOT NULL | always positive; sign implied by `type` |
| currency | text DEFAULT 'AED' | |
| category_id | UUID FK NULL | required for income/expense, null for transfer |
| source_account_id | UUID FK → accounts NULL | |
| destination_account_id | UUID FK → accounts NULL | required for transfer |
| goal_id | UUID FK → goals NULL | set when type = savings_contribution |
| bill_id | UUID FK → bills NULL | set when the transaction pays a bill |
| occurred_at | date NOT NULL | |
| notes | text NULL | |
| is_recurring | boolean DEFAULT false | |
| recurrence_rule | text NULL | RFC5545-style RRULE string, if recurring |
| created_at | timestamptz | |

Indexes: `(user_id, occurred_at)`, `(user_id, category_id)`, `(user_id, type)`.

### 3.5 `budgets`
| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| user_id | UUID FK | |
| category_id | UUID FK NULL | NULL = overall budget |
| limit_amount | numeric(14,2) | |
| period_type | text | enum: weekly, monthly, custom |
| period_start | date | |
| period_end | date | |
| alert_thresholds | int[] DEFAULT '{80,100}' | percentages |
| status | text DEFAULT 'active' | active, archived |
| created_at | timestamptz | |

### 3.6 `bills`
| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| user_id | UUID FK | |
| payee_name | text | |
| amount | numeric(14,2) | |
| due_date | date | |
| recurrence_rule | text NULL | |
| reminder_days_before | int DEFAULT 3 | |
| status | text DEFAULT 'upcoming' | upcoming, due, overdue, paid |
| created_at | timestamptz | |

### 3.7 `goals`
| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| user_id | UUID FK | |
| name | text | |
| target_amount | numeric(14,2) | |
| current_amount | numeric(14,2) DEFAULT 0 | denormalized sum of contributions |
| target_date | date NULL | |
| category | text NULL | e.g. "wedding", "emergency_fund", "travel" |
| status | text DEFAULT 'active' | active, achieved, archived |
| created_at | timestamptz | |

### 3.8 `notifications`
| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| user_id | UUID FK | |
| type | text | bill_reminder, budget_alert, ai_insight, goal_milestone, account_activity |
| title | text | |
| body | text | |
| deep_link | text NULL | client route to open |
| is_read | boolean DEFAULT false | |
| created_at | timestamptz | |

Mirrored (post-write) to Firestore `users/{uid}/notifications/{id}` for real-time client delivery.

### 3.9 `ai_interactions`
| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| user_id | UUID FK | |
| question | text | |
| answer | text | |
| tools_used | jsonb | array of tool names + args (no raw sensitive payload beyond necessary) |
| created_at | timestamptz | |

Used for quality review and future personalization; not exposed to other users, purge policy per `SECURITY_REQUIREMENTS.md`.

## 4. Referential Integrity & Cascades
- `ON DELETE CASCADE` from `users` to all owned tables, triggered only by the account-deletion flow (soft-delete first, hard purge job after retention window — see `SECURITY_REQUIREMENTS.md`).
- `transactions.category_id` `ON DELETE RESTRICT` for system categories; user-custom categories cascade-nullify referencing transactions to a default "Uncategorized" category instead of deleting history.

## 5. Migration Strategy
Alembic-managed migrations in `backend/alembic/`. Every schema change ships as a reviewed migration file, never manual production DDL.

## 6. Future Expansion Considerations
- `transactions` can be partitioned by `occurred_at` (monthly) once volume warrants it — schema already supports this without redesign.
- Multi-currency: `currency` columns exist from v1; conversion-rate service is future scope.
- Shared/family accounts: would introduce an `account_members` join table — not required in v1 schema but the `accounts` table's design does not block it.
