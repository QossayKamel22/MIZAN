# MIZAN — Development Roadmap

## v1 (This Build) — Core Product
Documentation, architecture, design system (light/dark), Flutter app scaffold with core screens, backend API scaffold, AI agent architecture with read-only grounded tools, test scaffolding. See `FINAL_TECHNICAL_REPORT.md` for exact implementation status of this milestone.

## v1.1 — Hardening
- Live Firebase project provisioning (Auth, FCM, Firestore rules deployed).
- Live LLM provider connection for AI Assistant.
- Offline support: local write queue + sync on reconnect.
- Full automated test suite passing in CI against a real Flutter/Python toolchain.
- Crash reporting (Firebase Crashlytics) wired in.

## v1.2 — Depth Features
- Recurring transaction automation (auto-create from `recurrence_rule` on schedule).
- CSV/statement import for faster onboarding (manual upload, not live bank linking).
- Expanded AI capabilities: multi-turn memory across sessions, personalized recommendation tuning.
- Home-screen widgets (iOS/Android) for balance/budget glance.

## Phase 2 — Open Banking / Bank Linking
- Integration with a licensed Open Banking aggregator (UAE Central Bank-aligned provider) for automatic transaction import — replacing/augmenting manual entry.
- Requires regulatory review; out of scope until a licensing/partnership path is confirmed.

## Phase 3 — Payments & Bill Actions
- In-app bill payment initiation (via a licensed payment processor partner) — moves MIZAN from tracking-only to acting on the user's behalf, with corresponding compliance requirements (see `SECURITY_REQUIREMENTS.md` §6).

## Phase 4 — Investments
- Investment account tracking, then (further out, with licensing) investment product access.

## Phase 5 — Shared/Family Accounts
- Multi-user shared budgets and accounts (household finance).

## Phase 6 — Web Application
- React-based web companion, consuming the same backend API contract.

## Explicitly Deferred, Not Forgotten
- Admin/staff console.
- Multi-currency automatic conversion.
- Tablet-optimized layouts.

This roadmap is revisited at the end of each phase and updated to reflect actual learnings, not treated as a fixed contract.
