# MIZAN — Technical Architecture

## 1. Flutter Application Architecture (Clean Architecture + GetX)

```
mobile/lib/
├── main.dart
├── app/
│   ├── app.dart                  # MaterialApp/GetMaterialApp root, theme + locale wiring
│   ├── bindings/                 # Global GetX bindings
│   └── routes/                   # AppRoutes (route names) + AppPages (GetPage list)
├── core/
│   ├── theme/                    # Design system: colors, typography, spacing, light/dark ThemeData
│   ├── localization/             # AppTranslations, locale controller
│   ├── constants/
│   ├── errors/                   # Failure types, exception mapping
│   ├── network/                  # Dio client, interceptors (auth token, error mapping)
│   ├── utils/                    # Formatters (currency/date), validators
│   └── widgets/                  # Shared/reusable widgets (buttons, cards, empty states, loaders)
├── features/
│   ├── auth/
│   │   ├── data/                 # models, remote data source, repository impl
│   │   ├── domain/                # entities, repository interface, use cases
│   │   └── presentation/          # GetX controllers, bindings, screens, widgets
│   ├── dashboard/
│   ├── transactions/              # Add Transaction flow
│   ├── budgets/                   # Budget & Transfers
│   ├── notifications/
│   ├── ai_assistant/
│   └── settings/
└── generated/                     # (build-generated, e.g. l10n) — gitignored contents
```

**Layering rule per feature:**
- `domain/` has zero Flutter/package dependencies beyond Dart core — pure business entities and repository interfaces (contracts).
- `data/` implements domain repository interfaces, talks to `core/network`, maps DTOs to domain entities.
- `presentation/` depends on `domain/` only (never directly on `data/`), via dependency-injected repository interfaces (GetX bindings wire the concrete implementation).

**State management rule:** GetX `Controller` classes (extending `GetxController`) hold reactive state (`.obs`) per screen/feature; `Bindings` classes wire dependencies (repositories, use cases, controllers) via `Get.lazyPut`. Navigation exclusively via `Get.toNamed`/`AppRoutes`, never raw `Navigator.push`.

## 2. Backend Architecture (FastAPI, Clean Architecture)

```
backend/
├── app/
│   ├── main.py                   # FastAPI app factory, middleware, router registration
│   ├── core/
│   │   ├── config.py              # Settings via pydantic-settings, reads .env
│   │   ├── security.py            # Firebase token verification, auth dependency
│   │   ├── errors.py              # Exception handlers, standardized error envelope
│   │   └── logging.py
│   ├── db/
│   │   ├── session.py             # Async SQLAlchemy engine/session
│   │   └── base.py
│   ├── domain/                    # Entities / business rules, framework-agnostic
│   ├── models/                    # SQLAlchemy ORM models
│   ├── schemas/                   # Pydantic request/response schemas
│   ├── repositories/              # Data-access layer (implements domain-facing interfaces)
│   ├── services/                  # Business logic (budget calc, notification triggers)
│   └── api/
│       └── v1/
│           ├── router.py
│           └── endpoints/         # auth, users, transactions, budgets, bills, goals, notifications, ai
├── alembic/                       # DB migrations
├── tests/
├── requirements.txt
└── Dockerfile
```

**Layering rule:** `api/endpoints` are thin — they validate via Pydantic schemas, call a `service`, return a schema. `services` contain business logic and call `repositories`. `repositories` are the only layer touching SQLAlchemy models directly. This keeps business logic testable without a live DB (repositories mockable).

## 3. AI Agent Architecture (Summary)
Full detail in `AI_AGENT_ARCHITECTURE.md`.

```
ai/
├── agents/
│   ├── graph.py                   # LangGraph StateGraph definition
│   ├── state.py                   # Shared agent state schema
│   ├── router.py                  # Intent routing node
│   └── nodes/                     # analysis, recommendation, bill_assistant, qa_synthesis nodes
├── tools/                         # Tool functions wrapping backend data access
├── prompts/                       # System prompts per node, versioned
└── config.py
```

## 4. Cross-Layer Contracts
- The mobile client and backend communicate exclusively via the versioned REST contract in `API_SPECIFICATION.md`. Client code never assumes backend internal structure.
- The AI layer never accesses the database directly in production topology beyond its declared tools — this keeps the data-access surface auditable (see `SECURITY_REQUIREMENTS.md` §7 on AI-specific risks).

## 5. Dependency Injection
- **Client**: GetX `Bindings` per feature/route.
- **Backend**: FastAPI `Depends()` for request-scoped resources (DB session, current user, services).

## 6. Error Handling Strategy
- **Client**: domain-layer use cases return a `Result<Failure, T>`-style type (sealed class) rather than throwing across layers; presentation maps `Failure` to UI state (error banner, retry action).
- **Backend**: exceptions raised in `services`/`repositories` are domain-specific (e.g., `BudgetNotFoundError`), caught by a global FastAPI exception handler, mapped to the standardized error envelope with correct HTTP status codes.

## 7. Testability
- Domain layers on both sides are pure and unit-testable without I/O.
- Repository interfaces enable mocking in both Dart (via `mocktail`) and Python (via `unittest.mock`/fixtures) — see `TESTING_STRATEGY.md`.
