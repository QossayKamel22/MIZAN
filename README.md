# MIZAN (ميزان)

<img width="1254" height="1254" alt="image" src="https://github.com/user-attachments/assets/2f42ec3b-b275-4ff5-ae89-047cbe2145bd" /> 





---

Smart personal financial management for the UAE and Arab market — income, budgets, transfers, bills, savings, goals, and AI-powered financial insight in one trustworthy, premium, Arabic-first app.

---

**Simple + Premium + Modern + Trustworthy + Intelligent.**

## Product Vision

MIZAN centralizes a user's financial life — money in, money out, what's owed, what's being saved for — and layers grounded AI insight on top, without pretending to be a bank or a licensed advisor. See [`docs/PRODUCT_REQUIREMENTS.md`](docs/PRODUCT_REQUIREMENTS.md) for the full product rationale and [`docs/USER_SCENARIOS.md`](docs/USER_SCENARIOS.md) for what that looks like in practice.

## Features (v1)

- **Dashboard** — balance, income/expense summary, budget status, upcoming bills, goal progress, and a top AI insight, prioritized rather than dumped.
- **Add Transaction** — one fast entry point for income, expense, transfer, bill, savings, and goals.
- **Budget & Transfers** — category or overall budgets with real-time spend tracking and threshold alerts.
- **Notifications** — bill reminders, budget alerts, AI insights, goal milestones, in one center.
- **AI Financial Assistant** — ask plain-language questions about your own money, answered from your actual data, never fabricated (see [`docs/AI_AGENT_ARCHITECTURE.md`](docs/AI_AGENT_ARCHITECTURE.md)).
- **Settings** — Light/Dark/System theme, Arabic/English with full RTL/LTR, security, notification preferences.

Full functional detail: [`docs/FUNCTIONAL_REQUIREMENTS.md`](docs/FUNCTIONAL_REQUIREMENTS.md). Future roadmap: [`docs/DEVELOPMENT_ROADMAP.md`](docs/DEVELOPMENT_ROADMAP.md).

## Architecture

```
Flutter Mobile (GetX) ──HTTPS──► FastAPI Backend ──► PostgreSQL
        │                              │
        │ Firebase SDK                 │ invokes (in-process)
        ▼                              ▼
Firebase (Auth, FCM, Firestore)   AI Agent Layer (LangGraph) ──► LLM Provider
```

Full detail: [`docs/SYSTEM_ARCHITECTURE.md`](docs/SYSTEM_ARCHITECTURE.md), [`docs/TECHNICAL_ARCHITECTURE.md`](docs/TECHNICAL_ARCHITECTURE.md).

## Technology Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter / Dart, GetX (state, DI, navigation) |
| Backend | Python, FastAPI, SQLAlchemy (async), Alembic |
| Database | PostgreSQL (system of record), Firestore (real-time notifications) |
| AI | Python, LangGraph, tool-grounded agents |
| Identity & Push | Firebase (Auth, Cloud Messaging) |

## Project Structure

```
MIZAN/
├── docs/            # Full requirements, architecture, and process documentation
├── mobile/          # Flutter application
├── backend/         # FastAPI backend
├── ai/              # LangGraph AI agent layer
├── tests/           # (cross-cutting/integration test notes — see each subproject's own tests/)
├── .env.example
└── .gitignore
```

## Setup

### Mobile
```bash
cd mobile
flutter pub get
flutter run
```

### Backend
```bash
cd backend
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements-dev.txt
cp ../.env.example ../.env   # fill in real values — never commit .env
alembic upgrade head
uvicorn app.main:app --reload
```

### AI Agent Layer
```bash
cd ai
pip install -r requirements.txt
python3 -m pytest tests -v
```

### Environment Configuration
All configuration is via environment variables — see [`.env.example`](.env.example). Never commit a real `.env`, Firebase service account JSON, or API keys.

## Testing

```bash
# Backend
cd backend && pytest --cov=app

# AI agent layer
cd ai && pytest tests -v

# Mobile
cd mobile && flutter test
```

The AI agent test suite and backend test suite have both been executed and pass in this repository's authoring environment (verified against real installed dependencies, not just written). See [`docs/FINAL_TECHNICAL_REPORT.md`](docs/FINAL_TECHNICAL_REPORT.md) for exactly what has been run and verified versus what remains pending.

## Documentation

Start at [`docs/SRS.md`](docs/SRS.md) for the full software requirements specification, or browse the [`/docs`](docs/) directory — every architectural, security, testing, and process decision in this repository is documented there.

## Roadmap

v1 (this build) → hardening (live Firebase, live LLM, offline support) → Open Banking integration → in-app bill payments → investments → shared accounts → web app. Full detail: [`docs/DEVELOPMENT_ROADMAP.md`](docs/DEVELOPMENT_ROADMAP.md).

## Status

This repository reflects real, working, tested code for the architecture described above — not placeholders. It is pre-Milestone-A engineering work (see [`docs/RELEASE_PLAN.md`](docs/RELEASE_PLAN.md)): a live Firebase project, a live LLM provider key, and a deployed PostgreSQL instance are the concrete pending items before this becomes a running product end-to-end. See [`docs/FINAL_TECHNICAL_REPORT.md`](docs/FINAL_TECHNICAL_REPORT.md) for the complete, honest status of every component.

## Screenshots 




<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/1a40bbd4-00cd-4603-9dac-de292b4143da" /> 

---

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/069da15c-6689-4499-bf4b-80e7ac914bd8" /> 

---

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/037e2405-fd85-4e8c-b74b-2a54c1f79982" />

---






## License

Proprietary — all rights reserved.
