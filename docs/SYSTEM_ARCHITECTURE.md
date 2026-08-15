# MIZAN — System Architecture

## 1. High-Level Overview

```
┌─────────────────────┐        ┌──────────────────────────┐        ┌────────────────────┐
│   Flutter Mobile     │  HTTPS │   Backend API (FastAPI)   │        │   PostgreSQL        │
│   (iOS / Android)    │◄──────►│   Python                  │◄──────►│   System of record   │
│   GetX               │        │   Clean Architecture      │        └────────────────────┘
└─────────┬────────────┘        └──────────┬────────────────┘
          │                                  │
          │ Firebase SDK                     │ invokes
          ▼                                  ▼
┌─────────────────────┐        ┌──────────────────────────┐
│ Firebase             │        │  AI Agent Layer            │
│ - Auth                │        │  Python / LangGraph        │
│ - Cloud Messaging     │        │  Tool-based financial       │
│ - Firestore (light,   │        │  reasoning agents           │
│   real-time data)     │        └──────────┬────────────────┘
└─────────────────────┘                     │
                                             ▼
                                  ┌──────────────────────────┐
                                  │  LLM Provider API          │
                                  │  (Anthropic / OpenAI-compat)│
                                  └──────────────────────────┘
```

## 2. Component Responsibilities

### 2.1 Flutter Mobile Client
- Renders UI, owns presentation-layer state via GetX controllers.
- Talks to the Backend API for all financial data (CRUD, budgets, AI).
- Talks to Firebase directly for: authentication token issuance, push notification registration, and (optionally) lightweight real-time collections (e.g., live notification badge count).
- Never talks directly to the database.

### 2.2 Backend API (FastAPI)
- Single source of truth for business logic: validation, budget calculation, notification generation triggers.
- Verifies Firebase ID tokens on every authenticated request (does not re-implement auth).
- Exposes REST endpoints per `API_SPECIFICATION.md`.
- Owns the PostgreSQL connection and all writes/reads to the system of record.
- Invokes the AI Agent Layer in-process (as a Python library/module) or via an internal call for AI Assistant requests — not a separate publicly-exposed service in v1, to minimize operational surface area.

### 2.3 AI Agent Layer (LangGraph)
- Stateless per-request graph execution scoped to a single user's data via explicit tool arguments (no cross-user data access).
- Tools are thin wrappers around backend data-access functions — the agent never fabricates data, only retrieves and reasons over what tools return.
- See `AI_AGENT_ARCHITECTURE.md` for graph design.

### 2.4 Database Layer
- **PostgreSQL**: system of record for users, accounts, transactions, budgets, transfers, bills, goals, savings. Chosen for relational integrity (foreign keys, transactional budget recalculation) — see `DATABASE_DESIGN.md`.
- **Firestore** (optional, v1-light usage): notifications collection for real-time delivery convenience, mirrored/summarized from Postgres-triggered events. This keeps push-relevant reads fast without duplicating all financial data into Firestore.

### 2.5 Firebase Services
- **Firebase Authentication**: identity provider; issues ID tokens the backend verifies.
- **Firebase Cloud Messaging (FCM)**: push notification delivery.
- **Firestore**: as above, notifications only, plus future real-time features.

## 3. Data Flow Examples

### 3.1 Add Expense
`Flutter (GetX controller)` → `POST /api/v1/transactions` (with Firebase ID token) → `Backend verifies token` → `validates payload` → `writes transaction row` → `recalculates affected budget` → `if threshold crossed, creates notification row + publishes to Firestore/FCM` → `response returned` → `client updates local reactive state`.

### 3.2 AI Assistant Question
`Flutter` → `POST /api/v1/ai/ask` (question text) → `Backend authenticates user` → `invokes LangGraph agent graph with user_id` → `agent calls tool(s) against Postgres via backend data-access layer` → `agent synthesizes response` → `streamed back to client`.

## 4. Cross-Cutting Concerns
- **Security**: see `SECURITY_REQUIREMENTS.md`.
- **Error handling**: standardized error envelope across all API responses (see `API_SPECIFICATION.md` §5).
- **Localization**: server returns locale-agnostic raw data (numbers, ISO dates); all formatting/translation happens client-side.
- **Theming**: entirely client-side concern; not modeled server-side.

## 5. Deployment Topology (Target)
See `DEPLOYMENT_PLAN.md`. Summary: containerized backend behind a managed load balancer, managed PostgreSQL instance, Firebase project per environment (dev/staging/prod), mobile app distributed via TestFlight/Play Internal Testing pre-release, then App Store/Play Store.
