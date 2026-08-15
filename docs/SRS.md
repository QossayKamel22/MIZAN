# MIZAN — Software Requirements Specification (SRS)

Version 1.0 · Status: Living document, updated through development phases.

## 1. Introduction

### 1.1 Purpose
This SRS defines the functional and non-functional requirements for MIZAN v1, a Flutter-based personal financial management application with a Python backend and an AI agent layer, targeting the UAE/Arab market. It is written to IEEE-830-informed structure, adapted for an agile, phased fintech build.

### 1.2 Scope
See `PRODUCT_REQUIREMENTS.md` §6 for in/out of scope. This SRS covers the system as a whole: mobile client, backend API, database, AI agents, and Firebase services.

### 1.3 Definitions
- **User**: an authenticated MIZAN account holder.
- **Transaction**: any financial record (income, expense, transfer, bill, savings contribution).
- **Agent**: an AI component in the LangGraph-based system responsible for a bounded financial reasoning task.
- **RTL/LTR**: right-to-left (Arabic) / left-to-right (English) layout direction.

### 1.4 References
`PRODUCT_REQUIREMENTS.md`, `FUNCTIONAL_REQUIREMENTS.md`, `NON_FUNCTIONAL_REQUIREMENTS.md`, `SYSTEM_ARCHITECTURE.md`, `DATABASE_DESIGN.md`, `API_SPECIFICATION.md`, `AI_AGENT_ARCHITECTURE.md`.

## 2. Overall Description

### 2.1 Product Perspective
MIZAN is a new, standalone system composed of:
1. **Mobile client** (Flutter/Dart, GetX) — the primary user interface.
2. **Backend API** (Python/FastAPI) — business logic, validation, orchestration.
3. **Database** (PostgreSQL as system of record; Firestore for real-time/light-weight collections such as notifications) — see `DATABASE_DESIGN.md` for the split rationale.
4. **AI Agent Layer** (Python/LangGraph) — financial reasoning, invoked by the backend.
5. **Firebase services** — authentication, push notifications (FCM), and optional real-time sync.

### 2.2 Product Functions (Summary)
Authentication & profile · Dashboard overview · Transaction entry (income/expense/transfer/bill/savings/goal) · Budget management · Transfer tracking · Bill reminders · Savings & goals tracking · Notification center · AI financial assistant · Settings (theme, language, security) · Localization (AR/EN, RTL/LTR) · Theming (Light/Dark).

### 2.3 User Classes
- **Standard User** — the only user class in v1. All authenticated users have equivalent permissions over their own data; there is no admin console in v1 (documented as future scope).

### 2.4 Operating Environment
- Mobile: iOS and Android via Flutter.
- Backend: containerized Python service, cloud-deployable (see `DEPLOYMENT_PLAN.md`).
- Firebase: standard Firebase project (Auth, Firestore, Cloud Messaging).

### 2.5 Design & Implementation Constraints
- Clean Architecture, SOLID, feature-based modules (see `TECHNICAL_ARCHITECTURE.md`).
- GetX is the sole state-management/DI/navigation approach on the client — no mixed architectures.
- No secrets in source control; all configuration via environment variables.

### 2.6 Assumptions & Dependencies
- Users have a smartphone with biometric or PIN capability for optional app-lock.
- Firebase project provisioning is an external, one-time manual step (pending — see `FINAL_TECHNICAL_REPORT.md`).

## 3. External Interface Requirements

### 3.1 User Interfaces
See `UI_UX_REQUIREMENTS.md` and `NAVIGATION_STRUCTURE.md`.

### 3.2 API Interfaces
See `API_SPECIFICATION.md`.

### 3.3 Hardware Interfaces
Standard smartphone hardware only (biometric sensor optional, used for local app-lock via platform secure storage).

### 3.4 Software Interfaces
- Firebase Authentication SDK
- Firebase Cloud Messaging SDK
- PostgreSQL (via backend ORM)
- LLM provider API (Anthropic/OpenAI-compatible, configurable) for AI agents

## 4. System Features

Full functional breakdown is in `FUNCTIONAL_REQUIREMENTS.md`. Each feature there is traceable to a section of `USE_CASES.md` and `USER_STORIES.md`.

## 5. Non-Functional Requirements

Full detail in `NON_FUNCTIONAL_REQUIREMENTS.md`. Summary categories: performance, security, usability/accessibility, localization quality, reliability, maintainability, scalability.

## 6. Other Requirements

- **Legal/compliance**: MIZAN v1 does not hold funds or execute real payments; UI copy must not imply otherwise. AI output must carry an "informational, not financial advice" disclaimer where applicable (see `SECURITY_REQUIREMENTS.md` §6).
- **Data retention**: user-deletable account and data, per `SECURITY_REQUIREMENTS.md`.

## 7. Requirements Traceability

| Area | Detailed Doc |
|---|---|
| Functional requirements | `FUNCTIONAL_REQUIREMENTS.md` |
| Non-functional requirements | `NON_FUNCTIONAL_REQUIREMENTS.md` |
| User scenarios | `USER_SCENARIOS.md` |
| User stories | `USER_STORIES.md` |
| User flows | `USER_FLOWS.md` |
| Use cases | `USE_CASES.md` |
| System architecture | `SYSTEM_ARCHITECTURE.md` |
| Technical architecture | `TECHNICAL_ARCHITECTURE.md` |
| Database design | `DATABASE_DESIGN.md` |
| API specification | `API_SPECIFICATION.md` |
| AI agent architecture | `AI_AGENT_ARCHITECTURE.md` |
| Security | `SECURITY_REQUIREMENTS.md` |
| UI/UX | `UI_UX_REQUIREMENTS.md` |
| Navigation | `NAVIGATION_STRUCTURE.md` |
| Roadmap & phases | `DEVELOPMENT_ROADMAP.md`, `DEVELOPMENT_PHASES.md` |
| Testing | `TESTING_STRATEGY.md` |
| Deployment & release | `DEPLOYMENT_PLAN.md`, `RELEASE_PLAN.md` |
| Status | `FINAL_TECHNICAL_REPORT.md` |
